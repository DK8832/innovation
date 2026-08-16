import http from 'node:http';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));


const DATA_FILE = path.join(__dirname, '..', 'assets', 'data', 'certificates.seed.json');
const ROLLING_FILE = path.join(__dirname, '..', 'assets', 'data', 'rolling_exams.json');
const PORT = Number(process.env.PORT || 8787);
const OLLAMA_BASE_URL = String(process.env.OLLAMA_BASE_URL || 'http://127.0.0.1:11434').replace(/\/$/, '');
const DEFAULT_AI_MODEL = String(process.env.LOCAL_AI_MODEL || 'qwen3:4b').trim();
const ALLOWED_AI_MODELS = Object.freeze({
  'qwen3:14b': { level: '높음', label: '14B' },
  'qwen3:8b': { level: '보통', label: '8B' },
  'qwen3:4b': { level: '낮음', label: '4B' }
});
const LOCAL_AI_CONTEXT = Math.max(2048, Number(process.env.LOCAL_AI_CONTEXT || 4096));
const LOCAL_AI_KEEP_ALIVE = String(process.env.LOCAL_AI_KEEP_ALIVE || '30m').trim();


function describeFetchError(error) {
  if (!(error instanceof Error)) return String(error);
  const parts = [error.message];
  const cause = error.cause;
  if (cause && typeof cause === 'object') {
    if (cause.code) parts.push(String(cause.code));
    if (cause.errno && String(cause.errno) !== String(cause.code || '')) parts.push(String(cause.errno));
    if (cause.address) parts.push(String(cause.address));
    if (cause.port) parts.push(String(cause.port));
  }
  return [...new Set(parts.filter(Boolean))].join(' / ');
}

const CERTION_APP_CONTEXT = `
CERTI:ON은 여러 자격시험의 정보를 한곳에서 확인하고, 공식 일정 데이터를 AI가 이해하기 쉽게 정리해 주는 자격증 일정·플래너 앱입니다.
현재 앱의 주요 기능:
1. 홈: 오늘 날짜를 기준으로 가까운 접수·시험·발표 일정과 추천 정보를 빠르게 확인합니다.
2. 탐색: 자격증/시험을 검색하고 분야별로 찾아볼 수 있습니다.
3. 일정: 접수 시작·접수 마감·시험일·발표일을 달력/일정 형태로 확인합니다.
4. AI 핵심 브리핑: 선택한 자격증의 30초 요약, 응시자격, 합격기준, 준비 팁, 다음 일정을 보여줍니다.
5. AI 추가 질문: CERTI:ON의 공식 일정 DB와 오늘 날짜를 근거로 시험 일정, 접수기간, 발표일, 응시자격 등을 질문할 수 있습니다.
6. 출처 검증: 답변과 카드에 공식 1차 출처와 출처 정보를 함께 보여 사용자가 원문을 확인할 수 있도록 합니다.
7. MY/플래너: 관심 자격증, 가까운 일정 알림 대상, 취득 완료 자격증 등을 한곳에서 관리합니다.
8. 비교/의사결정 보조: 자격증의 일정, 난이도, 과목 수 등 앱에 저장된 정보를 비교해 준비 우선순위를 판단하는 데 도움을 줍니다.
핵심 원칙은 'AI가 대신 결정하는 앱'이 아니라 '공식 정보를 더 빨리 이해하고 사용자가 직접 검증하도록 돕는 AI'입니다.
`;


function currentKstDateIso() {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone: 'Asia/Seoul', year: 'numeric', month: '2-digit', day: '2-digit'
  }).format(new Date());
}

const FIXED_DB = JSON.parse(await fs.readFile(DATA_FILE, 'utf8'));
const ROLLING_DB = JSON.parse(await fs.readFile(ROLLING_FILE, 'utf8'));

function readDb() {
  return FIXED_DB;
}

function readRollingDb() {
  return ROLLING_DB;
}

