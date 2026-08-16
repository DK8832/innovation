$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$packageConfig = Join-Path $projectRoot '.dart_tool\package_config.json'
if (-not (Test-Path $packageConfig)) {
    throw 'package_config.json not found. Run flutter pub get first.'
}

$config = Get-Content -Raw -Encoding UTF8 $packageConfig | ConvertFrom-Json
$pkg = $config.packages | Where-Object { $_.name -eq 'llama_flutter_android' } | Select-Object -First 1
if (-not $pkg) {
    throw 'llama_flutter_android was not found in package_config.json.'
}

$rootUri = [string]$pkg.rootUri
$pkgRoot = $null
try {
    $uri = [System.Uri]$rootUri
    if ($uri.IsAbsoluteUri -and $uri.IsFile) {
        $pkgRoot = $uri.LocalPath
    }
} catch {}

if (-not $pkgRoot) {
    $baseDir = Split-Path -Parent $packageConfig
    $relative = [System.Uri]::UnescapeDataString($rootUri.Replace('/', [IO.Path]::DirectorySeparatorChar))
    $pkgRoot = [IO.Path]::GetFullPath((Join-Path $baseDir $relative))
}

$cpp = Join-Path $pkgRoot 'android\src\main\cpp\jni_wrapper.cpp'
if (-not (Test-Path $cpp)) {
    throw "llama JNI source not found: $cpp"
}

$raw = Get-Content -Raw -Encoding UTF8 $cpp
$marker = 'CERTION_UTF8_STREAM_FIX_V5'
if ($raw.Contains($marker)) {
    Write-Host '[OK] llama.cpp Korean UTF-8 streaming fix is already applied.'
    exit 0
}

# Preserve the original package source once so the pub cache can be restored manually if desired.
$backup = "$cpp.certi_on_original"
if (-not (Test-Path $backup)) {
    Copy-Item -LiteralPath $cpp -Destination $backup -Force
}

$helperNeedle = 'extern "C" JNIEXPORT jstring JNICALL'
$helperIndex = $raw.IndexOf($helperNeedle)
if ($helperIndex -lt 0) {
    throw 'Could not locate JNI helper insertion point. Plugin source layout changed.'
}

$helper = @'
// CERTION_UTF8_STREAM_FIX_V5
// llama_token_to_piece() may split one UTF-8 code point across token boundaries.
// Never sanitize an individual token piece: buffering incomplete tails avoids U+FFFD
// replacement characters in Korean and other multi-byte text.
static size_t certionCompleteUtf8Prefix(const std::string& input, bool* invalid) {
    if (invalid) *invalid = false;
    const unsigned char* bytes = reinterpret_cast<const unsigned char*>(input.data());
    const size_t len = input.size();
    size_t i = 0;

    while (i < len) {
        const unsigned char c = bytes[i];
        if ((c & 0x80) == 0) {
            i++;
            continue;
        }

        int n = 0;
        if ((c & 0xE0) == 0xC0) n = 2;
        else if ((c & 0xF0) == 0xE0) n = 3;
        else if ((c & 0xF8) == 0xF0) n = 4;
        else {
            if (invalid) *invalid = true;
            return i;
        }

        // Keep an unfinished sequence for the next token piece.
        if (i + static_cast<size_t>(n) > len) return i;

        if (!isValidUTF8(reinterpret_cast<const char*>(bytes + i), static_cast<size_t>(n))) {
            if (invalid) *invalid = true;
            return i;
        }
        i += static_cast<size_t>(n);
    }
    return i;
}

static jstring certionNewStringFromUtf8(JNIEnv* env, const std::string& text) {
    std::vector<jchar> utf16;
    utf16.reserve(text.size());
    const unsigned char* b = reinterpret_cast<const unsigned char*>(text.data());
    size_t i = 0;

    while (i < text.size()) {
        uint32_t cp = 0xFFFD;
        size_t n = 1;
        const unsigned char c = b[i];
        if ((c & 0x80) == 0) {
            cp = c;
            n = 1;
        } else if ((c & 0xE0) == 0xC0 && i + 1 < text.size()) {
            cp = ((c & 0x1F) << 6) | (b[i + 1] & 0x3F);
            n = 2;
        } else if ((c & 0xF0) == 0xE0 && i + 2 < text.size()) {
            cp = ((c & 0x0F) << 12) | ((b[i + 1] & 0x3F) << 6) | (b[i + 2] & 0x3F);
            n = 3;
        } else if ((c & 0xF8) == 0xF0 && i + 3 < text.size()) {
            cp = ((c & 0x07) << 18) | ((b[i + 1] & 0x3F) << 12) |
                 ((b[i + 2] & 0x3F) << 6) | (b[i + 3] & 0x3F);
            n = 4;
        }

        if (cp <= 0xFFFF) {
            utf16.push_back(static_cast<jchar>(cp));
        } else if (cp <= 0x10FFFF) {
            cp -= 0x10000;
            utf16.push_back(static_cast<jchar>(0xD800 + (cp >> 10)));
            utf16.push_back(static_cast<jchar>(0xDC00 + (cp & 0x3FF)));
        } else {
            utf16.push_back(static_cast<jchar>(0xFFFD));
        }
        i += n;
    }

    if (utf16.empty()) return env->NewString(nullptr, 0);
    return env->NewString(utf16.data(), static_cast<jsize>(utf16.size()));
}

static void certionEmitUtf8(JNIEnv* env, jobject callback, jmethodID invokeMethod, const std::string& text) {
    if (text.empty()) return;
    jstring tokenStr = certionNewStringFromUtf8(env, text);
    env->CallObjectMethod(callback, invokeMethod, tokenStr);
    env->DeleteLocalRef(tokenStr);
}

'@

$raw = $raw.Insert($helperIndex, $helper)

$loopNeedle = '    // Generation loop'
$loopIndex = $raw.IndexOf($loopNeedle)
if ($loopIndex -lt 0) {
    throw 'Could not locate generation loop. Plugin source layout changed.'
}
$pendingDecl = @'
    // CERTI:ON keeps partial UTF-8 bytes between llama token pieces.
    std::string certion_utf8_pending;
    certion_utf8_pending.reserve(32);

'@
$raw = $raw.Insert($loopIndex, $pendingDecl)

$decodeStartNeedle = '        // Decode token to string'
$decodeStart = $raw.IndexOf($decodeStartNeedle, $loopIndex)
if ($decodeStart -lt 0) {
    throw 'Could not locate token decode block. Plugin source layout changed.'
}
$decodeEndNeedle = '        env->DeleteLocalRef(token_str);'
$decodeEndStart = $raw.IndexOf($decodeEndNeedle, $decodeStart)
if ($decodeEndStart -lt 0) {
    throw 'Could not locate token callback end. Plugin source layout changed.'
}
$decodeEnd = $decodeEndStart + $decodeEndNeedle.Length

$newDecodeBlock = @'
        // Decode token to raw bytes. A single Unicode character can span
        // multiple llama tokens, so hold only the incomplete UTF-8 tail.
        char buffer[256];
        int32_t length = llama_token_to_piece(g_vocab, new_token_id, buffer, sizeof(buffer), 0, true);
        if (length > 0) {
            certion_utf8_pending.append(buffer, static_cast<size_t>(length));

            bool invalidUtf8 = false;
            const size_t ready = certionCompleteUtf8Prefix(certion_utf8_pending, &invalidUtf8);
            if (invalidUtf8) {
                // Genuine malformed data: sanitize once across the accumulated bytes.
                const std::string safe = sanitizeUTF8(certion_utf8_pending.data(), certion_utf8_pending.size());
                certionEmitUtf8(env, g_token_callback, invokeMethod, safe);
                certion_utf8_pending.clear();
            } else if (ready > 0) {
                certionEmitUtf8(env, g_token_callback, invokeMethod, certion_utf8_pending.substr(0, ready));
                certion_utf8_pending.erase(0, ready);
            }
        }
'@

$raw = $raw.Substring(0, $decodeStart) + $newDecodeBlock + $raw.Substring($decodeEnd)

$finishNeedle = '    LOGI("Generation loop finished.");'
$finishIndex = $raw.IndexOf($finishNeedle, $loopIndex)
if ($finishIndex -lt 0) {
    throw 'Could not locate generation-loop finish marker. Plugin source layout changed.'
}
$finishBlock = @'
    // Emit any complete prefix and silently drop only an unfinished trailing code point
    // if generation stopped exactly in the middle of a multi-byte UTF-8 sequence.
    if (!certion_utf8_pending.empty()) {
        bool invalidUtf8 = false;
        const size_t ready = certionCompleteUtf8Prefix(certion_utf8_pending, &invalidUtf8);
        if (invalidUtf8) {
            const std::string safe = sanitizeUTF8(certion_utf8_pending.data(), certion_utf8_pending.size());
            certionEmitUtf8(env, g_token_callback, invokeMethod, safe);
        } else if (ready > 0) {
            certionEmitUtf8(env, g_token_callback, invokeMethod, certion_utf8_pending.substr(0, ready));
        }
        certion_utf8_pending.clear();
    }

'@
$raw = $raw.Insert($finishIndex, $finishBlock)

# Guard against the exact old behavior that caused U+FFFD on split Korean bytes.
if ($raw.Contains('piece = sanitizeUTF8(buffer, length);')) {
    throw 'Old per-token UTF-8 sanitization is still present; refusing to continue.'
}
if (-not $raw.Contains($marker) -or -not $raw.Contains('certion_utf8_pending')) {
    throw 'UTF-8 patch verification failed.'
}

Set-Content -LiteralPath $cpp -Value $raw -Encoding UTF8
Write-Host '[OK] llama.cpp Korean UTF-8 streaming fix applied.'
Write-Host "[INFO] Patched plugin source: $cpp"
Write-Host '[INFO] Split Korean UTF-8 bytes are now buffered across token boundaries instead of becoming U+FFFD.'