function send(res, status, data) {
  res.writeHead(status, {
    'content-type': 'application/json; charset=utf-8',
    'access-control-allow-origin': '*',
    'access-control-allow-headers': 'content-type,x-sync-secret',
    'access-control-allow-methods': 'GET,POST,OPTIONS',
    'access-control-allow-private-network': 'true',
    'cache-control': 'no-store'
  });
  res.end(JSON.stringify(data));
}

async function readBody(req) {
  let body = '';
  for await (const chunk of req) {
    body += chunk;
    if (body.length > 1024 * 1024) throw new Error('request too large');
  }
  return body ? JSON.parse(body) : {};
}

function resolveModel(requestedModel) {
  const candidate = String(requestedModel || '').trim();
  if (Object.prototype.hasOwnProperty.call(ALLOWED_AI_MODELS, candidate)) return candidate;
  if (Object.prototype.hasOwnProperty.call(ALLOWED_AI_MODELS, DEFAULT_AI_MODEL)) return DEFAULT_AI_MODEL;
  return 'qwen3:14b';
}

async function fetchJson(url, options = {}) {
  // 로컬 AI/모델 로딩에는 강제 시간 제한을 두지 않습니다.
  const response = await fetch(url, options);
  let data = {};
  try { data = await response.json(); } catch { data = {}; }
  if (!response.ok) {
    const message = data?.error || data?.message || `HTTP ${response.status}`;
    throw new Error(typeof message === 'string' ? message : JSON.stringify(message));
  }
  return data;
}

function cleanOllamaAssistantText(value) {
  let text = String(value || '').replace(/\u0000/g, '').trim();
  if (!text) return '';

  // Prefer an explicit final-answer envelope when present. This prevents any
  // reasoning transcript from being returned to the phone even if a Qwen
  // runtime ignores think=false.
  const finalMatch = text.match(/<final>\s*([\s\S]*?)(?:<\/final>|<\|im_end\|>|$)/i);
  if (finalMatch) {
    text = String(finalMatch[1] || '').trim();
  } else {
    text = text.replace(/<think>[\s\S]*?<\/think>/gi, '').trim();
    const lastThinkEnd = text.toLowerCase().lastIndexOf('</think>');
    if (lastThinkEnd >= 0) text = text.slice(lastThinkEnd + '</think>'.length).trim();
  }

  text = text
    .replace(/^<\|im_start\|>assistant\s*/i, '')
    .replace(/<\|im_end\|>[\s\S]*$/i, '')
    .replace(/<\/?final>/gi, '')
    .replace(/^assistant\s*[:：]\s*/i, '')
    .trim();
  return text;
}

function looksLikeInternalReasoning(value) {
  const text = String(value || '').toLowerCase();
  const markers = [
    'wait,', 'wait.', 'i need to', 'i should', 'we need to', "the user's",
    'the user is', 'the answer should', 'make sure to', 'let me ',
    'current date is', "today's date", 'resultdateknown', 'applyend',
    'need to present'
  ];
  let hits = 0;
  for (const marker of markers) if (text.includes(marker)) hits += 1;
  return hits >= 2;
}

function isMeaningfulFinalAnswer(value) {
  const text = cleanOllamaAssistantText(value);
  if (!text) return false;
  if (looksLikeInternalReasoning(text)) return false;

  const compact = text.replace(/\s+/g, '');
  const lowered = compact.toLowerCase();
  const placeholders = new Set([
    '.', '..', '...', '…', '……', '-', '--', '---',
    '답변중', '생각중', '처리중', 'loading', 'thinking',
    'ok', 'okay'
  ]);
  if (placeholders.has(lowered)) return false;

  const semanticChars = compact.match(/[0-9A-Za-z가-힣]/g) || [];
  if (semanticChars.length < 6) return false;

  return true;
}

function withNoThinkDirective(messages) {
  const copy = messages.map(item => ({ ...item }));
  for (let i = copy.length - 1; i >= 0; i--) {
    if (copy[i]?.role === 'user') {
      copy[i].content = `${String(copy[i].content || '')}\n\n/no_think\n중요: 내부 추론, 분석 메모, 영어 사고 과정은 출력하지 마세요. 최종 한국어 답변만 <final>...</final> 안에 작성하세요.`;
      break;
    }
  }
  return copy;
}

async function requestOllamaChat(messages, selectedModel, numPredict) {
  return await fetchJson(`${OLLAMA_BASE_URL}/api/chat`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      model: selectedModel,
      messages,
      stream: false,
      think: false,
      keep_alive: LOCAL_AI_KEEP_ALIVE,
      options: {
        temperature: 0.12,
        top_p: 0.82,
        num_ctx: LOCAL_AI_CONTEXT,
        num_predict: numPredict,
        repeat_penalty: 1.08
      }
    })
  });
}

function qwenRoleName(role) {
  const value = String(role || 'user').toLowerCase();
  return value === 'system' || value === 'assistant' ? value : 'user';
}

async function requestOllamaGenerate(messages, selectedModel, numPredict) {
  // Hard non-thinking Qwen3 prompt. The assistant turn is prefilled with an
  // empty think block, then <final>. In raw mode Ollama does not add another
  // chat template around it.
  const prompt = messages
    .map(item => `<|im_start|>${qwenRoleName(item?.role)}\n${String(item?.content || '')}<|im_end|>`)
    .join('\n') + '\n<|im_start|>assistant\n<think>\n\n</think>\n\n<final>\n';

  return await fetchJson(`${OLLAMA_BASE_URL}/api/generate`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      model: selectedModel,
      prompt,
      raw: true,
      stream: false,
      keep_alive: LOCAL_AI_KEEP_ALIVE,
      options: {
        temperature: 0.10,
        top_p: 0.80,
        num_ctx: LOCAL_AI_CONTEXT,
        num_predict: numPredict,
        repeat_penalty: 1.08,
        stop: ['</final>', '<|im_end|>']
      }
    })
  });
}

async function ollamaChat(messages, { model = DEFAULT_AI_MODEL, numPredict = 800 } = {}) {
  const selectedModel = resolveModel(model);
  const noThinkMessages = withNoThinkDirective(messages);

  // Attempt 1: Ollama native non-thinking mode.
  let payload = await requestOllamaChat(noThinkMessages, selectedModel, numPredict);
  let content = cleanOllamaAssistantText(payload?.message?.content || '');
  if (isMeaningfulFinalAnswer(content)) {
    return { content, model: selectedModel, raw: payload, transport: 'chat' };
  }

  // Attempt 2: retry once. Any response that still looks like a reasoning
  // transcript is discarded rather than shown to the user.
  payload = await requestOllamaChat(noThinkMessages, selectedModel, Math.max(1100, numPredict));
  content = cleanOllamaAssistantText(payload?.message?.content || '');
  if (isMeaningfulFinalAnswer(content)) {
    return { content, model: selectedModel, raw: payload, transport: 'chat-retry' };
  }

  // Attempt 3: hard Qwen3 no-think prompt through raw /api/generate.
  const generated = await requestOllamaGenerate(noThinkMessages, selectedModel, Math.max(1100, numPredict));
  content = cleanOllamaAssistantText(generated?.response || '');
  if (isMeaningfulFinalAnswer(content)) {
    return { content, model: selectedModel, raw: generated, transport: 'raw-hard-nothink' };
  }

  const doneReason = String(
    generated?.done_reason || payload?.done_reason || payload?.message?.done_reason || ''
  ).trim();
  const suffix = doneReason ? ` (done_reason=${doneReason})` : '';
  throw new Error(`Ollama ${selectedModel}가 최종 답변 대신 내부 분석을 생성해 표시를 차단했습니다${suffix}. 같은 질문을 다시 시도하세요.`);
}

async function probeOllama(requestedModel) {
  const selectedModel = resolveModel(requestedModel);
  try {
    const version = await fetchJson(`${OLLAMA_BASE_URL}/api/version`);
    const tags = await fetchJson(`${OLLAMA_BASE_URL}/api/tags`);
    const models = Array.isArray(tags?.models)
      ? tags.models.map(x => String(x?.name || x?.model || ''))
      : [];
    const installed = models.some(name => name === selectedModel || name.startsWith(`${selectedModel}:`));

    return {
      configured: true,
      ready: installed,
      provider: 'Ollama',
      model: selectedModel,
      modelLevel: ALLOWED_AI_MODELS[selectedModel]?.level || '',
      ollamaVersion: String(version?.version || ''),
      installedModels: models.filter(name => Object.prototype.hasOwnProperty.call(ALLOWED_AI_MODELS, name)),
      message: installed
        ? `${selectedModel} 설치 확인됨. 첫 질문에서는 모델 로딩 때문에 시간이 걸릴 수 있습니다.`
        : `${selectedModel} 모델이 설치되지 않았습니다. ollama pull ${selectedModel} 명령을 실행하세요.`
    };
  } catch (error) {
    return {
      configured: false,
      ready: false,
      provider: 'Ollama',
      model: selectedModel,
      message: `Ollama 연결 실패: ${describeFetchError(error)}. PC에서 Ollama API(http://127.0.0.1:11434)가 실행 중인지 확인하세요.`
    };
  }
}

function normalizeText(value) {
  return String(value || '').toLowerCase().replace(/\s+/g, '').replace(/[^0-9a-z가-힣]/g, '');
}

const commonAliases = new Map([
  ['정처기', '정보처리기사'],
  ['정보처리', '정보처리기사'],
  ['컴활', '컴퓨터활용능력'],
  ['컴퓨터활용', '컴퓨터활용능력'],
  ['한능검', '한국사능력검정시험'],
  ['한국사', '한국사능력검정시험'],
  ['리눅스', '리눅스마스터'],
  ['sql개발자', 'SQLD'],
  ['sqld', 'SQLD'],
  ['sqlp', 'SQLP'],
  ['토익', 'TOEIC'],
  ['정보기기', '정보기기운용기능사'],
  ['전기기능사', '전기기능사'],
  ['전기기사', '전기기사']
]);

function relevantExams(exams, question, selectedId, today) {
  const normalizedQuestion = normalizeText(question);
  const expanded = [normalizedQuestion];
  for (const [alias, canonical] of commonAliases.entries()) {
    if (normalizedQuestion.includes(normalizeText(alias))) expanded.push(normalizeText(canonical));
  }

  const scored = exams.map(exam => {
    const name = normalizeText(exam.name);
    const organizer = normalizeText(exam.organizer);
    let score = exam.id === selectedId ? 10 : 0;
    for (const q of expanded) {
      if (!q) continue;
      if (name.includes(q) || q.includes(name)) score += 100;
      const tokens = q.match(/[가-힣a-z0-9]{2,}/g) || [];
      for (const token of tokens) {
        if (name.includes(token)) score += 18;
        if (organizer.includes(token)) score += 4;
      }
    }
    const examTime = Date.parse(`${exam.examDate}T00:00:00Z`);
    const todayTime = Date.parse(`${today}T00:00:00Z`);
    if (Number.isFinite(examTime) && examTime >= todayTime) {
      const days = Math.round((examTime - todayTime) / 86400000);
      score += Math.max(0, 12 - Math.min(12, days / 30));
    }
    return { exam, score };
  });

  scored.sort((a, b) => b.score - a.score || String(a.exam.examDate).localeCompare(String(b.exam.examDate)));
  const strong = scored.filter(x => x.score >= 18).slice(0, 12).map(x => x.exam);
  if (strong.length) return strong;
  return scored.filter(x => String(x.exam.examDate) >= today).slice(0, 10).map(x => x.exam);
}

function compactExam(exam) {
  return {
    id: exam.id,
    name: exam.name,
    organizer: exam.organizer,
    category: exam.category,
    applyStart: exam.applyStart,
    applyEnd: exam.applyEnd,
    examDate: exam.examDate,
    resultDate: exam.resultDate,
    resultDateKnown: exam.resultDateKnown,
    eligibility: exam.eligibility,
    subjects: exam.subjects,
    passRule: exam.passRule,
    officialSource: exam.officialSource,
    sourceUrl: exam.sourceUrl,
    scheduleNote: exam.scheduleNote
  };
}

function daysBetweenIso(fromIso, toIso) {
  const from = Date.parse(`${fromIso}T00:00:00Z`);
  const to = Date.parse(`${toIso}T00:00:00Z`);
  if (!Number.isFinite(from) || !Number.isFinite(to)) return null;
  return Math.round((to - from) / 86400000);
}

function deterministicVerifiedAnswer(question, selected, relevant, today) {
  const q = String(question || '').trim().toLowerCase();

  const appQuestion =
    q.includes('이 앱') || q.includes('앱 설명') || q.includes('certi:on') ||
    q.includes('certion') || q.includes('기능') || q.includes('뭐하는 앱') ||
    q.includes('무슨 앱');

  if (appQuestion) {
    return [
      'CERTI:ON은 자격증·시험 정보를 한곳에서 확인하고, 공식 일정 데이터를 AI가 이해하기 쉽게 정리해 주는 자격증 일정·플래너 앱입니다.',
      '주요 기능은 가까운 접수·시험 일정 확인, 자격증 검색, 일정 달력, AI 핵심 브리핑·추가 질문, 공식 출처 확인, MY/플래너, 자격증 비교입니다.',
      '핵심은 AI가 임의로 정보를 만드는 것이 아니라 저장된 공식 일정 데이터를 바탕으로 빠르게 이해하고 사용자가 원문 출처를 직접 검증할 수 있게 돕는 것입니다.'
    ].join('\n');
  }

  const exam = relevant?.[0] || selected;
  if (!exam) {
    return '현재 선택된 시험의 공식 데이터가 없어 답변을 만들 수 없습니다. 자격증을 선택한 뒤 다시 질문해주세요.';
  }

  const lines = [];
  const dExam = daysBetweenIso(today, exam.examDate);
  const dApplyEnd = daysBetweenIso(today, exam.applyEnd);

  if (q.includes('접수') || q.includes('신청') || q.includes('원서')) {
    lines.push(`${exam.name} 접수기간은 ${exam.applyStart}~${exam.applyEnd}입니다.`);
    if (dApplyEnd != null) {
      lines.push(dApplyEnd === 0 ? '오늘이 접수 마감일입니다.' : dApplyEnd > 0 ? `접수 마감까지 ${dApplyEnd}일 남았습니다.` : '저장된 해당 회차의 접수기간은 종료되었습니다.');
    }
  } else if (q.includes('시험') || q.includes('언제') || q.includes('일정')) {
    lines.push(`${exam.name} 시험일은 ${exam.examDate}입니다.`);
    if (dExam != null) {
      lines.push(dExam === 0 ? '오늘이 시험일입니다.' : dExam > 0 ? `시험일까지 ${dExam}일 남았습니다.` : '저장된 해당 회차의 시험일은 지났습니다.');
    }
    lines.push(`접수기간은 ${exam.applyStart}~${exam.applyEnd}입니다.`);
  } else if (q.includes('발표') || q.includes('결과') || q.includes('합격자')) {
    lines.push(exam.resultDateKnown
      ? `${exam.name} 결과 발표일은 ${exam.resultDate}입니다.`
      : `${exam.name} 결과 발표일은 현재 저장된 공식 데이터에서 확정되지 않았습니다.`);
  } else if (q.includes('응시') || q.includes('자격')) {
    lines.push(`${exam.name} 응시자격: ${exam.eligibility}`);
  } else if (q.includes('과목')) {
    lines.push(`${exam.name} 시험과목: ${(exam.subjects || []).join(' · ')}`);
  } else if (q.includes('합격') || q.includes('기준') || q.includes('몇 점')) {
    lines.push(`${exam.name} 합격기준: ${exam.passRule}`);
  } else {
    lines.push(`${exam.name} 공식 일정 요약입니다.`);
    lines.push(`접수 ${exam.applyStart}~${exam.applyEnd} · 시험 ${exam.examDate}${exam.resultDateKnown ? ` · 발표 ${exam.resultDate}` : ''}`);
    lines.push(`응시자격: ${exam.eligibility}`);
    lines.push(`합격기준: ${exam.passRule}`);
  }

  lines.push(`출처: ${exam.officialSource || '앱에 저장된 공식 1차 출처'}`);
  return lines.filter(Boolean).join('\n');
}

async function answerBrief(certificateId, question, clientDate, requestedModel) {
  const db = readDb();
  const selected = db.exams.find(item => item.id === certificateId) || null;
  const today = /^\d{4}-\d{2}-\d{2}$/.test(String(clientDate || ''))
    ? String(clientDate)
    : currentKstDateIso();
  const q = String(question || '').trim().slice(0, 1600);
  if (!q) return { status: 400, body: { error: '질문을 입력해주세요.' } };

  const relevant = relevantExams(db.exams, q, certificateId, today);
  const system = [
    '당신은 CERTI:ON 앱에 내장된 한국어 로컬 AI 도우미입니다.',
    '사용자의 질문 의도를 먼저 구분해서 답하세요: (A) CERTI:ON 앱 자체의 기능/사용법, (B) 자격시험 일정·응시자격·합격기준 등 검증 가능한 시험 사실, (C) 일반적인 공부 방법·개념 설명.',
    '(A) 앱 기능/사용법 질문은 함께 제공된 CERTI:ON 앱 설명을 근거로 구체적으로 답하세요. 현재 선택된 자격증 데이터만 보고 “앱 정보가 없다”고 답하면 안 됩니다.',
    '(B) 시험 날짜, 접수기간, 발표일, 응시자격, 합격기준처럼 정확성이 중요한 사실은 반드시 함께 제공된 CERTI:ON 공식 일정 데이터만 근거로 답하세요.',
    '내부 지식과 CERTI:ON 공식 데이터가 충돌하면 공식 데이터를 우선합니다.',
    '공식 데이터에 없는 미래 날짜나 접수기간, 발표일을 추측하거나 만들어내지 마세요.',
    '(C) 일반적인 학습 전략이나 개념 설명에는 모델의 일반 지식을 사용할 수 있지만, 최신 제도나 일정처럼 변할 수 있는 사실은 공식 확인이 필요하다고 밝혀 주세요.',
    '사용자 질문에 다른 자격증 이름이 있으면 현재 선택 자격증에 억지로 맞추지 말고 질문 속 자격증을 찾아 답하세요.',
    '정처기=정보처리기사, 컴활=컴퓨터활용능력, 한능검=한국사능력검정시험, 토익=TOEIC 같은 흔한 줄임말을 이해하세요.',
    '일정 질문에는 가능한 경우 접수 시작/마감, 시험일, 발표일, 오늘 기준 D-Day와 현재 단계를 함께 알려주세요.',
    '공식 데이터에 없는 시험 사실은 “현재 저장된 공식 데이터에서는 확인되지 않습니다”라고 분명히 말하세요.',
    '답변은 한국어로 자연스럽고 이해하기 쉽게 작성하세요. 간단한 질문은 2~5문장, 기능 소개처럼 목록이 유용한 질문은 짧은 항목으로 정리해도 됩니다.',
    '사용자에게 내부 추론 과정은 보여주지 말고 최종 답변만 제시하세요.'
  ].join('\n');

  const user = [
    `CERTI:ON 앱 설명=${CERTION_APP_CONTEXT}`,
    `오늘 날짜=${today} (대한민국 KST)`,
    `현재 화면 선택 자격증=${selected ? selected.name : '없음'}`,
    `관련 공식 일정 데이터=${JSON.stringify(relevant.map(compactExam))}`,
    `사용자 질문=${q}`
  ].join('\n');

  const selectedModel = resolveModel(requestedModel);
  let answer = '';
  let transport = '';
  let fallbackUsed = false;
  let aiWarning = '';

  try {
    const reply = await ollamaChat([
      { role: 'system', content: system },
      { role: 'user', content: user }
    ], { model: selectedModel, numPredict: 800 });
    answer = cleanOllamaAssistantText(reply.content);
    transport = reply.transport || 'ollama';
  } catch (error) {
    aiWarning = error instanceof Error ? error.message : String(error);
  }

  if (!isMeaningfulFinalAnswer(answer)) {
    answer = deterministicVerifiedAnswer(q, selected, relevant, today);
    fallbackUsed = true;
    transport = 'verified-deterministic-fallback';
  }

  const source = relevant[0] || selected;
  return {
    status: 200,
    body: {
      answer,
      sourceUrl: source?.sourceUrl || '',
      officialSource: source?.officialSource || '',
      today,
      model: selectedModel,
      provider: fallbackUsed ? 'CERTI:ON verified fallback' : 'Ollama',
      transport,
      fallbackUsed,
      aiWarning: fallbackUsed ? aiWarning : '',
      local: true
    }
  };
}

const server = http.createServer(async (req, res) => {
  if (req.method === 'OPTIONS') return send(res, 204, {});
  const url = new URL(req.url || '/', `http://${req.headers.host || 'localhost'}`);

  try {
    if (req.method === 'GET' && url.pathname === '/health') {
      return send(res, 200, {
        ok: true,
        service: 'CERTI:ON local AI backend',
        aiConfigured: true,
        provider: 'Ollama',
        model: resolveModel(DEFAULT_AI_MODEL),
        defaultModel: resolveModel(DEFAULT_AI_MODEL),
        supportedModels: Object.entries(ALLOWED_AI_MODELS).map(([model, info]) => ({ model, ...info })),
        ollamaBaseUrl: OLLAMA_BASE_URL,
        today: currentKstDateIso(),
        backendVersion: 'v9-one-click-optimized'
      });
    }

    if (req.method === 'GET' && url.pathname === '/api/ai/status') {
      const probe = await probeOllama(url.searchParams.get('model'));
      return send(res, 200, { ok: true, ...probe, today: currentKstDateIso() });
    }


    if (req.method === 'GET' && url.pathname === '/api/certificates') {
      const db = readDb();
      return send(res, 200, {
        updatedAt: db.updatedAt,
        sourcePolicy: db.sourcePolicy,
        count: db.exams.length,
        certificates: db.exams
      });
    }

    if (req.method === 'GET' && url.pathname === '/api/rolling') {
      const rolling = readRollingDb();
      return send(res, 200, {
        updatedAt: rolling.updatedAt,
        sourcePolicy: rolling.sourcePolicy,
        count: (rolling.exams || rolling.rollingExams || []).length,
        rollingExams: rolling.exams || rolling.rollingExams || []
      });
    }



    if (req.method === 'POST' && url.pathname === '/api/ai/brief') {
      const body = await readBody(req);
      const answer = await answerBrief(body.certificateId, body.question, body.clientDate, body.model);
      return send(res, answer.status, answer.body);
    }


    return send(res, 404, { error: 'not found' });
  } catch (error) {
    return send(res, 500, { error: error instanceof Error ? error.message : String(error) });
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`CERTI:ON local AI backend: http://0.0.0.0:${PORT}`);
  console.log('LAN mode enabled: phone can connect to this PC on the same Wi-Fi.');
  console.log(`Ollama: ${OLLAMA_BASE_URL}`);
  console.log(`Default model: ${resolveModel(DEFAULT_AI_MODEL)} / selectable=qwen3:14b,qwen3:8b,qwen3:4b / context=${LOCAL_AI_CONTEXT}`);
});
