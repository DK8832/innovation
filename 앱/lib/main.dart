import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:llama_flutter_android/llama_flutter_android.dart';

void main() {
  runApp(const CertiOnApp());
}

class CertiOnApp extends StatelessWidget {
  const CertiOnApp({super.key});

  @override
  Widget build(BuildContext context) {
    const scheme = ColorScheme.light(
      primary: Color(0xFF024AD8),
      onPrimary: Colors.white,
      secondary: Color(0xFFCF4500),
      onSecondary: Colors.white,
      surface: Color(0xFFFCFBFA),
      onSurface: Color(0xFF141413),
      error: Color(0xFFCF4500),
      onError: Colors.white,
      outline: Color(0xFFD1CDC7),
      outlineVariant: Color(0xFFE8E2DA),
      shadow: Color(0xFF141413),
      scrim: Color(0xFF141413),
      inverseSurface: Color(0xFF141413),
      onInverseSurface: Color(0xFFFCFBFA),
      inversePrimary: Color(0xFF024AD8),
      surfaceTint: Color(0xFF024AD8),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CERTI:ON',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF3F0EE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 74,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE8E2DA),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color:
                  selected ? const Color(0xFF024AD8) : const Color(0xFF696969),
            );
          }),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationThemeData(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Color(0xFF696969)),
          prefixIconColor: const Color(0xFF696969),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD1CDC7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF024AD8), width: 1.4),
          ),
        ),
      ),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        const designWidth = 430.0;
        final scale = media.size.width < designWidth
            ? media.size.width / designWidth
            : 1.0;
        final designHeight = media.size.height / scale;
        final visibleWidth = media.size.width < designWidth
            ? media.size.width
            : designWidth;
        return ColoredBox(
          color: const Color(0xFFF3F0EE),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: visibleWidth,
              height: media.size.height,
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: designWidth,
                  height: designHeight,
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );
      },
      home: const AppShell(),
    );
  }
}

class Exam {
  const Exam({
    required this.id,
    required this.name,
    required this.organizer,
    required this.category,
    required this.applyStart,
    required this.applyEnd,
    required this.examDate,
    required this.resultDate,
    required this.badge,
    required this.color,
    required this.eligibility,
    required this.subjects,
    required this.passRule,
    required this.officialSource,
    required this.aiSummary,
    required this.tip,
    required this.difficulty,
    this.sourceUrl = '',
    this.scheduleNote = '',
    this.resultDateKnown = true,
  });

  final String id;
  final String name;
  final String organizer;
  final String category;
  final DateTime applyStart;
  final DateTime applyEnd;
  final DateTime examDate;
  final DateTime resultDate;
  final String badge;
  final Color color;
  final String eligibility;
  final List<String> subjects;
  final String passRule;
  final String officialSource;
  final String aiSummary;
  final String tip;
  final int difficulty;
  final String sourceUrl;
  final String scheduleNote;
  final bool resultDateKnown;

  factory Exam.fromJson(Map<String, dynamic> j) => Exam(
        id: j['id'] as String,
        name: j['name'] as String,
        organizer: j['organizer'] as String,
        category: j['category'] as String,
        applyStart: DateTime.parse(j['applyStart'] as String),
        applyEnd: DateTime.parse(j['applyEnd'] as String),
        examDate: DateTime.parse(j['examDate'] as String),
        resultDate: DateTime.parse(j['resultDate'] as String),
        badge: j['badge'] as String,
        color: Color(0xFF000000 |
            int.parse((j['color'] as String).replaceFirst('#', ''), radix: 16)),
        eligibility: j['eligibility'] as String,
        subjects: List<String>.from(j['subjects'] as List),
        passRule: j['passRule'] as String,
        officialSource: j['officialSource'] as String,
        aiSummary: j['aiSummary'] as String,
        tip: j['tip'] as String,
        difficulty: j['difficulty'] as int,
        sourceUrl: (j['sourceUrl'] ?? '') as String,
        scheduleNote: (j['scheduleNote'] ?? '') as String,
        resultDateKnown: (j['resultDateKnown'] ?? true) as bool,
      );
}

class RollingExam {
  const RollingExam({
    required this.id,
    required this.name,
    required this.organizer,
    required this.category,
    required this.badge,
    required this.eligibility,
    required this.schedule,
    required this.result,
    required this.difficulty,
    required this.sourceUrl,
    required this.benefit,
  });

  final String id;
  final String name;
  final String organizer;
  final String category;
  final String badge;
  final String eligibility;
  final String schedule;
  final String result;
  final int difficulty;
  final String sourceUrl;
  final String benefit;

  factory RollingExam.fromJson(Map<String, dynamic> j) => RollingExam(
        id: (j['id'] ?? '') as String,
        name: (j['name'] ?? '') as String,
        organizer: (j['organizer'] ?? '') as String,
        category: (j['category'] ?? '기타') as String,
        badge: (j['badge'] ?? '상시') as String,
        eligibility: (j['eligibility'] ?? '공식 종목안내 확인') as String,
        schedule: (j['schedule'] ?? '상시 운영') as String,
        result: (j['result'] ?? '공식 발표 기준 확인') as String,
        difficulty: (j['difficulty'] ?? 2) as int,
        sourceUrl: (j['sourceUrl'] ?? '') as String,
        benefit: (j['benefit'] ?? '') as String,
      );
}

final Map<String, Future<Uint8List>> _certiAssetByteCache =
    <String, Future<Uint8List>>{};

Future<Uint8List> _loadCertiAssetBytes(String assetPath) {
  return _certiAssetByteCache.putIfAbsent(assetPath, () async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  });
}

class AppAssetThumb extends StatelessWidget {
  const AppAssetThumb({
    super.key,
    required this.assetPath,
    this.width = 56,
    this.height = 56,
    this.borderRadius = 18,
  });

  final String assetPath;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: FutureBuilder<Uint8List>(
          future: _loadCertiAssetBytes(assetPath),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.contain,
                gaplessPlayback: true,
                filterQuality: FilterQuality.medium,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint(
                      'CERTI:ON image decode failed: $assetPath -> $error');
                  return _assetFallback();
                },
              );
            }
            if (snapshot.hasError) {
              debugPrint(
                  'CERTI:ON image asset failed: $assetPath -> ${snapshot.error}');
              return _assetFallback();
            }
            return Container(color: const Color(0xFFF3F0EC));
          },
        ),
      ),
    );
  }

  Widget _assetFallback() {
    return Container(
      color: const Color(0xFFE8E2DA),
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined,
          color: Color(0xFF696969)),
    );
  }
}

String categoryImageAsset(String category) {
  switch (category) {
    case 'AI':
      return 'assets/images/cat_ai.png';
    case '데이터':
      return 'assets/images/cat_data.png';
    case 'IT·개발':
      return 'assets/images/cat_it.png';
    case '전기·전자':
      return 'assets/images/cat_electric.png';
    case '사무·OA':
      return 'assets/images/cat_office.png';
    case '어학':
      return 'assets/images/cat_language.png';
    case '서비스·경영':
      return 'assets/images/cat_management.png';
    case '안전·산업':
    case '건축·토목':
      return 'assets/images/cat_safety.png';
    case '디자인':
      return 'assets/images/cat_design.png';
    case '공기업·공무원':
      return 'assets/images/cat_public.png';
    default:
      return 'assets/images/cat_misc.png';
  }
}

List<RollingExam> rollingExams = <RollingExam>[];
DateTime? localSnapshotUpdatedAt;

final List<Exam> bundledExams = <Exam>[
  Exam(
    id: 'ai-basic2608',
    name: 'AI상식 2608회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'AI',
    applyStart: DateTime(2026, 7, 13),
    applyEnd: DateTime(2026, 7, 22),
    examDate: DateTime(2026, 8, 22),
    resultDate: DateTime(2026, 9, 11),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['인공지능 기초', '생성형 AI 및 프롬프트/서비스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: 'AI상식 2608회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'gtq8',
    name: 'GTQ/GTQi 제8회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: '디자인',
    applyStart: DateTime(2026, 7, 22),
    applyEnd: DateTime(2026, 7, 29),
    examDate: DateTime(2026, 8, 22),
    resultDate: DateTime(2026, 8, 22),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'GTQ/GTQi 제8회 정기시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'sns2603',
    name: 'SNS광고마케터 1급 2603회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '서비스·경영',
    applyStart: DateTime(2026, 7, 6),
    applyEnd: DateTime(2026, 7, 17),
    examDate: DateTime(2026, 8, 22),
    resultDate: DateTime(2026, 9, 11),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['SNS 이해', 'SNS 광고 마케팅'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: 'SNS광고마케터 1급 2603회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'sqld62',
    name: 'SQLD SQL개발자 제62회',
    organizer: '한국데이터산업진흥원',
    category: '데이터',
    applyStart: DateTime(2026, 7, 20),
    applyEnd: DateTime(2026, 7, 24),
    examDate: DateTime(2026, 8, 22),
    resultDate: DateTime(2026, 9, 11),
    badge: 'DATAQ',
    color: const Color(0xFFCF4500),
    eligibility: '종목별 응시자격은 데이터자격검정 공식 안내 확인',
    subjects: ['데이터 모델링의 이해', 'SQL 기본 및 활용'],
    passRule: '종목별 합격기준은 데이터자격검정 공식 안내 확인',
    officialSource: '데이터자격검정 공식 시험일정',
    aiSummary: '2026년 데이터자격검정 공식 일정에 게시된 SQLD SQL개발자 제62회 일정입니다.',
    tip: '접수 마감 직전에는 결제와 시험장 선택이 혼잡할 수 있어 가능한 초기에 접수하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.dataq.or.kr/www/accept/schedule.do',
    scheduleNote: '2026년 데이터자격검정 공식 시험일정 기준.',
  ),
  Exam(
    id: 'sqlp55',
    name: 'SQLP SQL전문가 제55회',
    organizer: '한국데이터산업진흥원',
    category: '데이터',
    applyStart: DateTime(2026, 7, 20),
    applyEnd: DateTime(2026, 7, 24),
    examDate: DateTime(2026, 8, 22),
    resultDate: DateTime(2026, 9, 18),
    badge: 'DATAQ',
    color: const Color(0xFFCF4500),
    eligibility: '종목별 응시자격은 데이터자격검정 공식 안내 확인',
    subjects: ['데이터 모델링의 이해', 'SQL 기본 및 활용', 'SQL 고급 활용 및 튜닝'],
    passRule: '종목별 합격기준은 데이터자격검정 공식 안내 확인',
    officialSource: '데이터자격검정 공식 시험일정',
    aiSummary: '2026년 데이터자격검정 공식 일정에 게시된 SQLP SQL전문가 제55회 일정입니다.',
    tip: '접수 마감 직전에는 결제와 시험장 선택이 혼잡할 수 있어 가능한 초기에 접수하세요.',
    difficulty: 5,
    sourceUrl: 'https://www.dataq.or.kr/www/accept/schedule.do',
    scheduleNote: '2026년 데이터자격검정 공식 시험일정 기준.',
  ),
  Exam(
    id: 'dia2608',
    name: '디지털정보활용능력 2608회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '사무·OA',
    applyStart: DateTime(2026, 7, 13),
    applyEnd: DateTime(2026, 7, 22),
    examDate: DateTime(2026, 8, 22),
    resultDate: DateTime(2026, 9, 11),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['프레젠테이션', '스프레드시트', '워드프로세서 등 선택과목'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '디지털정보활용능력 2608회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'coding2-2608',
    name: '코딩능력마스터 2급 2608회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 7, 13),
    applyEnd: DateTime(2026, 7, 22),
    examDate: DateTime(2026, 8, 22),
    resultDate: DateTime(2026, 9, 11),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['컴퓨팅 사고', '프로그래밍 및 알고리즘'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '코딩능력마스터 2급 2608회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'prompt2-2603',
    name: '프롬프트엔지니어 2급 2603회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'AI',
    applyStart: DateTime(2026, 7, 6),
    applyEnd: DateTime(2026, 7, 17),
    examDate: DateTime(2026, 8, 22),
    resultDate: DateTime(2026, 9, 11),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['인공지능 기초', '생성형 AI 및 프롬프트/서비스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '프롬프트엔지니어 2급 2603회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'itq-special15',
    name: 'ITQ 제15회 특별시험',
    organizer: '한국생산성본부(KPC)',
    category: '사무·OA',
    applyStart: DateTime(2026, 7, 16),
    applyEnd: DateTime(2026, 7, 22),
    examDate: DateTime(2026, 8, 23),
    resultDate: DateTime(2026, 8, 23),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'ITQ 제15회 특별시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'toeic576',
    name: 'TOEIC 제576회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 8, 12),
    applyEnd: DateTime(2026, 8, 20),
    examDate: DateTime(2026, 8, 23),
    resultDate: DateTime(2026, 9, 3),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제576회 공식 일정입니다. 시험일 2026-08-23, 성적발표 2026-09-03.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 07-06~08-10, 특별추가 08-12~08-20',
  ),
  Exam(
    id: 'dia2628',
    name: '디지털정보활용능력 2628회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '사무·OA',
    applyStart: DateTime(2026, 7, 20),
    applyEnd: DateTime(2026, 7, 29),
    examDate: DateTime(2026, 8, 29),
    resultDate: DateTime(2026, 9, 18),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['프레젠테이션', '스프레드시트', '워드프로세서 등 선택과목'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '디지털정보활용능력 2628회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'loss12-2',
    name: '손해평가사 제12회 2차',
    organizer: '한국산업인력공단',
    category: '서비스·경영',
    applyStart: DateTime(2026, 8, 20),
    applyEnd: DateTime(2026, 8, 21),
    examDate: DateTime(2026, 8, 29),
    resultDate: DateTime(2026, 11, 18),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '손해평가사 제12회 2차의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '빈자리 추가접수 기준. 정기접수 07-20~07-24.',
  ),
  Exam(
    id: 'toeic577',
    name: 'TOEIC 제577회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 7, 13),
    applyEnd: DateTime(2026, 8, 17),
    examDate: DateTime(2026, 8, 30),
    resultDate: DateTime(2026, 9, 8),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제577회 공식 일정입니다. 시험일 2026-08-30, 성적발표 2026-09-08.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 07-13~08-17, 특별추가 08-19~08-27',
  ),
  Exam(
    id: 'tourguide26-written',
    name: '관광통역안내사 제26회 필기',
    organizer: '한국산업인력공단',
    category: '서비스·경영',
    applyStart: DateTime(2026, 7, 6),
    applyEnd: DateTime(2026, 7, 10),
    examDate: DateTime(2026, 9, 5),
    resultDate: DateTime(2026, 10, 21),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '관광통역안내사 제26회 필기의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '정기접수는 종료되었으나 시험일이 향후 6개월 범위에 있어 표시.',
  ),
  Exam(
    id: 'big13f',
    name: '빅데이터분석기사 제13회 필기',
    organizer: '한국데이터산업진흥원',
    category: '데이터',
    applyStart: DateTime(2026, 8, 3),
    applyEnd: DateTime(2026, 8, 7),
    examDate: DateTime(2026, 9, 5),
    resultDate: DateTime(2026, 9, 23),
    badge: 'DATAQ',
    color: const Color(0xFFCF4500),
    eligibility: '종목별 응시자격은 데이터자격검정 공식 안내 확인',
    subjects: ['빅데이터 분석 기획', '빅데이터 탐색', '빅데이터 모델링', '빅데이터 결과 해석'],
    passRule: '종목별 합격기준은 데이터자격검정 공식 안내 확인',
    officialSource: '데이터자격검정 공식 시험일정',
    aiSummary: '2026년 데이터자격검정 공식 일정에 게시된 빅데이터분석기사 제13회 필기 일정입니다.',
    tip: '접수 마감 직전에는 결제와 시험장 선택이 혼잡할 수 있어 가능한 초기에 접수하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.dataq.or.kr/www/accept/schedule.do',
    scheduleNote: '2026년 데이터자격검정 공식 시험일정 기준.',
  ),
  Exam(
    id: 'toeic578',
    name: 'TOEIC 제578회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 7, 20),
    applyEnd: DateTime(2026, 8, 24),
    examDate: DateTime(2026, 9, 6),
    resultDate: DateTime(2026, 9, 15),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제578회 공식 일정입니다. 시험일 2026-09-06, 성적발표 2026-09-15.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 07-20~08-24, 특별추가 08-26~09-03',
  ),
  Exam(
    id: 'aibt3',
    name: 'AIBT 제3회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: 'AI',
    applyStart: DateTime(2026, 8, 6),
    applyEnd: DateTime(2026, 8, 12),
    examDate: DateTime(2026, 9, 12),
    resultDate: DateTime(2026, 9, 12),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'AIBT 제3회 정기시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'cat9',
    name: 'CAD 실무능력평가 제9회',
    organizer: '한국생산성본부(KPC)',
    category: '디자인',
    applyStart: DateTime(2026, 8, 6),
    applyEnd: DateTime(2026, 8, 12),
    examDate: DateTime(2026, 9, 12),
    resultDate: DateTime(2026, 9, 12),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'CAD 실무능력평가 제9회 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'itq9',
    name: 'ITQ 제9회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: '사무·OA',
    applyStart: DateTime(2026, 8, 6),
    applyEnd: DateTime(2026, 8, 12),
    examDate: DateTime(2026, 9, 12),
    resultDate: DateTime(2026, 9, 12),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'ITQ 제9회 정기시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'sw5',
    name: 'SW코딩자격 제5회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 8, 6),
    applyEnd: DateTime(2026, 8, 12),
    examDate: DateTime(2026, 9, 12),
    resultDate: DateTime(2026, 9, 12),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'SW코딩자격 제5회 정기시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'linux1-2602-1',
    name: '리눅스마스터 1급 2602회 1차',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 7, 27),
    applyEnd: DateTime(2026, 8, 7),
    examDate: DateTime(2026, 9, 12),
    resultDate: DateTime(2026, 10, 2),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['리눅스 일반', '리눅스 운영 및 관리', '리눅스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '리눅스마스터 1급 2602회 1차의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'linux2-2603-2',
    name: '리눅스마스터 2급 2603회 2차',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 7, 28),
    applyEnd: DateTime(2026, 8, 7),
    examDate: DateTime(2026, 9, 12),
    resultDate: DateTime(2026, 10, 2),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['리눅스 일반', '리눅스 운영 및 관리', '리눅스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '리눅스마스터 2급 2603회 2차의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'youth25-written',
    name: '청소년상담사 제25회 필기',
    organizer: '한국산업인력공단',
    category: '서비스·경영',
    applyStart: DateTime(2026, 9, 3),
    applyEnd: DateTime(2026, 9, 4),
    examDate: DateTime(2026, 9, 12),
    resultDate: DateTime(2026, 10, 21),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '청소년상담사 제25회 필기의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '빈자리 추가접수 기준. 정기접수 07-20~07-24.',
  ),
  Exam(
    id: 'qnet-2026-4-webdesign',
    name: '웹디자인개발기능사 · 2026 기능사 제4회',
    organizer: '한국산업인력공단',
    category: '디자인',
    applyStart: DateTime(2026, 8, 24),
    applyEnd: DateTime(2026, 8, 27),
    examDate: DateTime(2026, 9, 16),
    resultDate: DateTime(2026, 12, 11),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: '기능사 종목별 응시자격 제한 여부는 Q-Net 상세정보 확인',
    subjects: ['디자인 일반', '인터넷 일반', '웹그래픽디자인'],
    passRule: '필기 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary: '제4회 필기 접수는 8월 24~27일, 필기시험은 9월 16~21일입니다. 실기접수는 10월 12~15일입니다.',
    tip: '기능사 제4회는 필기와 실기 접수일이 분리되어 있으므로 두 번 모두 캘린더에 확인하세요.',
    difficulty: 3,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=7798&jmInfoDivCcd=B0',
    scheduleNote:
        '필기 09-16~09-21, 필기 합격 10-07, 실기 접수 10-12~10-15, 실기 11-14~12-02, 최종 합격 12-11.',
  ),
  Exam(
    id: 'qnet-2026-4-electrician',
    name: '전기기능사 · 2026 기능사 제4회',
    organizer: '한국산업인력공단',
    category: '전기·전자',
    applyStart: DateTime(2026, 8, 24),
    applyEnd: DateTime(2026, 8, 27),
    examDate: DateTime(2026, 9, 16),
    resultDate: DateTime(2026, 12, 11),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: '기능사 종목별 응시자격 제한 여부는 Q-Net 상세정보 확인',
    subjects: ['전기이론', '전기기기', '전기설비'],
    passRule: '필기 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary: '제4회 필기 접수는 8월 24~27일, 필기시험은 9월 16~21일입니다. 실기접수는 10월 12~15일입니다.',
    tip: '기능사 제4회는 필기와 실기 접수일이 분리되어 있으므로 두 번 모두 캘린더에 확인하세요.',
    difficulty: 3,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=7780&jmInfoDivCcd=B0',
    scheduleNote:
        '필기 09-16~09-21, 필기 합격 10-07, 실기 접수 10-12~10-15, 실기 11-14~12-02, 최종 합격 12-11.',
  ),
  Exam(
    id: 'qnet-2026-4-electronic',
    name: '전자기능사 · 2026 기능사 제4회',
    organizer: '한국산업인력공단',
    category: '전기·전자',
    applyStart: DateTime(2026, 8, 24),
    applyEnd: DateTime(2026, 8, 27),
    examDate: DateTime(2026, 9, 16),
    resultDate: DateTime(2026, 12, 11),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: '기능사 종목별 응시자격 제한 여부는 Q-Net 상세정보 확인',
    subjects: ['전기전자공학', '전자계산기일반', '전자측정', '전자기기 및 음향영상기기'],
    passRule: '필기 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary: '제4회 필기 접수는 8월 24~27일, 필기시험은 9월 16~21일입니다. 실기접수는 10월 12~15일입니다.',
    tip: '기능사 제4회는 필기와 실기 접수일이 분리되어 있으므로 두 번 모두 캘린더에 확인하세요.',
    difficulty: 3,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=6790&jmInfoDivCcd=B0',
    scheduleNote:
        '필기 09-16~09-21, 필기 합격 10-07, 실기 접수 10-12~10-15, 실기 11-14~12-02, 최종 합격 12-11.',
  ),
  Exam(
    id: 'qnet-2026-4-network-device',
    name: '정보기기운용기능사 · 2026 기능사 제4회',
    organizer: '한국산업인력공단',
    category: 'IT·개발',
    applyStart: DateTime(2026, 8, 24),
    applyEnd: DateTime(2026, 8, 27),
    examDate: DateTime(2026, 9, 16),
    resultDate: DateTime(2026, 12, 11),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: '기능사 종목별 응시자격 제한 여부는 Q-Net 상세정보 확인',
    subjects: ['전자계산기일반', '정보기기일반', '정보통신일반', '정보통신업무규정'],
    passRule: '필기 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary: '제4회 필기 접수는 8월 24~27일, 필기시험은 9월 16~21일입니다. 실기접수는 10월 12~15일입니다.',
    tip: '기능사 제4회는 필기와 실기 접수일이 분리되어 있으므로 두 번 모두 캘린더에 확인하세요.',
    difficulty: 3,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=6892&jmInfoDivCcd=B0',
    scheduleNote:
        '필기 09-16~09-21, 필기 합격 10-07, 실기 접수 10-12~10-15, 실기 11-14~12-02, 최종 합격 12-11.',
  ),
  Exam(
    id: 'ai-program2-2601',
    name: 'AI 프로그래밍 2급 2601회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'AI',
    applyStart: DateTime(2026, 8, 3),
    applyEnd: DateTime(2026, 8, 14),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 10, 16),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['인공지능 기초', '생성형 AI 및 프롬프트/서비스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: 'AI 프로그래밍 2급 2601회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'dap66',
    name: 'DAP 데이터아키텍처전문가 제66회',
    organizer: '한국데이터산업진흥원',
    category: '데이터',
    applyStart: DateTime(2026, 8, 14),
    applyEnd: DateTime(2026, 8, 21),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 10, 16),
    badge: 'DATAQ',
    color: const Color(0xFFCF4500),
    eligibility: '종목별 응시자격은 데이터자격검정 공식 안내 확인',
    subjects: [
      '전사아키텍처 이해',
      '데이터 요건 분석',
      '데이터 표준화',
      '데이터 모델링',
      '데이터베이스 설계와 이용',
      '데이터 품질관리 이해'
    ],
    passRule: '종목별 합격기준은 데이터자격검정 공식 안내 확인',
    officialSource: '데이터자격검정 공식 시험일정',
    aiSummary: '2026년 데이터자격검정 공식 일정에 게시된 DAP 데이터아키텍처전문가 제66회 일정입니다.',
    tip: '접수 마감 직전에는 결제와 시험장 선택이 혼잡할 수 있어 가능한 초기에 접수하세요.',
    difficulty: 5,
    sourceUrl: 'https://www.dataq.or.kr/www/accept/schedule.do',
    scheduleNote: '2026년 데이터자격검정 공식 시험일정 기준.',
  ),
  Exam(
    id: 'dasp61',
    name: 'DAsP 데이터아키텍처준전문가 제61회',
    organizer: '한국데이터산업진흥원',
    category: '데이터',
    applyStart: DateTime(2026, 8, 14),
    applyEnd: DateTime(2026, 8, 21),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 10, 8),
    badge: 'DATAQ',
    color: const Color(0xFFCF4500),
    eligibility: '종목별 응시자격은 데이터자격검정 공식 안내 확인',
    subjects: ['전사아키텍처 이해', '데이터 요건 분석', '데이터 표준화', '데이터 모델링'],
    passRule: '종목별 합격기준은 데이터자격검정 공식 안내 확인',
    officialSource: '데이터자격검정 공식 시험일정',
    aiSummary: '2026년 데이터자격검정 공식 일정에 게시된 DAsP 데이터아키텍처준전문가 제61회 일정입니다.',
    tip: '접수 마감 직전에는 결제와 시험장 선택이 혼잡할 수 있어 가능한 초기에 접수하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.dataq.or.kr/www/accept/schedule.do',
    scheduleNote: '2026년 데이터자격검정 공식 시험일정 기준.',
  ),
  Exam(
    id: 'erp5',
    name: 'ERP정보관리사 제5회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: '서비스·경영',
    applyStart: DateTime(2026, 8, 19),
    applyEnd: DateTime(2026, 8, 26),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 9, 19),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'ERP정보관리사 제5회 정기시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'gtq9',
    name: 'GTQ/GTQi/GTQid 제9회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: '디자인',
    applyStart: DateTime(2026, 8, 19),
    applyEnd: DateTime(2026, 8, 26),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 9, 19),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'GTQ/GTQi/GTQid 제9회 정기시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'sam2603',
    name: '검색광고마케터 1급 2603회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '서비스·경영',
    applyStart: DateTime(2026, 8, 3),
    applyEnd: DateTime(2026, 8, 14),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 10, 16),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['온라인 비즈니스 및 디지털 마케팅', '검색광고 실무 활용', '검색광고 활용전략'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '검색광고마케터 1급 2603회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'dia2609',
    name: '디지털정보활용능력 2609회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '사무·OA',
    applyStart: DateTime(2026, 8, 10),
    applyEnd: DateTime(2026, 8, 19),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 10, 16),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['프레젠테이션', '스프레드시트', '워드프로세서 등 선택과목'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '디지털정보활용능력 2609회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'housing29-2',
    name: '주택관리사보 제29회 2차',
    organizer: '한국산업인력공단',
    category: '기타',
    applyStart: DateTime(2026, 9, 10),
    applyEnd: DateTime(2026, 9, 11),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 12, 2),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '주택관리사보 제29회 2차의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '빈자리 추가접수 기준. 정기접수 08-10~08-14.',
  ),
  Exam(
    id: 'coding1-2609',
    name: '코딩능력마스터 1급 2609회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 8, 10),
    applyEnd: DateTime(2026, 8, 19),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 10, 16),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['컴퓨팅 사고', '프로그래밍 및 알고리즘'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '코딩능력마스터 1급 2609회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'coding3-2609',
    name: '코딩능력마스터 3급 2609회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 8, 10),
    applyEnd: DateTime(2026, 8, 19),
    examDate: DateTime(2026, 9, 19),
    resultDate: DateTime(2026, 10, 16),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['컴퓨팅 사고', '프로그래밍 및 알고리즘'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '코딩능력마스터 3급 2609회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'toeic579',
    name: 'TOEIC 제579회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 8, 3),
    applyEnd: DateTime(2026, 9, 7),
    examDate: DateTime(2026, 9, 20),
    resultDate: DateTime(2026, 9, 29),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제579회 공식 일정입니다. 시험일 2026-09-20, 성적발표 2026-09-29.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 08-03~09-07, 특별추가 09-09~09-17',
  ),
  Exam(
    id: 'admin14-2',
    name: '행정사 제14회 2차',
    organizer: '한국산업인력공단',
    category: '공기업·공무원',
    applyStart: DateTime(2026, 7, 27),
    applyEnd: DateTime(2026, 7, 31),
    examDate: DateTime(2026, 10, 3),
    resultDate: DateTime(2026, 12, 16),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '행정사 제14회 2차의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '정기접수는 종료되었으나 시험일이 향후 6개월 범위에 있어 표시.',
  ),
  Exam(
    id: 'toeic580',
    name: 'TOEIC 제580회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 8, 24),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 11),
    resultDate: DateTime(2026, 10, 20),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제580회 공식 일정입니다. 시험일 2026-10-11, 성적발표 2026-10-20.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 08-24~09-28, 특별추가 09-30~10-07',
  ),
  Exam(
    id: 'adp37p',
    name: 'ADP 데이터분석전문가 제37회 실기',
    organizer: '한국데이터산업진흥원',
    category: '데이터',
    applyStart: DateTime(2026, 9, 14),
    applyEnd: DateTime(2026, 9, 18),
    examDate: DateTime(2026, 10, 17),
    resultDate: DateTime(2026, 11, 13),
    badge: 'DATAQ',
    color: const Color(0xFFCF4500),
    eligibility: '종목별 응시자격은 데이터자격검정 공식 안내 확인',
    subjects: ['데이터 분석 실무'],
    passRule: '종목별 합격기준은 데이터자격검정 공식 안내 확인',
    officialSource: '데이터자격검정 공식 시험일정',
    aiSummary: '2026년 데이터자격검정 공식 일정에 게시된 ADP 데이터분석전문가 제37회 실기 일정입니다.',
    tip: '접수 마감 직전에는 결제와 시험장 선택이 혼잡할 수 있어 가능한 초기에 접수하세요.',
    difficulty: 5,
    sourceUrl: 'https://www.dataq.or.kr/www/accept/schedule.do',
    scheduleNote: '2026년 데이터자격검정 공식 시험일정 기준.',
  ),
  Exam(
    id: 'aipot5',
    name: 'AI-POT 제5회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: 'AI',
    applyStart: DateTime(2026, 9, 10),
    applyEnd: DateTime(2026, 9, 16),
    examDate: DateTime(2026, 10, 17),
    resultDate: DateTime(2026, 10, 17),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'AI-POT 제5회 정기시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'cat10',
    name: 'CAD 실무능력평가 제10회',
    organizer: '한국생산성본부(KPC)',
    category: '디자인',
    applyStart: DateTime(2026, 9, 10),
    applyEnd: DateTime(2026, 9, 16),
    examDate: DateTime(2026, 10, 17),
    resultDate: DateTime(2026, 10, 17),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'CAD 실무능력평가 제10회 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'itq10',
    name: 'ITQ 제10회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: '사무·OA',
    applyStart: DateTime(2026, 9, 10),
    applyEnd: DateTime(2026, 9, 16),
    examDate: DateTime(2026, 10, 17),
    resultDate: DateTime(2026, 10, 17),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'ITQ 제10회 정기시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'smat6',
    name: 'SMAT 제6회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: '서비스·경영',
    applyStart: DateTime(2026, 9, 10),
    applyEnd: DateTime(2026, 9, 16),
    examDate: DateTime(2026, 10, 17),
    resultDate: DateTime(2026, 10, 17),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'SMAT 제6회 정기시험 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote: 'KPC 공식 공개 시험일정 기준. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'history80',
    name: '한국사능력검정시험 제80회(심화)',
    organizer: '국사편찬위원회',
    category: '공기업·공무원',
    applyStart: DateTime(2026, 9, 15),
    applyEnd: DateTime(2026, 9, 22),
    examDate: DateTime(2026, 10, 17),
    resultDate: DateTime(2026, 10, 30),
    badge: '한능검',
    color: const Color(0xFF141413),
    eligibility: '응시자격 제한 없음',
    subjects: ['한국사 전 범위'],
    passRule: '심화: 1급 80점 이상, 2급 70~79점, 3급 60~69점',
    officialSource: '한국사능력검정시험 공식 시험일정',
    aiSummary: '한국사능력검정시험 제80회(심화)의 공식 원서접수·시험·결과 발표 일정입니다.',
    tip: '추가접수/잔여석 접수 기간이 별도로 운영될 수 있으므로 공식 홈페이지 공지를 함께 확인하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.historyexam.go.kr/pageLink.do?link=examSchedule',
    scheduleNote: '2026년 공식 시험일정 기준. 제80회·제81회는 심화 시험.',
  ),
  Exam(
    id: 'ai-basic2610',
    name: 'AI상식 2610회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'AI',
    applyStart: DateTime(2026, 9, 14),
    applyEnd: DateTime(2026, 9, 23),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 11, 13),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['인공지능 기초', '생성형 AI 및 프롬프트/서비스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: 'AI상식 2610회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'gtq-ai3',
    name: 'GTQ-AI 제3회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: 'AI',
    applyStart: DateTime(2026, 9, 23),
    applyEnd: DateTime(2026, 9, 30),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 10, 24),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'GTQ-AI 제3회 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote:
        'KPC 공식 페이지 기준: 시험일 2026-10-24, 인터넷접수 2026-09-23~09-30. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'gtq10',
    name: 'GTQ/GTQi 제10회 정기시험',
    organizer: '한국생산성본부(KPC)',
    category: '디자인',
    applyStart: DateTime(2026, 9, 23),
    applyEnd: DateTime(2026, 9, 30),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 10, 24),
    badge: 'KPC',
    color: const Color(0xFFCF4500),
    eligibility: '종목 및 등급별 응시자격은 KPC 자격 공식 안내 확인',
    subjects: ['종목별 공식 출제기준 확인'],
    passRule: '종목별 합격기준은 KPC 자격 공식 안내 확인',
    officialSource: 'KPC 자격 공식 접수일정',
    aiSummary: 'GTQ/GTQi 제10회 공식 접수·시험 일정입니다.',
    tip: '합격자 발표일은 시험별 공식 공지에서 최종 확인하세요.',
    difficulty: 2,
    resultDateKnown: false,
    sourceUrl:
        'https://license.kpc.or.kr/nasec/rceptexmncnfirm/orgrcept/selectItemfx.do',
    scheduleNote:
        'KPC 공식 페이지 기준: 시험일 2026-10-24, 인터넷접수 2026-09-23~09-30. 합격발표일은 이 데이터에서 확정하지 않음.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-construction-safety',
    name: '건설안전기사 · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '안전·산업',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: [
      '산업안전관리론',
      '산업심리 및 교육',
      '인간공학 및 시스템안전공학',
      '건설시공학',
      '건설재료학',
      '건설안전기술'
    ],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1440&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-architecture',
    name: '건축기사 · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '건축·토목',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: ['건축계획', '건축시공', '건축구조', '건축설비', '건축관계법규'],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1630&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'dia2610',
    name: '디지털정보활용능력 2610회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '사무·OA',
    applyStart: DateTime(2026, 9, 14),
    applyEnd: DateTime(2026, 9, 23),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 11, 13),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['프레젠테이션', '스프레드시트', '워드프로세서 등 선택과목'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '디지털정보활용능력 2610회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-safety',
    name: '산업안전기사 · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '안전·산업',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: [
      '산업재해 예방 및 안전보건교육',
      '인간공학 및 위험성평가·관리',
      '기계·기구 및 설비 안전관리',
      '전기설비 안전관리',
      '화학설비 안전관리',
      '건설공사 안전관리'
    ],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1431&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-firesafe-m',
    name: '소방설비기사(기계분야) · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '안전·산업',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: ['소방원론', '소방유체역학', '소방관계법규', '소방기계시설의 구조 및 원리'],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1900&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-firesafe-e',
    name: '소방설비기사(전기분야) · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '안전·산업',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: ['소방원론', '소방전기일반', '소방관계법규', '소방전기시설의 구조 및 원리'],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1910&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-food',
    name: '식품안전기사(구 식품기사) · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '안전·산업',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: ['식품위생학', '식품화학', '식품가공학', '식품미생물학', '생화학 및 발효학'],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1530&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-hazmat',
    name: '위험물산업기사 · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '안전·산업',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: ['일반화학', '화재예방과 소화방법', '위험물의 성질과 취급'],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=2121&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-elecwork',
    name: '전기공사기사 · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '전기·전자',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: ['전기응용 및 공사재료', '전력공학', '전기기기', '회로이론 및 제어공학', '전기설비기술기준'],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1160&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-electric',
    name: '전기기사 · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '전기·전자',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: ['전기자기학', '전력공학', '전기기기', '회로이론 및 제어공학', '전기설비기술기준'],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1150&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-electronics',
    name: '전자기사 · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '전기·전자',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: ['전자회로', '회로이론', '전자계산기 일반', '전자기학', '전자회로설계 및 응용'],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1170&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-info',
    name: '정보처리기사 · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: 'IT·개발',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: [
      '소프트웨어 설계',
      '소프트웨어 개발',
      '데이터베이스 구축',
      '프로그래밍 언어 활용',
      '정보시스템 구축관리'
    ],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1320&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'coding2-2610',
    name: '코딩능력마스터 2급 2610회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 9, 14),
    applyEnd: DateTime(2026, 9, 23),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 11, 13),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['컴퓨팅 사고', '프로그래밍 및 알고리즘'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '코딩능력마스터 2급 2610회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'qnet-2026-3-practical-civil',
    name: '토목기사 · 2026 기사 제3회 실기',
    organizer: '한국산업인력공단',
    category: '건축·토목',
    applyStart: DateTime(2026, 9, 21),
    applyEnd: DateTime(2026, 9, 28),
    examDate: DateTime(2026, 10, 24),
    resultDate: DateTime(2026, 12, 18),
    badge: 'Q-Net',
    color: const Color(0xFF024AD8),
    eligibility: 'Q-Net 종목별 응시자격 기준 충족 필요',
    subjects: ['응용역학', '측량학', '수리학 및 수문학', '철근콘크리트 및 강구조', '토질 및 기초', '상하수도공학'],
    passRule: '필기 과목당 40점 이상·평균 60점 이상, 실기 60점 이상',
    officialSource: 'Q-Net 공식 종목별 상세정보',
    aiSummary:
        '제3회 실기 원서접수는 9월 21~28일이며 실기시험은 10월 24일~11월 13일 사이 종목·지역별로 시행됩니다.',
    tip: '세부 실기시험일은 종목과 지역에 따라 달라지므로 수험표의 확정 일시를 반드시 확인하세요.',
    difficulty: 4,
    sourceUrl:
        'https://www.q-net.or.kr/crf005.do?id=crf00503s02&jmCd=1250&jmInfoDivCcd=B0',
    scheduleNote:
        '필기시험 기간 2026-08-07~09-01, 필기 합격발표 09-09. 실기 접수 09-21~09-28, 실기시험 10-24~11-13, 최종 합격발표 12-18. 종목·지역별 세부일정 상이.',
  ),
  Exam(
    id: 'adsp51',
    name: 'ADsP 데이터분석준전문가 제51회',
    organizer: '한국데이터산업진흥원',
    category: '데이터',
    applyStart: DateTime(2026, 9, 28),
    applyEnd: DateTime(2026, 10, 2),
    examDate: DateTime(2026, 10, 31),
    resultDate: DateTime(2026, 11, 20),
    badge: 'DATAQ',
    color: const Color(0xFFCF4500),
    eligibility: '종목별 응시자격은 데이터자격검정 공식 안내 확인',
    subjects: ['데이터 이해', '데이터분석 기획', '데이터분석'],
    passRule: '종목별 합격기준은 데이터자격검정 공식 안내 확인',
    officialSource: '데이터자격검정 공식 시험일정',
    aiSummary: '2026년 데이터자격검정 공식 일정에 게시된 ADsP 데이터분석준전문가 제51회 일정입니다.',
    tip: '접수 마감 직전에는 결제와 시험장 선택이 혼잡할 수 있어 가능한 초기에 접수하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.dataq.or.kr/www/accept/schedule.do',
    scheduleNote: '2026년 데이터자격검정 공식 시험일정 기준.',
  ),
  Exam(
    id: 'toeic581',
    name: 'TOEIC 제581회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 9, 14),
    applyEnd: DateTime(2026, 10, 19),
    examDate: DateTime(2026, 10, 31),
    resultDate: DateTime(2026, 11, 10),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제581회 공식 일정입니다. 시험일 2026-10-31, 성적발표 2026-11-10.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 09-14~10-19, 특별추가 10-21~10-28',
  ),
  Exam(
    id: 'realtor37',
    name: '공인중개사 제37회 1·2차',
    organizer: '한국산업인력공단',
    category: '기타',
    applyStart: DateTime(2026, 10, 1),
    applyEnd: DateTime(2026, 10, 2),
    examDate: DateTime(2026, 10, 31),
    resultDate: DateTime(2026, 12, 2),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '공인중개사 제37회 1·2차의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '빈자리 추가접수 기준. 정기접수 08-03~08-07.',
  ),
  Exam(
    id: 'linux2-2604-1',
    name: '리눅스마스터 2급 2604회 1차',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 10, 5),
    applyEnd: DateTime(2026, 10, 16),
    examDate: DateTime(2026, 10, 31),
    resultDate: DateTime(2026, 11, 4),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['리눅스 일반', '리눅스 운영 및 관리', '리눅스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '리눅스마스터 2급 2604회 1차의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'domestic26-written',
    name: '국내여행안내사 제26회 필기',
    organizer: '한국산업인력공단',
    category: '서비스·경영',
    applyStart: DateTime(2026, 9, 14),
    applyEnd: DateTime(2026, 9, 18),
    examDate: DateTime(2026, 11, 7),
    resultDate: DateTime(2026, 12, 2),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '국내여행안내사 제26회 필기의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '빈자리 추가접수 10-29~10-30.',
  ),
  Exam(
    id: 'korean-teacher21-interview',
    name: '한국어교육능력검정시험 제21회 면접',
    organizer: '한국산업인력공단',
    category: '서비스·경영',
    applyStart: DateTime(2026, 10, 19),
    applyEnd: DateTime(2026, 10, 23),
    examDate: DateTime(2026, 11, 7),
    resultDate: DateTime(2026, 11, 25),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '한국어교육능력검정시험 제21회 면접의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: 'Q-Net 전문자격 공식 일정.',
  ),
  Exam(
    id: 'sqld63',
    name: 'SQLD SQL개발자 제63회',
    organizer: '한국데이터산업진흥원',
    category: '데이터',
    applyStart: DateTime(2026, 10, 12),
    applyEnd: DateTime(2026, 10, 16),
    examDate: DateTime(2026, 11, 14),
    resultDate: DateTime(2026, 12, 4),
    badge: 'DATAQ',
    color: const Color(0xFFCF4500),
    eligibility: '종목별 응시자격은 데이터자격검정 공식 안내 확인',
    subjects: ['데이터 모델링의 이해', 'SQL 기본 및 활용'],
    passRule: '종목별 합격기준은 데이터자격검정 공식 안내 확인',
    officialSource: '데이터자격검정 공식 시험일정',
    aiSummary: '2026년 데이터자격검정 공식 일정에 게시된 SQLD SQL개발자 제63회 일정입니다.',
    tip: '접수 마감 직전에는 결제와 시험장 선택이 혼잡할 수 있어 가능한 초기에 접수하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.dataq.or.kr/www/accept/schedule.do',
    scheduleNote: '2026년 데이터자격검정 공식 시험일정 기준.',
  ),
  Exam(
    id: 'tourguide26-interview',
    name: '관광통역안내사 제26회 면접',
    organizer: '한국산업인력공단',
    category: '서비스·경영',
    applyStart: DateTime(2026, 7, 6),
    applyEnd: DateTime(2026, 7, 10),
    examDate: DateTime(2026, 11, 14),
    resultDate: DateTime(2026, 12, 16),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '관광통역안내사 제26회 면접의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '면접시험 11-14~11-15.',
  ),
  Exam(
    id: 'linux1-2602-2',
    name: '리눅스마스터 1급 2602회 2차',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 10, 5),
    applyEnd: DateTime(2026, 10, 16),
    examDate: DateTime(2026, 11, 14),
    resultDate: DateTime(2026, 12, 4),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['리눅스 일반', '리눅스 운영 및 관리', '리눅스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '리눅스마스터 1급 2602회 2차의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 5,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'curator27',
    name: '박물관 및 미술관 준학예사 제27회',
    organizer: '한국산업인력공단',
    category: '기타',
    applyStart: DateTime(2026, 10, 12),
    applyEnd: DateTime(2026, 10, 16),
    examDate: DateTime(2026, 11, 14),
    resultDate: DateTime(2026, 12, 23),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '박물관 및 미술관 준학예사 제27회의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: 'Q-Net 전문자격 공식 일정.',
  ),
  Exam(
    id: 'toeic582',
    name: 'TOEIC 제582회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 9, 28),
    applyEnd: DateTime(2026, 11, 2),
    examDate: DateTime(2026, 11, 15),
    resultDate: DateTime(2026, 11, 24),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제582회 공식 일정입니다. 시험일 2026-11-15, 성적발표 2026-11-24.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 09-28~11-02, 특별추가 11-04~11-12',
  ),
  Exam(
    id: 'security28',
    name: '경비지도사 제28회',
    organizer: '한국산업인력공단',
    category: '기타',
    applyStart: DateTime(2026, 9, 14),
    applyEnd: DateTime(2026, 9, 18),
    examDate: DateTime(2026, 11, 21),
    resultDate: DateTime(2026, 12, 31),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '경비지도사 제28회의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '정기접수 기준. 빈자리 추가접수 11-12~11-13.',
  ),
  Exam(
    id: 'sns2604',
    name: 'SNS광고마케터 1급 2604회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '서비스·경영',
    applyStart: DateTime(2026, 10, 12),
    applyEnd: DateTime(2026, 10, 23),
    examDate: DateTime(2026, 11, 28),
    resultDate: DateTime(2026, 12, 18),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['SNS 이해', 'SNS 광고 마케팅'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: 'SNS광고마케터 1급 2604회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'dia2611',
    name: '디지털정보활용능력 2611회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '사무·OA',
    applyStart: DateTime(2026, 10, 12),
    applyEnd: DateTime(2026, 10, 21),
    examDate: DateTime(2026, 11, 28),
    resultDate: DateTime(2026, 12, 18),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['프레젠테이션', '스프레드시트', '워드프로세서 등 선택과목'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '디지털정보활용능력 2611회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'big13p',
    name: '빅데이터분석기사 제13회 실기',
    organizer: '한국데이터산업진흥원',
    category: '데이터',
    applyStart: DateTime(2026, 10, 26),
    applyEnd: DateTime(2026, 10, 30),
    examDate: DateTime(2026, 11, 28),
    resultDate: DateTime(2026, 12, 18),
    badge: 'DATAQ',
    color: const Color(0xFFCF4500),
    eligibility: '종목별 응시자격은 데이터자격검정 공식 안내 확인',
    subjects: ['빅데이터 분석 실무'],
    passRule: '종목별 합격기준은 데이터자격검정 공식 안내 확인',
    officialSource: '데이터자격검정 공식 시험일정',
    aiSummary: '2026년 데이터자격검정 공식 일정에 게시된 빅데이터분석기사 제13회 실기 일정입니다.',
    tip: '접수 마감 직전에는 결제와 시험장 선택이 혼잡할 수 있어 가능한 초기에 접수하세요.',
    difficulty: 5,
    sourceUrl: 'https://www.dataq.or.kr/www/accept/schedule.do',
    scheduleNote: '2026년 데이터자격검정 공식 시험일정 기준.',
  ),
  Exam(
    id: 'coding1-2611',
    name: '코딩능력마스터 1급 2611회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 10, 12),
    applyEnd: DateTime(2026, 10, 21),
    examDate: DateTime(2026, 11, 28),
    resultDate: DateTime(2026, 12, 18),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['컴퓨팅 사고', '프로그래밍 및 알고리즘'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '코딩능력마스터 1급 2611회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'coding3-2611',
    name: '코딩능력마스터 3급 2611회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 10, 12),
    applyEnd: DateTime(2026, 10, 21),
    examDate: DateTime(2026, 11, 28),
    resultDate: DateTime(2026, 12, 18),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['컴퓨팅 사고', '프로그래밍 및 알고리즘'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '코딩능력마스터 3급 2611회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'prompt2-2604',
    name: '프롬프트엔지니어 2급 2604회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'AI',
    applyStart: DateTime(2026, 10, 12),
    applyEnd: DateTime(2026, 10, 23),
    examDate: DateTime(2026, 11, 28),
    resultDate: DateTime(2026, 12, 18),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['인공지능 기초', '생성형 AI 및 프롬프트/서비스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '프롬프트엔지니어 2급 2604회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'history81',
    name: '한국사능력검정시험 제81회(심화)',
    organizer: '국사편찬위원회',
    category: '공기업·공무원',
    applyStart: DateTime(2026, 11, 3),
    applyEnd: DateTime(2026, 11, 10),
    examDate: DateTime(2026, 11, 28),
    resultDate: DateTime(2026, 12, 11),
    badge: '한능검',
    color: const Color(0xFF141413),
    eligibility: '응시자격 제한 없음',
    subjects: ['한국사 전 범위'],
    passRule: '심화: 1급 80점 이상, 2급 70~79점, 3급 60~69점',
    officialSource: '한국사능력검정시험 공식 시험일정',
    aiSummary: '한국사능력검정시험 제81회(심화)의 공식 원서접수·시험·결과 발표 일정입니다.',
    tip: '추가접수/잔여석 접수 기간이 별도로 운영될 수 있으므로 공식 홈페이지 공지를 함께 확인하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.historyexam.go.kr/pageLink.do?link=examSchedule',
    scheduleNote: '2026년 공식 시험일정 기준. 제80회·제81회는 심화 시험.',
  ),
  Exam(
    id: 'toeic583',
    name: 'TOEIC 제583회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 10, 12),
    applyEnd: DateTime(2026, 11, 16),
    examDate: DateTime(2026, 11, 29),
    resultDate: DateTime(2026, 12, 8),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제583회 공식 일정입니다. 시험일 2026-11-29, 성적발표 2026-12-08.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 10-12~11-16, 특별추가 11-18~11-26',
  ),
  Exam(
    id: 'youth25-interview',
    name: '청소년상담사 제25회 면접',
    organizer: '한국산업인력공단',
    category: '서비스·경영',
    applyStart: DateTime(2026, 11, 2),
    applyEnd: DateTime(2026, 11, 6),
    examDate: DateTime(2026, 11, 30),
    resultDate: DateTime(2026, 12, 23),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '청소년상담사 제25회 면접의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '면접시험 기간 11-30~12-05.',
  ),
  Exam(
    id: 'domestic26-interview',
    name: '국내여행안내사 제26회 면접',
    organizer: '한국산업인력공단',
    category: '서비스·경영',
    applyStart: DateTime(2026, 9, 14),
    applyEnd: DateTime(2026, 9, 18),
    examDate: DateTime(2026, 12, 12),
    resultDate: DateTime(2026, 12, 30),
    badge: 'Q-Net',
    color: const Color(0xFF141413),
    eligibility: '전문자격별 응시자격 및 면제기준은 Q-Net 종목별 안내 확인',
    subjects: ['종목별 시험과목은 Q-Net 공식 상세정보 확인'],
    passRule: '종목별 합격기준은 Q-Net 공식 상세정보 확인',
    officialSource: 'Q-Net 전문자격 공식 시험일정',
    aiSummary: '국내여행안내사 제26회 면접의 2026년 공식 일정입니다.',
    tip: '전문자격은 정기접수와 빈자리 추가접수가 별도로 운영될 수 있으므로 일정 메모를 확인하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.q-net.or.kr/',
    scheduleNote: '필기와 동일 정기접수 기간 기준.',
  ),
  Exam(
    id: 'linux2-2604-2',
    name: '리눅스마스터 2급 2604회 2차',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 10, 27),
    applyEnd: DateTime(2026, 11, 6),
    examDate: DateTime(2026, 12, 12),
    resultDate: DateTime(2026, 12, 31),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['리눅스 일반', '리눅스 운영 및 관리', '리눅스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '리눅스마스터 2급 2604회 2차의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'toeic584',
    name: 'TOEIC 제584회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 10, 26),
    applyEnd: DateTime(2026, 11, 30),
    examDate: DateTime(2026, 12, 13),
    resultDate: DateTime(2026, 12, 22),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제584회 공식 일정입니다. 시험일 2026-12-13, 성적발표 2026-12-22.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 10-26~11-30, 특별추가 12-02~12-10',
  ),
  Exam(
    id: 'ai-service2601',
    name: 'AI 서비스 기획 전문가 2601회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'AI',
    applyStart: DateTime(2026, 11, 2),
    applyEnd: DateTime(2026, 11, 13),
    examDate: DateTime(2026, 12, 19),
    resultDate: DateTime(2027, 1, 8),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['인공지능 기초', '생성형 AI 및 프롬프트/서비스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: 'AI 서비스 기획 전문가 2601회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'ai-program1-2601',
    name: 'AI 프로그래밍 1급 2601회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'AI',
    applyStart: DateTime(2026, 11, 2),
    applyEnd: DateTime(2026, 11, 13),
    examDate: DateTime(2026, 12, 19),
    resultDate: DateTime(2027, 1, 8),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['인공지능 기초', '생성형 AI 및 프롬프트/서비스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: 'AI 프로그래밍 1급 2601회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'ai-basic2612',
    name: 'AI상식 2612회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'AI',
    applyStart: DateTime(2026, 11, 9),
    applyEnd: DateTime(2026, 11, 18),
    examDate: DateTime(2026, 12, 19),
    resultDate: DateTime(2027, 1, 8),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['인공지능 기초', '생성형 AI 및 프롬프트/서비스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: 'AI상식 2612회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'sam2604',
    name: '검색광고마케터 1급 2604회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '서비스·경영',
    applyStart: DateTime(2026, 11, 2),
    applyEnd: DateTime(2026, 11, 13),
    examDate: DateTime(2026, 12, 19),
    resultDate: DateTime(2027, 1, 8),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['온라인 비즈니스 및 디지털 마케팅', '검색광고 실무 활용', '검색광고 활용전략'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '검색광고마케터 1급 2604회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'dia2612',
    name: '디지털정보활용능력 2612회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: '사무·OA',
    applyStart: DateTime(2026, 11, 9),
    applyEnd: DateTime(2026, 11, 18),
    examDate: DateTime(2026, 12, 19),
    resultDate: DateTime(2027, 1, 8),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['프레젠테이션', '스프레드시트', '워드프로세서 등 선택과목'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '디지털정보활용능력 2612회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 2,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'coding2-2612',
    name: '코딩능력마스터 2급 2612회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'IT·개발',
    applyStart: DateTime(2026, 11, 9),
    applyEnd: DateTime(2026, 11, 18),
    examDate: DateTime(2026, 12, 19),
    resultDate: DateTime(2027, 1, 8),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['컴퓨팅 사고', '프로그래밍 및 알고리즘'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '코딩능력마스터 2급 2612회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 3,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'prompt1-2602',
    name: '프롬프트엔지니어 1급 2602회',
    organizer: '한국정보통신진흥협회(KAIT)',
    category: 'AI',
    applyStart: DateTime(2026, 11, 2),
    applyEnd: DateTime(2026, 11, 13),
    examDate: DateTime(2026, 12, 19),
    resultDate: DateTime(2027, 1, 8),
    badge: 'KAIT',
    color: const Color(0xFF024AD8),
    eligibility: '등급별 응시자격은 KAIT 공식 종목안내 확인',
    subjects: ['인공지능 기초', '생성형 AI 및 프롬프트/서비스 활용'],
    passRule: '종목별 합격기준은 KAIT 공식 안내 확인',
    officialSource: 'KAIT 자격검정 공식 일정',
    aiSummary: '프롬프트엔지니어 1급 2602회의 2026년 공식 접수·시험·합격발표 일정입니다.',
    tip: '접수 회차와 등급을 정확히 확인한 뒤 신청하세요.',
    difficulty: 4,
    sourceUrl: 'https://www.ihd.or.kr/memaccept1.do',
    scheduleNote: 'KAIT 공식 2026 시험일정 기준.',
  ),
  Exam(
    id: 'toeic585',
    name: 'TOEIC 제585회',
    organizer: 'YBM 한국TOEIC위원회',
    category: '어학',
    applyStart: DateTime(2026, 11, 9),
    applyEnd: DateTime(2026, 12, 14),
    examDate: DateTime(2026, 12, 27),
    resultDate: DateTime(2027, 1, 6),
    badge: 'TOEIC',
    color: const Color(0xFF024AD8),
    eligibility: '응시자격 제한 없음',
    subjects: ['Listening Comprehension', 'Reading Comprehension'],
    passRule: '10~990점 점수제',
    officialSource: 'TOEIC 공식 시험일정',
    aiSummary: 'TOEIC 제585회 공식 일정입니다. 시험일 2026-12-27, 성적발표 2027-01-06.',
    tip: '정기접수 종료 후 특별추가접수가 열리는 회차가 있으므로 공식 접수 페이지를 확인하세요.',
    difficulty: 2,
    sourceUrl: 'https://exam.toeic.co.kr/receipt/examSchList.php',
    scheduleNote: '정기접수 11-09~12-14, 특별추가 12-16~12-23',
  ),
];

List<Exam> demoExams = List<Exam>.from(bundledExams);

Future<void> loadOfficialAssetData() async {
  try {
    final fixedText =
        await rootBundle.loadString('assets/data/certificates.seed.json');
    final fixedDecoded = jsonDecode(fixedText);
    if (fixedDecoded is Map<String, dynamic>) {
      final raw = fixedDecoded['exams'];
      final updatedAt = fixedDecoded['updatedAt'];
      if (updatedAt is String)
        localSnapshotUpdatedAt = DateTime.tryParse(updatedAt);
      if (raw is List) {
        final parsed = raw
            .whereType<Map>()
            .map((e) => Exam.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (parsed.isNotEmpty) demoExams = parsed;
      }
    }
  } catch (_) {
    // Keep the hard-coded verified fallback so the demo still works offline.
  }

  try {
    final rollingText =
        await rootBundle.loadString('assets/data/rolling_exams.json');
    final rollingDecoded = jsonDecode(rollingText);
    if (rollingDecoded is Map<String, dynamic> &&
        rollingDecoded['exams'] is List) {
      rollingExams = (rollingDecoded['exams'] as List)
          .whereType<Map>()
          .map((e) => RollingExam.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  } catch (_) {
    rollingExams = <RollingExam>[];
  }
}

const String certiDefaultApiBaseUrl =
    String.fromEnvironment('CERTI_API_BASE_URL', defaultValue: '');
String certiApiBaseUrl = certiDefaultApiBaseUrl;
const String certiDataUrl =
    String.fromEnvironment('CERTI_DATA_URL', defaultValue: '');
const String certiDefaultAiModel =
    String.fromEnvironment('CERTI_DEFAULT_AI_MODEL', defaultValue: 'qwen3:4b');
String certiSelectedAiModel = certiDefaultAiModel;

class AiHealth {
  const AiHealth({
    required this.serverReachable,
    required this.aiConfigured,
    required this.aiReady,
    this.message = '',
    this.model = '',
  });
  final bool serverReachable;
  final bool aiConfigured;
  final bool aiReady;
  final String message;
  final String model;
}

bool isMeaningfulAiText(String? value) {
  final text = (value ?? '').trim();
  if (text.isEmpty) return false;

  final compact = text.replaceAll(RegExp(r'\s+'), '');
  final lowered = compact.toLowerCase();
  const placeholders = <String>{
    '.',
    '..',
    '...',
    '…',
    '……',
    '-',
    '--',
    '---',
    '답변중',
    '생각중',
    '처리중',
    'loading',
    'thinking',
    'ok',
    'okay',
  };
  if (placeholders.contains(lowered)) return false;

  final semantic = RegExp(r'[0-9A-Za-z가-힣]').allMatches(compact).length;
  if (semantic < 6) return false;

  final lower = text.toLowerCase();
  const reasoningMarkers = <String>[
    'wait,',
    'wait.',
    'i need to',
    'i should',
    'we need to',
    "the user's",
    'the user is',
    'the answer should',
    'make sure to',
    'need to present',
    'resultdateknown',
    'applyend',
  ];
  var hits = 0;
  for (final marker in reasoningMarkers) {
    if (lower.contains(marker)) hits++;
  }
  return hits < 2;
}

class AiAnswerResult {
  const AiAnswerResult({this.answer, this.error});
  final String? answer;
  final String? error;
  bool get ok => isMeaningfulAiText(answer);
}

class CertiRemoteService {
  static String get _base {
    final value = certiApiBaseUrl.trim();
    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }

  static Future<List<Exam>?> fetchExams() async {
    if (certiApiBaseUrl.trim().isEmpty && certiDataUrl.trim().isEmpty)
      return null;
    try {
      final target = certiDataUrl.trim().isNotEmpty
          ? Uri.parse(certiDataUrl.trim())
          : Uri.parse('$_base/api/certificates');
      final res = await http.get(target, headers: const {
        'accept': 'application/json'
      }).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      dynamic raw = decoded;
      if (decoded is Map<String, dynamic>) {
        raw = decoded['certificates'] ?? decoded['exams'];
      }
      if (raw is! List) return null;
      final items = raw
          .whereType<Map>()
          .map((e) => Exam.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return items.isEmpty ? null : items;
    } catch (_) {
      return null;
    }
  }

  static Future<List<RollingExam>?> fetchRollingExams() async {
    if (certiApiBaseUrl.trim().isEmpty) return null;
    try {
      final res = await http.get(
        Uri.parse('$_base/api/rolling'),
        headers: const {'accept': 'application/json'},
      ).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      dynamic raw = decoded;
      if (decoded is Map<String, dynamic>) {
        raw = decoded['rollingExams'] ?? decoded['exams'];
      }
      if (raw is! List) return null;
      final items = raw
          .whereType<Map>()
          .map((e) => RollingExam.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return items.isEmpty ? null : items;
    } catch (_) {
      return null;
    }
  }

  static Future<AiHealth> checkAiHealth({String model = 'qwen3:14b'}) async {
    if (certiApiBaseUrl.trim().isEmpty) {
      return const AiHealth(
        serverReachable: false,
        aiConfigured: false,
        aiReady: false,
        message: 'AI 서버 주소가 비어 있습니다.',
      );
    }
    try {
      final healthRes = await http
          .get(Uri.parse('$_base/health'))
          .timeout(const Duration(seconds: 4));
      dynamic healthJson;
      try {
        healthJson = jsonDecode(utf8.decode(healthRes.bodyBytes));
      } catch (_) {}

      if (healthRes.statusCode != 200 || healthJson is! Map<String, dynamic>) {
        return AiHealth(
          serverReachable: true,
          aiConfigured: false,
          aiReady: false,
          message: '백엔드 응답 형식을 확인할 수 없습니다. HTTP ${healthRes.statusCode}',
        );
      }

      final configured = healthJson['aiConfigured'] == true;
      final healthModel = (healthJson['model'] ?? '').toString();
      if (!configured) {
        return AiHealth(
          serverReachable: true,
          aiConfigured: false,
          aiReady: false,
          model: healthModel,
          message: '백엔드는 연결됐지만 Ollama 로컬 AI가 준비되지 않았습니다.',
        );
      }

      final probeRes = await http.get(
        Uri.parse(
            '$_base/api/ai/status?model=${Uri.encodeQueryComponent(model)}'),
        headers: const {'accept': 'application/json'},
      ).timeout(const Duration(seconds: 6));
      dynamic probeJson;
      try {
        probeJson = jsonDecode(utf8.decode(probeRes.bodyBytes));
      } catch (_) {}

      if (probeRes.statusCode == 200 && probeJson is Map<String, dynamic>) {
        final ready = probeJson['ready'] == true;
        return AiHealth(
          serverReachable: true,
          aiConfigured: probeJson['configured'] == true,
          aiReady: ready,
          model: (probeJson['model'] ?? healthModel).toString(),
          message: ready
              ? '선택한 Ollama 모델 설치 및 연결 상태가 정상입니다.'
              : (probeJson['message'] ?? '선택한 모델을 사용할 수 없습니다.').toString(),
        );
      }

      return AiHealth(
        serverReachable: true,
        aiConfigured: true,
        aiReady: false,
        model: healthModel,
        message: '로컬 AI 상태 검사에 실패했습니다. HTTP ${probeRes.statusCode}',
      );
    } catch (e) {
      return AiHealth(
        serverReachable: false,
        aiConfigured: false,
        aiReady: false,
        message:
            'PC 고성능 모드 서버에 연결할 수 없습니다. 노트북에서 RUN_CERTION_ALL.bat을 실행하세요. ($e)',
      );
    }
  }

  static Future<AiAnswerResult> askBrief(Exam exam, String question,
      {required String model}) async {
    if (certiApiBaseUrl.trim().isEmpty) {
      return const AiAnswerResult(error: 'AI 서버 주소가 비어 있습니다.');
    }
    try {
      final res = await http.post(
        Uri.parse('$_base/api/ai/brief'),
        headers: const {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({
          'certificateId': exam.id,
          'question': question,
          'model': model,
          'clientDate':
              '${appToday().year}-${appToday().month.toString().padLeft(2, '0')}-${appToday().day.toString().padLeft(2, '0')}',
        }),
      );

      dynamic decoded;
      try {
        decoded = jsonDecode(utf8.decode(res.bodyBytes));
      } catch (_) {}

      if (res.statusCode == 200 &&
          decoded is Map<String, dynamic> &&
          decoded['answer'] is String) {
        final answer = (decoded['answer'] as String).trim();
        if (isMeaningfulAiText(answer)) {
          return AiAnswerResult(answer: answer);
        }
        return const AiAnswerResult(
            error: 'PC AI가 빈 답변 또는 불완전한 답변을 반환해 표시를 차단했습니다.');
      }

      final msg = decoded is Map<String, dynamic> && decoded['error'] is String
          ? decoded['error'] as String
          : 'AI 서버 오류 (HTTP ${res.statusCode})';
      return AiAnswerResult(error: msg);
    } catch (e) {
      return AiAnswerResult(error: 'AI 서버 연결 실패: $e');
    }
  }
}

class PhoneAiModelSpec {
  const PhoneAiModelSpec({
    required this.id,
    required this.label,
    required this.shortLabel,
    required this.fileName,
    required this.downloadUrl,
    required this.downloadSize,
    required this.minValidBytes,
  });

  final String id;
  final String label;
  final String shortLabel;
  final String fileName;
  final String downloadUrl;
  final String downloadSize;
  final int minValidBytes;
}

// Q4_K_M keeps the phone model small enough for a 6 GB Android device while
// preserving much more quality than ultra-low-bit quantization.
const PhoneAiModelSpec phoneAiHigh = PhoneAiModelSpec(
  id: 'qwen3-phone-1.7b-q4',
  label: '휴대폰 고품질',
  shortLabel: '1.7B Q4',
  fileName: 'Qwen3-1.7B-Q4_K_M.gguf',
  downloadUrl:
      'https://huggingface.co/ggml-org/Qwen3-1.7B-GGUF/resolve/main/Qwen3-1.7B-Q4_K_M.gguf?download=true',
  downloadSize: '약 1.28GB',
  minValidBytes: 1100 * 1024 * 1024,
);

const PhoneAiModelSpec phoneAiFast = PhoneAiModelSpec(
  id: 'qwen3-phone-0.6b-q4',
  label: '휴대폰 빠름',
  shortLabel: '0.6B Q4_0',
  fileName: 'Qwen3-0.6B-Q4_0.gguf',
  downloadUrl:
      'https://huggingface.co/ggml-org/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q4_0.gguf?download=true',
  downloadSize: '약 429MB',
  minValidBytes: 380 * 1024 * 1024,
);

const List<PhoneAiModelSpec> phoneAiModels = [phoneAiHigh, phoneAiFast];

class CertiPhoneAiService {
  CertiPhoneAiService._();
  static final CertiPhoneAiService instance = CertiPhoneAiService._();

  LlamaController _controller = LlamaController();
  String? _loadedModelId;
  bool _busy = false;

  bool get busy => _busy;
  String? get loadedModelId => _loadedModelId;

  Future<Directory> _modelDirectory() async {
    final root = await getApplicationSupportDirectory();
    final dir =
        Directory('${root.path}${Platform.pathSeparator}certion_models');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> modelFile(PhoneAiModelSpec spec) async {
    final dir = await _modelDirectory();
    return File('${dir.path}${Platform.pathSeparator}${spec.fileName}');
  }

  Future<bool> _looksLikeValidGguf(File file, PhoneAiModelSpec spec) async {
    if (!await file.exists()) return false;
    if (await file.length() < spec.minValidBytes) return false;
    try {
      final raf = await file.open();
      final magic = await raf.read(4);
      await raf.close();
      return magic.length == 4 &&
          magic[0] == 0x47 && // G
          magic[1] == 0x47 && // G
          magic[2] == 0x55 && // U
          magic[3] == 0x46; // F
    } catch (_) {
      return false;
    }
  }

  Future<bool> isInstalled(PhoneAiModelSpec spec) async {
    if (!Platform.isAndroid) return false;
    final file = await modelFile(spec);
    return _looksLikeValidGguf(file, spec);
  }

  Future<void> downloadModel(
    PhoneAiModelSpec spec, {
    required void Function(double progress) onProgress,
  }) async {
    if (!Platform.isAndroid)
      throw UnsupportedError('휴대폰 단독 AI는 Android에서만 사용할 수 있습니다.');
    final target = await modelFile(spec);

    // V4: the old Qwen/Qwen3-0.6B-Q4_K_M file was removed from the
    // repository's current main branch. Clean any stale partial from V3 so
    // the new stable 0.6B Q4_0 download starts from a known-good file.
    if (spec.id == phoneAiFast.id) {
      final dir = await _modelDirectory();
      for (final legacyName in <String>[
        'Qwen3-0.6B-Q4_K_M.gguf',
        'Qwen3-0.6B-Q4_K_M.gguf.part',
      ]) {
        final legacy = File('${dir.path}${Platform.pathSeparator}$legacyName');
        if (await legacy.exists()) {
          try {
            await legacy.delete();
          } catch (_) {}
        }
      }
    }

    if (await _looksLikeValidGguf(target, spec)) {
      onProgress(1.0);
      return;
    }
    if (await target.exists()) {
      try {
        await target.delete();
      } catch (_) {}
    }

    final partial = File('${target.path}.part');
    var existing = await partial.exists() ? await partial.length() : 0;
    if (existing < 0 || existing > 8 * 1024 * 1024 * 1024) {
      try {
        await partial.delete();
      } catch (_) {}
      existing = 0;
    }

    final client = http.Client();
    IOSink? sink;
    try {
      final request = http.Request('GET', Uri.parse(spec.downloadUrl));
      request.headers['user-agent'] = 'CERTI-ON/2.1 Android';
      if (existing > 0) request.headers['range'] = 'bytes=$existing-';
      final response = await client.send(request);

      // A completed .part can receive 416 on a resume request. If it is
      // already a valid GGUF, promote it instead of failing the download.
      if (response.statusCode == 416 &&
          existing > 0 &&
          await _looksLikeValidGguf(partial, spec)) {
        if (await target.exists()) await target.delete();
        await partial.rename(target.path);
        onProgress(1.0);
        return;
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
            '모델 다운로드 HTTP ${response.statusCode} ${response.reasonPhrase ?? ''}'
                .trim());
      }

      // Servers that ignore Range return 200. In that case restart cleanly.
      final append = existing > 0 && response.statusCode == 206;
      if (!append && existing > 0) {
        try {
          await partial.delete();
        } catch (_) {}
        existing = 0;
      }

      final remaining = response.contentLength ?? 0;
      final total = remaining > 0 ? existing + remaining : 0;
      var received = existing;
      sink = partial.openWrite(mode: append ? FileMode.append : FileMode.write);
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0)
          onProgress((received / total).clamp(0.0, 1.0).toDouble());
      }
      await sink.flush();
      await sink.close();
      sink = null;

      final completedLength = await partial.length();
      if (total > 0 && completedLength != total) {
        throw FormatException(
            '모델 다운로드가 완전히 끝나지 않았습니다. expected=$total actual=$completedLength');
      }
      if (!await _looksLikeValidGguf(partial, spec)) {
        // A bad/captive-portal HTML response should never be resumed forever.
        try {
          await partial.delete();
        } catch (_) {}
        throw const FormatException(
            '다운로드 파일이 정상 GGUF가 아닙니다. Wi-Fi 로그인 페이지/차단 여부를 확인한 뒤 다시 시도하세요.');
      }
      if (await target.exists()) await target.delete();
      await partial.rename(target.path);
      onProgress(1.0);
    } catch (_) {
      // Keep the .part file so a large download can resume next time.
      try {
        await sink?.flush();
      } catch (_) {}
      try {
        await sink?.close();
      } catch (_) {}
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<void> deleteModel(PhoneAiModelSpec spec) async {
    if (_loadedModelId == spec.id) {
      try {
        await _controller.dispose();
      } catch (_) {}
      _controller = LlamaController();
      _loadedModelId = null;
    }
    final file = await modelFile(spec);
    if (await file.exists()) await file.delete();
    final partial = File('${file.path}.part');
    if (await partial.exists()) await partial.delete();
  }

  Future<void> _ensureLoaded(PhoneAiModelSpec spec) async {
    if (_loadedModelId == spec.id && await _controller.isModelLoaded()) return;
    final file = await modelFile(spec);
    if (!await file.exists())
      throw StateError('${spec.label} 모델이 설치되어 있지 않습니다.');
    if (_loadedModelId != null) {
      try {
        await _controller.dispose();
      } catch (_) {}
      _controller = LlamaController();
      _loadedModelId = null;
    }
    await _controller.loadModel(
      modelPath: file.path,
      threads: 4,
      contextSize: 3072,
      gpuLayers: 0,
    );
    _loadedModelId = spec.id;
  }

  Map<String, dynamic> _compactExam(Exam exam) => {
        'name': exam.name,
        'organizer': exam.organizer,
        'category': exam.category,
        'applyStart': exam.applyStart.toIso8601String().split('T').first,
        'applyEnd': exam.applyEnd.toIso8601String().split('T').first,
        'examDate': exam.examDate.toIso8601String().split('T').first,
        'resultDate': exam.resultDateKnown
            ? exam.resultDate.toIso8601String().split('T').first
            : '미확정',
        'eligibility': exam.eligibility,
        'subjects': exam.subjects,
        'passRule': exam.passRule,
        'officialSource': exam.officialSource,
        'scheduleNote': exam.scheduleNote,
      };

  List<Exam> _relevantExams(Exam selected, String question) {
    final q = question.toLowerCase().replaceAll(RegExp(r'\s+'), '');
    int score(Exam exam) {
      var n = identical(exam, selected) || exam.id == selected.id ? 50 : 0;
      final name = exam.name.toLowerCase().replaceAll(RegExp(r'\s+'), '');
      final cat = exam.category.toLowerCase().replaceAll(RegExp(r'\s+'), '');
      if (q.contains(name) || name.contains(q)) n += 100;
      if (q.contains(cat)) n += 8;
      final aliases = <String, String>{
        '정처기': '정보처리기사',
        '컴활': '컴퓨터활용능력',
        '한능검': '한국사능력검정시험',
        '토익': 'toeic',
        '리눅스': '리눅스마스터',
        '빅분기': '빅데이터분석기사',
        'adsp': '데이터분석준전문가',
        'sqld': 'sql개발자',
      };
      for (final entry in aliases.entries) {
        if (q.contains(entry.key) &&
            name.contains(
                entry.value.toLowerCase().replaceAll(RegExp(r'\s+'), '')))
          n += 90;
      }
      return n;
    }

    final ranked = [...demoExams]..sort((a, b) => score(b).compareTo(score(a)));
    final out = <Exam>[];
    for (final exam in ranked) {
      if (score(exam) <= 0 && out.isNotEmpty) break;
      if (!out.any((e) => e.id == exam.id)) out.add(exam);
      if (out.length >= 3) break;
    }
    if (!out.any((e) => e.id == selected.id)) out.insert(0, selected);
    return out.take(3).toList();
  }

  String _cleanAnswer(String raw) {
    var text = raw.replaceAll('\u0000', '').trim();

    // Qwen3 reasoning must never be rendered in the app. First prefer an
    // explicit <final> block, then fall back to text after any closed think
    // block. ChatML control tokens are removed as a final safety step.
    final finalMatch = RegExp(
      r'<final>\s*([\s\S]*?)(?:</final>|$)',
      caseSensitive: false,
    ).firstMatch(text);
    if (finalMatch != null) {
      text = (finalMatch.group(1) ?? '').trim();
    } else {
      text = text
          .replaceAll(
              RegExp(r'<think>[\s\S]*?</think>', caseSensitive: false), '')
          .trim();
      final end = text.lastIndexOf('</think>');
      if (end >= 0) text = text.substring(end + '</think>'.length).trim();
    }

    text = text
        .replaceAll(
            RegExp(r'<\|im_start\|>assistant\s*', caseSensitive: false), '')
        .replaceAll(RegExp(r'<\|im_end\|>', caseSensitive: false), '')
        .replaceAll(RegExp(r'</?final>', caseSensitive: false), '')
        .replaceAll(RegExp(r'^assistant\s*[:：]\s*', caseSensitive: false), '')
        .trim();
    return text;
  }

  bool _looksLikeInternalReasoning(String text) {
    final lower = text.toLowerCase();
    const markers = <String>[
      'wait,',
      'wait.',
      'i need to',
      'i should',
      'we need to',
      "the user's",
      'the user is',
      'the answer should',
      'make sure to',
      'let me ',
      'current date is',
      "today's date",
      'resultdateknown',
      'applyend',
      'need to present',
    ];
    var hits = 0;
    for (final marker in markers) {
      if (lower.contains(marker)) hits++;
    }
    return hits >= 2;
  }

  Future<String> ask({
    required PhoneAiModelSpec spec,
    required Exam selectedExam,
    required String question,
  }) async {
    if (_busy) throw StateError('휴대폰 AI가 이미 답변을 생성하고 있습니다.');
    _busy = true;
    try {
      await _ensureLoaded(spec);
      final today = appToday();
      final todayText =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final relevant =
          _relevantExams(selectedExam, question).map(_compactExam).toList();
      const appContext =
          '''CERTI:ON은 여러 자격시험의 정보를 한곳에서 확인하고 공식 일정 데이터를 AI가 이해하기 쉽게 정리하는 자격증 일정·플래너 앱입니다.
주요 기능은 홈의 가까운 일정 확인, 자격증 탐색/검색, 일정 달력, AI 핵심 브리핑, AI 추가 질문, 공식 출처 검증, MY/플래너, 자격증 비교입니다.
핵심 원칙은 AI가 대신 결정하는 앱이 아니라 공식 정보를 빠르게 이해하고 사용자가 직접 검증하도록 돕는 AI입니다.''';
      const system = '''당신은 CERTI:ON 앱 안에서 스마트폰 자체로 실행되는 한국어 AI 도우미입니다.
앱 기능 질문은 제공된 CERTI:ON 설명을 기준으로 답하세요.
시험 날짜·접수기간·발표일·응시자격·합격기준처럼 정확성이 중요한 사실은 제공된 공식 일정 데이터만 사용하세요.
공식 데이터에 없는 날짜나 제도는 추측하지 말고 "현재 저장된 공식 데이터에서는 확인되지 않습니다"라고 답하세요.
일반적인 공부 전략과 개념 설명은 일반 지식을 사용할 수 있습니다.
답변은 자연스러운 한국어로 간결하게 작성하세요.
내부 추론, 분석 메모, 영어로 된 사고 과정, 계획 문장은 절대 출력하지 마세요.
최종 사용자 답변만 작성하세요.''';
      final user = '''/no_think
CERTI:ON 앱 설명=$appContext
오늘 날짜=$todayText (대한민국 KST)
현재 화면 자격증=${selectedExam.name}
관련 공식 일정 데이터=${jsonEncode(relevant)}
사용자 질문=${question.trim()}
최종 답변은 한국어로만 작성하세요.''';

      // Qwen3 hard non-thinking pattern: prefill the assistant turn with an
      // empty <think></think> block. We also prefill <final> so generated text
      // belongs to the user-visible answer rather than an analysis transcript.
      final prompt = '''<|im_start|>system
$system<|im_end|>
<|im_start|>user
$user<|im_end|>
<|im_start|>assistant
<think>

</think>

<final>
''';

      try {
        await _controller.clearContext();
      } catch (_) {}

      Future<String> runOnce(
          {required double temperature, required int maxTokens}) async {
        final buffer = StringBuffer();
        await for (final token in _controller.generate(
          prompt: prompt,
          maxTokens: maxTokens,
          temperature: temperature,
          topP: 0.85,
          topK: 30,
          repeatPenalty: 1.08,
        )) {
          buffer.write(token);
        }
        return _cleanAnswer(buffer.toString());
      }

      var answer = await runOnce(temperature: 0.20, maxTokens: 420);
      if (!isMeaningfulAiText(answer) || _looksLikeInternalReasoning(answer)) {
        // One clean retry. Never show a reasoning transcript to the user.
        try {
          await _controller.clearContext();
        } catch (_) {}
        answer = await runOnce(temperature: 0.10, maxTokens: 480);
      }

      if (!isMeaningfulAiText(answer) || _looksLikeInternalReasoning(answer)) {
        throw StateError('휴대폰 AI가 최종 답변 대신 내부 분석을 생성해 표시를 차단했습니다. 다시 질문해주세요.');
      }
      return answer;
    } finally {
      _busy = false;
    }
  }
}

DateTime appToday() {
  // 앱의 기준 날짜는 기기 시간대와 관계없이 대한민국(KST, UTC+9)으로 계산합니다.
  final kst = DateTime.now().toUtc().add(const Duration(hours: 9));
  return DateTime(kst.year, kst.month, kst.day);
}

class ExamAction {
  const ExamAction({
    required this.exam,
    required this.label,
    required this.date,
    required this.color,
    required this.icon,
  });

  final Exam exam;
  final String label;
  final DateTime date;
  final Color color;
  final IconData icon;

  int get days => DateUtils.dateOnly(date).difference(appToday()).inDays;
  String get dday => days == 0
      ? '오늘'
      : days > 0
          ? 'D-$days'
          : 'D+${days.abs()}';
}

ExamAction? nextExamAction(Exam exam, {DateTime? today}) {
  final now = today ?? appToday();
  final applyStart = DateUtils.dateOnly(exam.applyStart);
  final applyEnd = DateUtils.dateOnly(exam.applyEnd);
  final examDate = DateUtils.dateOnly(exam.examDate);
  final resultDate = DateUtils.dateOnly(exam.resultDate);

  if (now.isBefore(applyStart)) {
    return ExamAction(
        exam: exam,
        label: '접수 시작',
        date: applyStart,
        color: const Color(0xFF024AD8),
        icon: Icons.edit_calendar_rounded);
  }
  if (!now.isAfter(applyEnd)) {
    return ExamAction(
        exam: exam,
        label: '접수 마감',
        date: applyEnd,
        color: const Color(0xFFCF4500),
        icon: Icons.timer_outlined);
  }
  if (!now.isAfter(examDate)) {
    return ExamAction(
        exam: exam,
        label: sameDay(now, examDate) ? '시험 당일' : '시험일',
        date: examDate,
        color: const Color(0xFF024AD8),
        icon: Icons.fact_check_outlined);
  }
  if (exam.resultDateKnown && !now.isAfter(resultDate)) {
    return ExamAction(
        exam: exam,
        label: sameDay(now, resultDate) ? '발표 당일' : '합격 발표',
        date: resultDate,
        color: const Color(0xFFCF4500),
        icon: Icons.campaign_outlined);
  }
  return null;
}

List<ExamAction> upcomingExamActions({DateTime? today}) {
  final now = today ?? appToday();
  final actions = <ExamAction>[];
  for (final exam in demoExams) {
    final action = nextExamAction(exam, today: now);
    if (action != null) actions.add(action);
  }
  actions.sort((a, b) {
    final byDate = a.date.compareTo(b.date);
    if (byDate != 0) return byDate;
    return a.exam.name.compareTo(b.exam.name);
  });
  return actions;
}

List<ExamAction> allUpcomingExamActions({DateTime? today}) {
  final now = today ?? appToday();
  final actions = <ExamAction>[];
  for (final exam in demoExams) {
    final applyStart = DateUtils.dateOnly(exam.applyStart);
    final applyEnd = DateUtils.dateOnly(exam.applyEnd);
    final examDate = DateUtils.dateOnly(exam.examDate);
    final resultDate = DateUtils.dateOnly(exam.resultDate);

    if (!applyStart.isBefore(now)) {
      actions.add(ExamAction(
          exam: exam,
          label: applyStart == now ? '접수 시작' : '접수 시작',
          date: applyStart,
          color: const Color(0xFF024AD8),
          icon: Icons.edit_calendar_rounded));
    }
    if (!applyEnd.isBefore(now)) {
      actions.add(ExamAction(
          exam: exam,
          label: '접수 마감',
          date: applyEnd,
          color: const Color(0xFFCF4500),
          icon: Icons.timer_outlined));
    }
    if (!examDate.isBefore(now)) {
      actions.add(ExamAction(
          exam: exam,
          label: sameDay(examDate, now) ? '시험 당일' : '시험일',
          date: examDate,
          color: const Color(0xFF024AD8),
          icon: Icons.fact_check_outlined));
    }
    if (exam.resultDateKnown && !resultDate.isBefore(now)) {
      actions.add(ExamAction(
          exam: exam,
          label: sameDay(resultDate, now) ? '발표 당일' : '합격 발표',
          date: resultDate,
          color: const Color(0xFFCF4500),
          icon: Icons.campaign_outlined));
    }
  }
  actions.sort((a, b) {
    final byDate = a.date.compareTo(b.date);
    if (byDate != 0) return byDate;
    final byLabel = a.label.compareTo(b.label);
    if (byLabel != 0) return byLabel;
    return a.exam.name.compareTo(b.exam.name);
  });
  return actions;
}

List<ExamAction> homeUpcomingActions({DateTime? today, int limit = 8}) {
  final now = today ?? appToday();
  final all = allUpcomingExamActions(today: now);
  if (all.length <= limit) return all;

  // 홈에서는 같은 종류(예: 접수 마감)만 연속으로 보이지 않도록
  // 각 단계의 가장 가까운 일정을 먼저 뽑고, 이후 가까운 일정으로 채웁니다.
  final picked = <ExamAction>[];
  final keys = <String>{};
  const preferred = ['접수 시작', '접수 마감', '시험일', '시험 당일', '합격 발표', '발표 당일'];
  for (final label in preferred) {
    ExamAction? match;
    for (final action in all) {
      if (action.label == label) {
        match = action;
        break;
      }
    }
    if (match != null) {
      final key =
          '${match.exam.id}|${match.label}|${match.date.toIso8601String()}';
      if (keys.add(key)) picked.add(match);
    }
  }
  for (final action in all) {
    if (picked.length >= limit) break;
    final key =
        '${action.exam.id}|${action.label}|${action.date.toIso8601String()}';
    if (keys.add(key)) picked.add(action);
  }
  return picked.take(limit).toList();
}

String examProgressLabel(Exam exam) {
  final today = appToday();
  final aStart = DateUtils.dateOnly(exam.applyStart);
  final aEnd = DateUtils.dateOnly(exam.applyEnd);
  final eDate = DateUtils.dateOnly(exam.examDate);
  final rDate = DateUtils.dateOnly(exam.resultDate);
  if (today.isBefore(aStart)) return '접수 예정';
  if (!today.isAfter(aEnd)) return '접수 중';
  if (today.isBefore(eDate)) return '시험 준비';
  if (sameDay(today, eDate)) return '오늘 시험';
  if (exam.resultDateKnown && !today.isAfter(rDate)) return '발표 대기';
  return '일정 종료';
}

String offlineExamAnswer(Exam exam, String question) {
  final q = question.trim().toLowerCase();
  final today = appToday();
  final action = nextExamAction(exam, today: today);
  final todayText = '${today.year}년 ${today.month}월 ${today.day}일';
  final actionText = action == null
      ? '현재 저장된 회차의 주요 일정은 모두 종료되었습니다.'
      : '현재 다음 일정은 ${action.label} ${shortDate(action.date)} (${action.dday})입니다.';

  if (q.contains('언제') ||
      q.contains('시험일') ||
      q.contains('시험 봐') ||
      q.contains('시험봐')) {
    return '$todayText 기준 ${exam.name} 시험일은 ${shortDate(exam.examDate)}입니다. $actionText 접수기간은 ${shortDate(exam.applyStart)}~${shortDate(exam.applyEnd)}입니다.';
  }
  if (q.contains('접수') || q.contains('신청') || q.contains('원서')) {
    return '$todayText 기준 ${exam.name} 접수기간은 ${shortDate(exam.applyStart)}~${shortDate(exam.applyEnd)}입니다. 현재 상태는 “${examProgressLabel(exam)}”이고, $actionText';
  }
  if (q.contains('발표') || q.contains('결과') || q.contains('합격자')) {
    return exam.resultDateKnown
        ? '${exam.name} 합격 발표일은 ${shortDate(exam.resultDate)}입니다. $todayText 기준 상태는 “${examProgressLabel(exam)}”입니다.'
        : '${exam.name}의 합격 발표일은 현재 저장된 공식 데이터에서 확정되지 않았습니다. ${exam.officialSource}에서 최종 공지를 확인하세요.';
  }
  if (q.contains('응시') || q.contains('자격'))
    return '${exam.name} 응시자격: ${exam.eligibility}';
  if (q.contains('과목') || q.contains('뭐 봐') || q.contains('무엇'))
    return '${exam.name} 시험과목은 ${exam.subjects.join(' · ')}입니다.';
  if (q.contains('합격') || q.contains('기준') || q.contains('몇 점'))
    return '${exam.name} 합격기준: ${exam.passRule}';
  if (q.contains('공부') || q.contains('준비') || q.contains('팁')) {
    final left = DateUtils.dateOnly(exam.examDate).difference(today).inDays;
    return '${exam.name} 준비 팁: ${exam.tip} ${left >= 0 ? '시험일까지 $left일 남았습니다.' : '해당 회차 시험일은 지났습니다.'}';
  }
  return '$todayText 기준 ${exam.name}은 현재 “${examProgressLabel(exam)}” 상태입니다. $actionText ${exam.aiSummary} 응시자격은 ${exam.eligibility}이며, 합격기준은 ${exam.passRule}입니다.';
}

String offlineSmartAnswer(Exam exam, String question) {
  final q = question.trim().toLowerCase();
  final appQuestion = q.contains('이 앱') ||
      q.contains('앱 설명') ||
      q.contains('certi:on') ||
      q.contains('certion') ||
      q.contains('뭐하는 앱') ||
      q.contains('무슨 앱') ||
      q.contains('기능');

  if (appQuestion) {
    return 'CERTI:ON은 자격증·시험 정보를 한곳에서 확인하고 공식 일정 데이터를 AI가 이해하기 쉽게 정리해 주는 자격증 일정·플래너 앱입니다. '
        '가까운 접수·시험 일정 확인, 자격증 검색, 일정 달력, AI 핵심 브리핑·추가 질문, 공식 출처 확인, MY/플래너, 자격증 비교 기능을 제공합니다. '
        'AI가 임의로 일정을 만드는 것이 아니라 앱에 저장된 공식 일정 데이터를 바탕으로 사용자가 빠르게 이해하고 원문 출처를 직접 검증하도록 돕는 것이 핵심입니다.';
  }

  return offlineExamAnswer(exam, question);
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  int _index = 0;
  late DateTime _lastToday;
  Timer? _dateTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastToday = appToday();
    _dateTimer = Timer.periodic(
        const Duration(minutes: 1), (_) => _refreshDateIfNeeded());
    _bootData();
  }

  void _refreshDateIfNeeded() {
    final today = appToday();
    if (!sameDay(today, _lastToday) && mounted) {
      setState(() => _lastToday = today);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshDateIfNeeded();
  }

  @override
  void dispose() {
    _dateTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _bootData() async {
    await loadOfficialAssetData();
    if (mounted) setState(() {});
    await _syncRemote();
  }

  Future<void> _syncRemote() async {
    final results = await Future.wait<dynamic>([
      CertiRemoteService.fetchExams(),
      CertiRemoteService.fetchRollingExams(),
    ]);
    if (!mounted) return;
    final remote = results[0] as List<Exam>?;
    final remoteRolling = results[1] as List<RollingExam>?;
    if (remote == null && remoteRolling == null) return;
    setState(() {
      if (remote != null) demoExams = remote;
      if (remoteRolling != null) rollingExams = remoteRolling;
    });
  }

  final Set<String> _favorites = {'qnet-2026-3-practical-info', 'sqld63'};
  final Set<String> _acquired = <String>{};

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  void _toggleAcquired(String name) {
    setState(() {
      if (_acquired.contains(name)) {
        _acquired.remove(name);
      } else {
        _acquired.add(name);
      }
    });
  }

  void _goTo(int index) {
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
        onNavigate: _goTo,
      ),
      ExplorePage(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
      ),
      CalendarPage(
        key: ValueKey(
            'calendar-${_lastToday.year}-${_lastToday.month}-${_lastToday.day}'),
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
      ),
      AiBriefPage(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
      ),
      MyPage(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
        acquired: _acquired,
        onToggleAcquired: _toggleAcquired,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _CertiBottomNav(
        selectedIndex: _index,
        onDestinationSelected: _goTo,
      ),
    );
  }
}

class _CertiBottomNav extends StatelessWidget {
  const _CertiBottomNav({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _items = <(IconData, String)>[
    (Icons.home_rounded, '홈'),
    (Icons.search_rounded, '탐색'),
    (Icons.calendar_month_rounded, '일정'),
    (Icons.auto_awesome_rounded, 'AI 브리핑'),
    (Icons.person_rounded, 'MY'),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 74,
          child: Row(
            children: List.generate(_items.length, (index) {
              final selected = selectedIndex == index;
              final item = _items[index];
              return Expanded(
                child: InkWell(
                  onTap: () => onDestinationSelected(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: 46,
                          height: 30,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFE8E2DA)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            item.$1,
                            size: 23,
                            color: selected
                                ? const Color(0xFF024AD8)
                                : const Color(0xFF141413),
                          ),
                        ),
                        const SizedBox(height: 3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            item.$2,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: selected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: selected
                                  ? const Color(0xFF024AD8)
                                  : const Color(0xFF696969),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onNavigate,
  });

  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final today = appToday();
    final allActions = allUpcomingExamActions(today: today);
    final actions = homeUpcomingActions(today: today);
    final nextAction = allActions.isNotEmpty ? allActions.first : null;
    final favoriteExams =
        demoExams.where((e) => favorites.contains(e.id)).toList();

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TopBar(onBell: () => _showNoticeCenter(context)),
                const SizedBox(height: 18),
                if (nextAction != null)
                  _HeroSummaryCard(
                    action: nextAction,
                    isFavorite: favorites.contains(nextAction.exam.id),
                    onFavorite: () => onToggleFavorite(nextAction.exam.id),
                    onCalendar: () => onNavigate(2),
                  )
                else
                  const _NoUpcomingHero(),
                const SizedBox(height: 24),
                _SectionTitle(
                  title: '다가오는 일정',
                  subtitle:
                      '${today.month}월 ${today.day}일 기준 · 단계별 가장 가까운 접수·시험·발표 일정',
                  trailing: TextButton(
                    onPressed: () => onNavigate(2),
                    child: const Text('전체보기'),
                  ),
                ),
                const SizedBox(height: 12),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 166,
              child: actions.isEmpty
                  ? const Center(child: Text('현재 등록된 미래 일정이 없습니다.'))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: math.min(8, actions.length),
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, index) {
                        final action = actions[index];
                        return _DdayCard(
                          action: action,
                          isFavorite: favorites.contains(action.exam.id),
                          onFavorite: () => onToggleFavorite(action.exam.id),
                        );
                      },
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 28),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionTitle(
                  title: 'AI가 정리한 오늘의 핵심',
                  subtitle: '오늘 날짜와 가장 가까운 일정 기준으로 자동 변경돼요',
                ),
                const SizedBox(height: 12),
                _AiInsightCard(actions: actions, onTap: () => onNavigate(3)),
                const SizedBox(height: 24),
                const _SectionTitle(
                  title: '스마트 준비 도구',
                  subtitle: '찾기에서 끝내지 않고 실제 준비 행동까지 이어줘요',
                ),
                const SizedBox(height: 12),
                _SmartToolGrid(
                  favorites: favorites,
                  onToggleFavorite: onToggleFavorite,
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  title: '내 관심 자격증',
                  subtitle: favoriteExams.isEmpty
                      ? '관심 자격증을 저장하면 오늘 기준 다음 일정이 자동 계산돼요'
                      : '${favoriteExams.length}개 자격증을 관리 중이에요',
                  trailing: IconButton(
                    onPressed: () => onNavigate(1),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                if (favoriteExams.isEmpty)
                  _EmptyFavoriteCard(onTap: () => onNavigate(1))
                else
                  ...favoriteExams.take(3).map(
                        (exam) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ExamListTile(
                            exam: exam,
                            isFavorite: true,
                            onFavorite: () => onToggleFavorite(exam.id),
                          ),
                        ),
                      ),
                const SizedBox(height: 8),
                const _TrustBanner(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoUpcomingHero extends StatelessWidget {
  const _NoUpcomingHero();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: const Color(0xFF141413),
          borderRadius: BorderRadius.circular(28)),
      child: const Row(children: [
        Icon(Icons.event_busy_rounded, color: Color(0xFFCF4500)),
        SizedBox(width: 12),
        Expanded(
            child: Text('현재 저장된 미래 일정이 없습니다. 동기화 후 새 회차가 공개되면 자동으로 표시됩니다.',
                style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.w700))),
      ]),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBell});

  final VoidCallback onBell;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF024AD8), Color(0xFF024AD8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CERTI:ON',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                  color: Color(0xFF141413),
                ),
              ),
              Text(
                '자격증 준비, 흩어지지 않게',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF696969),
                ),
              ),
            ],
          ),
        ),
        _CircleIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onBell,
          badge: true,
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.badge = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: onTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, color: const Color(0xFF262627)),
            ),
          ),
        ),
        if (badge)
          Positioned(
            top: 7,
            right: 7,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFCF4500),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroSummaryCard extends StatelessWidget {
  const _HeroSummaryCard({
    required this.action,
    required this.isFavorite,
    required this.onFavorite,
    required this.onCalendar,
  });

  final ExamAction action;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onCalendar;

  @override
  Widget build(BuildContext context) {
    final exam = action.exam;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF141413), Color(0xFF024AD8), Color(0xFF024AD8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
              color: Color(0x22024AD8), blurRadius: 22, offset: Offset(0, 12))
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
            top: 18,
            child: AppAssetThumb(
                assetPath: categoryImageAsset(exam.category),
                width: 105,
                height: 126,
                borderRadius: 24),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 116),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(action.icon, size: 17, color: const Color(0xFFD1CDC7)),
                  const SizedBox(width: 6),
                  Text(
                      '${appToday().month}월 ${appToday().day}일 · ${action.label}',
                      style: const TextStyle(
                          color: Color(0xFFE8E2DA),
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                ]),
                const SizedBox(height: 18),
                Text('${action.label} ${action.dday}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8)),
                const SizedBox(height: 8),
                Text('${exam.name} · ${shortDate(action.date)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xFFE8E2DA),
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF024AD8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 11)),
                    onPressed: () =>
                        showExamDetail(context, exam, isFavorite, onFavorite),
                    icon: const Icon(Icons.article_outlined, size: 18),
                    label: const Text('상세보기'),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 11)),
                    onPressed: onCalendar,
                    icon: const Icon(Icons.calendar_month_rounded, size: 18),
                    label: const Text('캘린더'),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: Color(0xFF141413),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Color(0xFF696969),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _DdayCard extends StatelessWidget {
  const _DdayCard({
    required this.action,
    required this.isFavorite,
    required this.onFavorite,
  });

  final ExamAction action;
  final bool isFavorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final exam = action.exam;
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => showExamDetail(context, exam, isFavorite, onFavorite),
      child: Container(
        width: 205,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFD1CDC7))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 9,
                height: 9,
                decoration:
                    BoxDecoration(color: action.color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(
                child: Text(action.label,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF696969)))),
            Text(action.dday,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: action.color)),
          ]),
          const SizedBox(height: 12),
          Text(exam.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 15,
                  height: 1.25,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF141413))),
          const Spacer(),
          Row(children: [
            Icon(action.icon, size: 14, color: action.color),
            const SizedBox(width: 5),
            Text('${action.label} ${shortDate(action.date)}',
                style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF696969),
                    fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 5),
          Text(exam.category,
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF696969),
                  fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

class _AiInsightCard extends StatelessWidget {
  const _AiInsightCard({required this.actions, required this.onTap});

  final List<ExamAction> actions;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final message = actions.isEmpty
        ? '새 공식 일정이 공개되면 오늘 날짜 기준으로 우선순위를 자동 정리합니다.'
        : actions.length == 1
            ? '${actions.first.exam.name}의 ${actions.first.label}이 ${shortDate(actions.first.date)}에 있습니다.'
            : '${actions[0].exam.name} ${actions[0].label}과 ${actions[1].exam.name} ${actions[1].label}을 먼저 확인하세요.';
    return Material(
      color: const Color(0xFFE8E2DA),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Row(children: [
            const AppAssetThumb(
                assetPath: 'assets/images/feature_ai.png',
                width: 64,
                height: 64,
                borderRadius: 18),
            const SizedBox(width: 15),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Row(children: [
                    Text('CERTI AI',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF024AD8))),
                    SizedBox(width: 6),
                    _TinyBadge(text: '오늘 기준')
                  ]),
                  const SizedBox(height: 7),
                  Text(message,
                      style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF262627))),
                ])),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Color(0xFF696969)),
          ]),
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: Color(0xFF696969),
        ),
      ),
    );
  }
}

class _EmptyFavoriteCard extends StatelessWidget {
  const _EmptyFavoriteCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD1CDC7)),
      ),
      child: Row(
        children: [
          const AppAssetThumb(
            assetPath: 'assets/images/feature_profile.png',
            width: 58,
            height: 58,
            borderRadius: 18,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '준비 중인 자격증을 추가하면 접수 마감과 시험일을 한곳에서 관리할 수 있어요.',
              style: TextStyle(
                height: 1.45,
                fontWeight: FontWeight.w700,
                color: Color(0xFF696969),
              ),
            ),
          ),
          TextButton(onPressed: onTap, child: const Text('추가')),
        ],
      ),
    );
  }
}

class _TrustBanner extends StatelessWidget {
  const _TrustBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141413),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, color: Color(0xFFCF4500)),
          SizedBox(width: 13),
          Expanded(
            child: Text(
              '일정은 공식 주관처 출처를 기준으로 표시하고, AI 요약은 원문 확인 경로와 함께 제공하는 구조입니다.',
              style: TextStyle(
                color: Color(0xFFFCFBFA),
                height: 1.45,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12),
          AppAssetThumb(
              assetPath: 'assets/images/feature_trust.png',
              width: 66,
              height: 66,
              borderRadius: 18),
        ],
      ),
    );
  }
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _query = '';
  String _category = '전체';
  String _status = '전체';

  static const categories = [
    '전체',
    'IT·개발',
    'AI',
    '데이터',
    '전기·전자',
    '안전·산업',
    '건축·토목',
    '사무·OA',
    '디자인',
    '서비스·경영',
    '어학',
    '공기업·공무원',
    '기타'
  ];
  static const statuses = ['전체', '접수중', '접수예정', '시험임박', '발표대기'];

  @override
  Widget build(BuildContext context) {
    final normalized = _query.trim().toLowerCase();
    final today = appToday();
    bool matchesStatus(Exam exam) {
      final applyStart = DateUtils.dateOnly(exam.applyStart);
      final applyEnd = DateUtils.dateOnly(exam.applyEnd);
      final examDate = DateUtils.dateOnly(exam.examDate);
      final resultDate = DateUtils.dateOnly(exam.resultDate);
      switch (_status) {
        case '접수중':
          return !today.isBefore(applyStart) && !today.isAfter(applyEnd);
        case '접수예정':
          return today.isBefore(applyStart);
        case '시험임박':
          final d = examDate.difference(today).inDays;
          return d >= 0 && d <= 30;
        case '발표대기':
          return today.isAfter(examDate) &&
              (!exam.resultDateKnown || !today.isAfter(resultDate));
        default:
          return true;
      }
    }

    final filtered = demoExams.where((exam) {
      final matchesCategory = _category == '전체' || exam.category == _category;
      final haystack =
          '${exam.name} ${exam.organizer} ${exam.category}'.toLowerCase();
      return matchesCategory &&
          matchesStatus(exam) &&
          (normalized.isEmpty || haystack.contains(normalized));
    }).toList();
    final rollingMatches = rollingExams.where((exam) {
      final matchesCategory = _category == '전체' || exam.category == _category;
      final haystack =
          '${exam.name} ${exam.organizer} ${exam.category}'.toLowerCase();
      return matchesCategory &&
          (normalized.isEmpty || haystack.contains(normalized));
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '자격증 탐색',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                          color: Color(0xFF141413),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '광고 대신 공식 정보 기준으로 빠르게 찾으세요',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF696969),
                        ),
                      ),
                    ],
                  ),
                ),
                _CircleIconButton(
                  icon: Icons.tune_rounded,
                  onTap: () => _showFilterInfo(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: '자격증, 주관처, 분야 검색',
                suffixIcon: Icon(Icons.mic_none_rounded),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final category = categories[index];
                final selected = category == _category;
                return ChoiceChip(
                  selected: selected,
                  onSelected: (_) => setState(() => _category = category),
                  label: Text(category),
                  showCheckmark: false,
                  selectedColor: const Color(0xFF024AD8),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: selected
                        ? const Color(0xFF024AD8)
                        : const Color(0xFFE8E2DA),
                  ),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF696969),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: statuses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 7),
              itemBuilder: (_, index) {
                final status = statuses[index];
                final selected = status == _status;
                return FilterChip(
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _status = status),
                  label: Text(status),
                  selectedColor: const Color(0xFF141413),
                  backgroundColor: const Color(0xFFFCFBFA),
                  side: BorderSide(
                      color: selected
                          ? const Color(0xFF141413)
                          : const Color(0xFFD1CDC7)),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF696969),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: (filtered.isEmpty && rollingMatches.isEmpty)
                ? const _NoSearchResult()
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                    itemCount:
                        filtered.length + (rollingMatches.isNotEmpty ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      if (rollingMatches.isNotEmpty && index == 0) {
                        return _RollingSearchBanner(
                          count: rollingMatches.length,
                          query: _query,
                        );
                      }
                      final offset = rollingMatches.isNotEmpty ? 1 : 0;
                      final exam = filtered[index - offset];
                      return ExamListTile(
                        exam: exam,
                        isFavorite: widget.favorites.contains(exam.id),
                        onFavorite: () => widget.onToggleFavorite(exam.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NoSearchResult extends StatelessWidget {
  const _NoSearchResult();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 46, color: Color(0xFFD1CDC7)),
            SizedBox(height: 12),
            Text(
              '검색 결과가 없어요',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
            ),
            SizedBox(height: 5),
            Text(
              '검색어를 줄이거나 다른 분야를 선택해보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF696969)),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamListTile extends StatelessWidget {
  const ExamListTile({
    super.key,
    required this.exam,
    required this.isFavorite,
    required this.onFavorite,
  });

  final Exam exam;
  final bool isFavorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final d = daysUntil(exam.applyEnd);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => showExamDetail(context, exam, isFavorite, onFavorite),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFD1CDC7)),
          ),
          child: Row(
            children: [
              AppAssetThumb(
                assetPath: categoryImageAsset(exam.category),
                width: 49,
                height: 49,
                borderRadius: 16,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            exam.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF262627),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F0EE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            exam.badge,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Color(0xFF696969),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      exam.organizer,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF696969),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 14, color: exam.color),
                        const SizedBox(width: 5),
                        Text(
                          '접수 ${shortDate(exam.applyEnd)}까지',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF696969),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          d >= 0 ? 'D-$d' : '마감',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: d <= 3
                                ? const Color(0xFFCF4500)
                                : const Color(0xFF024AD8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFavorite ? '관심 해제' : '관심 추가',
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isFavorite
                      ? const Color(0xFF024AD8)
                      : const Color(0xFF696969),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _month;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final today = appToday();
    final candidates = <DateTime>[];

    for (final exam in demoExams) {
      candidates.addAll([
        exam.applyStart,
        exam.applyEnd,
        exam.examDate,
        if (exam.resultDateKnown) exam.resultDate,
      ]);
    }

    candidates.sort();
    DateTime? nearest;
    for (final date in candidates) {
      if (!date.isBefore(today)) {
        nearest = date;
        break;
      }
    }
    final initial = nearest ?? today;
    _month = DateTime(initial.year, initial.month);
    _selectedDay = initial;
  }

  void _moveMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
      _selectedDay = DateTime(_month.year, _month.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedDay;
    final events = selected == null ? <_CalendarEvent>[] : _eventsOn(selected);

    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '통합 시험 캘린더',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                        color: Color(0xFF141413),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '접수 · 시험 · 발표를 한 화면에서',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF696969),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _CircleIconButton(
                icon: Icons.sync_rounded,
                onTap: () => _showSyncInfo(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFFD1CDC7)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _moveMonth(-1),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Expanded(
                      child: Text(
                        '${_month.year}년 ${_month.month}월',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF262627),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _moveMonth(1),
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    _WeekLabel('일', color: Color(0xFFCF4500)),
                    _WeekLabel('월'),
                    _WeekLabel('화'),
                    _WeekLabel('수'),
                    _WeekLabel('목'),
                    _WeekLabel('금'),
                    _WeekLabel('토', color: Color(0xFF024AD8)),
                  ],
                ),
                const SizedBox(height: 5),
                _MonthGrid(
                  month: _month,
                  selected: _selectedDay,
                  onSelect: (day) => setState(() => _selectedDay = day),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (selected != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${selected.month}월 ${selected.day}일 일정',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF262627),
                    ),
                  ),
                ),
                Text(
                  '${events.length}건',
                  style: const TextStyle(
                    color: Color(0xFF696969),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (events.isEmpty)
              const _EmptyDay()
            else
              ...events.map((event) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CalendarEventCard(
                      event: event,
                      favorite: widget.favorites.contains(event.exam.id),
                      onFavorite: () => widget.onToggleFavorite(event.exam.id),
                    ),
                  )),
          ],
          const SizedBox(height: 10),
          const _CalendarLegend(),
        ],
      ),
    );
  }
}

class _WeekLabel extends StatelessWidget {
  const _WeekLabel(this.text, {this.color = const Color(0xFF696969)});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800, color: color),
          ),
        ),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.selected,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime? selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startOffset = first.weekday % 7;
    final totalCells = ((startOffset + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.83,
      ),
      itemCount: totalCells,
      itemBuilder: (_, index) {
        final dayNumber = index - startOffset + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final day = DateTime(month.year, month.month, dayNumber);
        final isSelected = selected != null && sameDay(day, selected!);
        final isToday = sameDay(day, appToday());
        final events = _eventsOn(day);
        final weekDay = day.weekday;

        Color textColor = const Color(0xFF696969);
        if (weekDay == DateTime.sunday) textColor = const Color(0xFFCF4500);
        if (weekDay == DateTime.saturday) textColor = const Color(0xFF024AD8);
        if (isSelected) textColor = Colors.white;

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onSelect(day),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF024AD8) : Colors.transparent,
                borderRadius: BorderRadius.circular(13),
                border: isToday && !isSelected
                    ? Border.all(color: const Color(0xFF024AD8), width: 1.2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w900
                          : FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.take(3).map((event) {
                      return Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : event.color,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CalendarEvent {
  const _CalendarEvent({
    required this.exam,
    required this.type,
    required this.color,
    required this.label,
  });

  final Exam exam;
  final String type;
  final Color color;
  final String label;
}

List<_CalendarEvent> _eventsOn(DateTime day) {
  final result = <_CalendarEvent>[];
  for (final exam in demoExams) {
    if (sameDay(day, exam.applyStart)) {
      result.add(_CalendarEvent(
        exam: exam,
        type: '접수 시작',
        color: const Color(0xFFCF4500),
        label: '접수 시작',
      ));
    }
    if (sameDay(day, exam.applyEnd)) {
      result.add(_CalendarEvent(
        exam: exam,
        type: '접수 마감',
        color: const Color(0xFFCF4500),
        label: '접수 마감',
      ));
    }
    if (sameDay(day, exam.examDate)) {
      result.add(_CalendarEvent(
        exam: exam,
        type: '시험일',
        color: const Color(0xFF024AD8),
        label: '시험',
      ));
    }
    if (exam.resultDateKnown && sameDay(day, exam.resultDate)) {
      result.add(_CalendarEvent(
        exam: exam,
        type: '결과 발표',
        color: const Color(0xFFCF4500),
        label: '발표',
      ));
    }
  }
  return result;
}

class _CalendarEventCard extends StatelessWidget {
  const _CalendarEventCard({
    required this.event,
    required this.favorite,
    required this.onFavorite,
  });

  final _CalendarEvent event;
  final bool favorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showExamDetail(context, event.exam, favorite, onFavorite),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD1CDC7)),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: event.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.exam.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF262627),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      event.exam.organizer,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF696969),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  favorite
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: favorite
                      ? const Color(0xFF024AD8)
                      : const Color(0xFF696969),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1CDC7)),
      ),
      child: const Row(
        children: [
          Icon(Icons.event_available_rounded, color: Color(0xFF024AD8)),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              '등록된 시험 일정이 없는 날이에요. 학습 계획을 배치하기 좋아요.',
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w700,
                color: Color(0xFF696969),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _LegendDot(color: Color(0xFFCF4500), label: '접수 시작'),
        _LegendDot(color: Color(0xFFCF4500), label: '접수 마감'),
        _LegendDot(color: Color(0xFF024AD8), label: '시험'),
        _LegendDot(color: Color(0xFFCF4500), label: '발표'),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF696969),
          ),
        ),
      ],
    );
  }
}

class AiBriefPage extends StatefulWidget {
  const AiBriefPage({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;

  @override
  State<AiBriefPage> createState() => _AiBriefPageState();
}

class _AiBriefPageState extends State<AiBriefPage> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final actionList = upcomingExamActions();
    final candidates = <Exam>[];
    final seen = <String>{};
    for (final action in actionList) {
      if (seen.add(action.exam.id)) candidates.add(action.exam);
    }
    if (candidates.isEmpty) candidates.addAll(demoExams);
    final safeIndex = candidates.isEmpty ? 0 : _selected % candidates.length;
    final exam = candidates[safeIndex];

    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
        children: [
          const Text(
            'AI 핵심 브리핑',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
              color: Color(0xFF141413),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${appToday().year}년 ${appToday().month}월 ${appToday().day}일 기준 · 공식 정보를 빠르게 이해하는 AI 요약',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF696969),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const LinearGradient(
                colors: [Color(0xFF141413), Color(0xFF024AD8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: Color(0xFFCF4500), size: 20),
                    SizedBox(width: 7),
                    Text(
                      '공식정보 우선 AI',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.1,
                        color: Color(0xFFCF4500),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13),
                Text(
                  '“AI가 대신 결정”이 아니라\n“공식 정보를 더 빨리 이해”하게',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    height: 1.3,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  '요약 아래에 출처·응시자격·합격기준을 함께 보여줘 사용자가 원문까지 검증할 수 있도록 설계했습니다.',
                  style: TextStyle(
                    color: Color(0xFFD1CDC7),
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '브리핑할 자격증',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xFF262627)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: candidates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final selected = index == safeIndex;
                return ChoiceChip(
                  showCheckmark: false,
                  selected: selected,
                  selectedColor: const Color(0xFF024AD8),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                      color: selected
                          ? const Color(0xFF024AD8)
                          : const Color(0xFFE8E2DA)),
                  label: Text(candidates[index].name),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF696969),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                  onSelected: (_) => setState(() => _selected = index),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          _AiSummaryPanel(
            exam: exam,
            favorite: widget.favorites.contains(exam.id),
            onFavorite: () => widget.onToggleFavorite(exam.id),
          ),
          const SizedBox(height: 16),
          _SourceConfidenceCard(exam: exam),
          const SizedBox(height: 16),
          _DemoAiAskCard(exam: exam),
        ],
      ),
    );
  }
}

class _AiSummaryPanel extends StatelessWidget {
  const _AiSummaryPanel({
    required this.exam,
    required this.favorite,
    required this.onFavorite,
  });

  final Exam exam;
  final bool favorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFD1CDC7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: exam.color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(categoryIcon(exam.category), color: exam.color),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      exam.organizer,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF696969),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  favorite
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: favorite
                      ? const Color(0xFF024AD8)
                      : const Color(0xFF696969),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Builder(builder: (context) {
            final action = nextExamAction(exam);
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFFF3F0EE),
                  borderRadius: BorderRadius.circular(14)),
              child: Text(
                action == null
                    ? '오늘 기준 · ${examProgressLabel(exam)}'
                    : '오늘 기준 · ${examProgressLabel(exam)} · 다음 일정 ${action.label} ${shortDate(action.date)} (${action.dday})',
                style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF696969),
                    fontWeight: FontWeight.w800),
              ),
            );
          }),
          const SizedBox(height: 18),
          const _AiSectionLabel(icon: Icons.summarize_rounded, text: '30초 요약'),
          const SizedBox(height: 8),
          Text(
            exam.aiSummary,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF696969),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          const _AiSectionLabel(
              icon: Icons.person_search_rounded, text: '응시자격'),
          const SizedBox(height: 8),
          Text(
            exam.eligibility,
            style: const TextStyle(
                fontSize: 12, height: 1.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          const _AiSectionLabel(icon: Icons.fact_check_outlined, text: '합격기준'),
          const SizedBox(height: 8),
          Text(
            exam.passRule,
            style: const TextStyle(
                fontSize: 12, height: 1.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          const _AiSectionLabel(
              icon: Icons.lightbulb_outline_rounded, text: '준비 팁'),
          const SizedBox(height: 8),
          Text(
            exam.tip,
            style: const TextStyle(
                fontSize: 12, height: 1.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _AiSectionLabel extends StatelessWidget {
  const _AiSectionLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: const Color(0xFF024AD8)),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF024AD8),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SourceConfidenceCard extends StatelessWidget {
  const _SourceConfidenceCard({required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFBFA),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8E2DA)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFCF4500),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.verified_rounded, color: Colors.white),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '출처 신뢰도 · 공식 1차 출처',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFCF4500),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exam.scheduleNote.isEmpty
                      ? exam.officialSource
                      : '${exam.officialSource} · ${exam.scheduleNote}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF696969),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showSourceDialog(context, exam),
            child: const Text('출처보기'),
          ),
        ],
      ),
    );
  }
}

class _DemoAiAskCard extends StatefulWidget {
  const _DemoAiAskCard({required this.exam});

  final Exam exam;

  @override
  State<_DemoAiAskCard> createState() => _DemoAiAskCardState();
}

class _DemoAiAskCardState extends State<_DemoAiAskCard> {
  final _controller = TextEditingController();
  String? _answer;
  String? _aiError;
  bool _loading = false;
  bool _checkingHealth = false;
  bool _phoneMode = Platform.isAndroid;
  bool _phoneInstalled = false;
  bool _downloading = false;
  double _downloadProgress = 0;
  String _answerKind = 'fallback';
  AiHealth? _health;
  PhoneAiModelSpec _phoneSpec = phoneAiHigh;
  String _pcModel = certiSelectedAiModel;

  static const List<Map<String, String>> _pcModelOptions = [
    {'level': '높음', 'size': '14B', 'model': 'qwen3:14b'},
    {'level': '보통', 'size': '8B', 'model': 'qwen3:8b'},
    {'level': '낮음', 'size': '4B', 'model': 'qwen3:4b'},
  ];

  @override
  void initState() {
    super.initState();
    _refreshPhoneState();
  }

  Future<void> _refreshPhoneState() async {
    try {
      final installed =
          await CertiPhoneAiService.instance.isInstalled(_phoneSpec);
      if (!mounted) return;
      setState(() => _phoneInstalled = installed);
    } catch (_) {
      if (!mounted) return;
      setState(() => _phoneInstalled = false);
    }
  }

  Future<void> _checkPcHealth() async {
    final modelToCheck = _pcModel;
    if (mounted) setState(() => _checkingHealth = true);
    final health = await CertiRemoteService.checkAiHealth(model: modelToCheck);
    if (!mounted || modelToCheck != _pcModel) return;
    setState(() {
      _health = health;
      _checkingHealth = false;
    });
  }

  void _setMode(bool phoneMode) {
    if (_loading || _downloading) return;
    if (phoneMode && !Platform.isAndroid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('iPhone에서는 현재 휴대폰 단독 GGUF AI 대신 PC 고성능 AI를 사용합니다.')),
      );
      return;
    }
    setState(() {
      _phoneMode = phoneMode;
      _aiError = null;
      _answer = null;
      _answerKind = 'fallback';
    });
    if (phoneMode) {
      _refreshPhoneState();
    } else {
      _checkPcHealth();
    }
  }

  void _selectPhoneModel(PhoneAiModelSpec spec) {
    if (_loading || _downloading || spec.id == _phoneSpec.id) return;
    setState(() {
      _phoneSpec = spec;
      _phoneInstalled = false;
      _aiError = null;
      _answer = null;
    });
    _refreshPhoneState();
  }

  void _selectPcModel(String model) {
    if (_loading || _pcModel == model) return;
    setState(() {
      _pcModel = model;
      certiSelectedAiModel = model;
      _health = null;
      _aiError = null;
    });
    _checkPcHealth();
  }

  Future<void> _downloadPhoneModel() async {
    if (_downloading || _loading) return;
    setState(() {
      _downloading = true;
      _downloadProgress = 0;
      _aiError = null;
    });
    try {
      await CertiPhoneAiService.instance.downloadModel(
        _phoneSpec,
        onProgress: (progress) {
          if (!mounted) return;
          setState(() => _downloadProgress = progress);
        },
      );
      if (!mounted) return;
      setState(() {
        _phoneInstalled = true;
        _downloading = false;
        _downloadProgress = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${_phoneSpec.label} 모델 설치 완료. 이제 Wi-Fi 없이도 AI를 사용할 수 있습니다.')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _downloading = false;
        _aiError = '모델 다운로드 실패: $e';
      });
    }
  }

  Future<void> _deletePhoneModel() async {
    if (_loading || _downloading) return;
    try {
      await CertiPhoneAiService.instance.deleteModel(_phoneSpec);
      if (!mounted) return;
      setState(() {
        _phoneInstalled = false;
        _answer = null;
        _aiError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _aiError = '모델 삭제 실패: $e');
    }
  }

  String _normalizedServerUrl(String raw) {
    var value = raw.trim();
    if (value.isEmpty) return '';
    if (!value.contains('://')) value = 'http://$value';
    final uri = Uri.tryParse(value);
    if (uri == null || uri.host.isEmpty) return '';
    if (!uri.hasPort) value = '${uri.scheme}://${uri.host}:8787';
    return value.replaceAll(RegExp(r'/+$'), '');
  }

  Future<void> _editServerUrl() async {
    final controller = TextEditingController(text: certiApiBaseUrl);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('PC AI 서버 주소'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PC 고성능 모드를 쓸 때만 필요합니다. 노트북과 휴대폰을 같은 Wi-Fi에 연결한 뒤 노트북 IPv4를 입력하세요.',
              style: TextStyle(fontSize: 12, height: 1.45),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration: const InputDecoration(hintText: '192.168.0.25'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('취소')),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              child: const Text('적용')),
        ],
      ),
    );
    controller.dispose();
    if (!mounted || result == null) return;
    final normalized = _normalizedServerUrl(result);
    if (normalized.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('서버 주소 형식이 올바르지 않습니다.')));
      return;
    }
    setState(() {
      certiApiBaseUrl = normalized;
      _health = null;
      _aiError = null;
    });
    await _checkPcHealth();
  }

  Widget _modeButton(
      {required bool phone, required String title, required String subtitle}) {
    final selected = _phoneMode == phone;
    return Expanded(
      child: SizedBox(
        height: 58,
        child: OutlinedButton(
          onPressed:
              (_loading || _downloading || (phone && !Platform.isAndroid))
                  ? null
                  : () => _setMode(phone),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
            backgroundColor: selected ? const Color(0xFF024AD8) : Colors.white,
            foregroundColor: selected ? Colors.white : const Color(0xFF383838),
            side: BorderSide(
                color: selected
                    ? const Color(0xFF024AD8)
                    : const Color(0xFFD1CDC7),
                width: selected ? 1.5 : 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color:
                        selected ? Colors.white70 : const Color(0xFF858585))),
          ]),
        ),
      ),
    );
  }

  Widget _phoneModelButton(PhoneAiModelSpec spec) {
    final selected = _phoneSpec.id == spec.id;
    return Expanded(
      child: SizedBox(
        height: 58,
        child: OutlinedButton(
          onPressed:
              (_loading || _downloading) ? null : () => _selectPhoneModel(spec),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            backgroundColor: selected ? const Color(0xFFEAF1FF) : Colors.white,
            foregroundColor: const Color(0xFF141413),
            side: BorderSide(
                color: selected
                    ? const Color(0xFF024AD8)
                    : const Color(0xFFD1CDC7),
                width: selected ? 1.5 : 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(spec.label,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text('${spec.shortLabel} · ${spec.downloadSize}',
                style: const TextStyle(
                    fontSize: 8.5,
                    color: Color(0xFF696969),
                    fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }

  Widget _pcModelButton(Map<String, String> option) {
    final model = option['model']!;
    final selected = _pcModel == model;
    return Expanded(
      child: SizedBox(
        height: 52,
        child: OutlinedButton(
          onPressed: _loading ? null : () => _selectPcModel(model),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
            backgroundColor: selected ? const Color(0xFF024AD8) : Colors.white,
            foregroundColor: selected ? Colors.white : const Color(0xFF383838),
            side: BorderSide(
                color: selected
                    ? const Color(0xFF024AD8)
                    : const Color(0xFFD1CDC7),
                width: selected ? 1.5 : 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(option['level']!,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(option['size']!,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color:
                        selected ? Colors.white70 : const Color(0xFF858585))),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    final q = _controller.text.trim();
    if (q.isEmpty || _loading || _downloading) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _answer = null;
      _aiError = null;
      _answerKind = 'fallback';
    });

    if (_phoneMode) {
      final installed =
          await CertiPhoneAiService.instance.isInstalled(_phoneSpec);
      if (!installed) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _phoneInstalled = false;
          _aiError = '${_phoneSpec.label} 모델을 먼저 Wi-Fi로 한 번 다운로드하세요.';
          _answer = offlineSmartAnswer(widget.exam, q);
        });
        return;
      }
      try {
        final answer = await CertiPhoneAiService.instance
            .ask(spec: _phoneSpec, selectedExam: widget.exam, question: q);
        if (!mounted) return;
        setState(() {
          _loading = false;
          _phoneInstalled = true;
          _answer = answer;
          _answerKind = 'phone';
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _aiError = '휴대폰 AI 실행 실패: $e';
          _answer = offlineSmartAnswer(widget.exam, q);
          _answerKind = 'fallback';
        });
      }
      return;
    }

    final remote =
        await CertiRemoteService.askBrief(widget.exam, q, model: _pcModel);
    if (!mounted) return;
    final ok = remote.ok;
    setState(() {
      _loading = false;
      _aiError = remote.error;
      _answer = ok ? remote.answer : offlineSmartAnswer(widget.exam, q);
      _answerKind = ok ? 'pc' : 'fallback';
      if (ok) {
        _health = AiHealth(
            serverReachable: true,
            aiConfigured: true,
            aiReady: true,
            model: _pcModel,
            message: 'PC Ollama AI 응답 정상');
      }
    });
    if (!ok) _checkPcHealth();
  }

  @override
  Widget build(BuildContext context) {
    final pcConnected = _health?.serverReachable == true;
    final pcConfigured = _health?.aiConfigured == true;
    final pcReady = _health?.aiReady == true;
    final badgeText = _phoneMode
        ? (_downloading
            ? '다운로드 중'
            : _phoneInstalled
                ? '폰 AI 준비'
                : '모델 필요')
        : (_checkingHealth
            ? '확인 중'
            : pcReady
                ? 'PC AI 연결'
                : pcConnected && pcConfigured
                    ? '모델 확인'
                    : pcConnected
                        ? 'Ollama 준비'
                        : 'PC 서버 꺼짐');
    final answerLabel = _answerKind == 'phone'
        ? '휴대폰 내장 AI 답변'
        : _answerKind == 'pc'
            ? 'PC 고성능 AI 답변'
            : '공식 데이터 기반 즉시 답변';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFD1CDC7))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.chat_bubble_outline_rounded,
              size: 18, color: Color(0xFF024AD8)),
          const SizedBox(width: 7),
          const Text('AI에게 추가 질문',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
          const Spacer(),
          _TinyBadge(text: badgeText),
        ]),
        const SizedBox(height: 6),
        Text(
          _phoneMode
              ? '휴대폰에서 AI를 직접 실행합니다. 최초 모델 다운로드 후에는 노트북·서버·Wi-Fi 없이도 사용할 수 있습니다.'
              : (pcReady
                  ? '$_pcModel 준비됨. 같은 Wi-Fi의 노트북 Ollama를 사용합니다.'
                  : (_health?.message ?? 'PC 고성능 AI 상태를 확인합니다.')),
          style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF696969),
              fontWeight: FontWeight.w600,
              height: 1.4),
        ),
        const SizedBox(height: 10),
        const Text('AI 실행 방식',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        Row(children: [
          _modeButton(
              phone: true,
              title: '휴대폰 단독',
              subtitle: Platform.isAndroid ? '노트북/서버 불필요' : 'Android 전용'),
          const SizedBox(width: 7),
          _modeButton(phone: false, title: 'PC 고성능', subtitle: '14B · 8B · 4B'),
        ]),
        const SizedBox(height: 12),
        if (_phoneMode) ...[
          Row(children: [
            _phoneModelButton(phoneAiHigh),
            const SizedBox(width: 7),
            _phoneModelButton(phoneAiFast),
          ]),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
                color: const Color(0xFFF8F6F3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8E2DA))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                _phoneInstalled
                    ? '${_phoneSpec.label} ${_phoneSpec.shortLabel} 설치됨 · 앱 내부 저장소에서 직접 실행'
                    : '${_phoneSpec.label} ${_phoneSpec.shortLabel} 모델을 최초 1회 Wi-Fi로 다운로드해야 합니다 (${_phoneSpec.downloadSize}).',
                style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF696969),
                    fontWeight: FontWeight.w700,
                    height: 1.4),
              ),
              if (_downloading) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                    value: _downloadProgress > 0 ? _downloadProgress : null,
                    minHeight: 5),
                const SizedBox(height: 5),
                Text('${(_downloadProgress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w800)),
              ],
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: (_loading || _downloading || _phoneInstalled)
                        ? null
                        : _downloadPhoneModel,
                    icon: const Icon(Icons.download_rounded, size: 17),
                    label: Text(_phoneInstalled ? '모델 설치됨' : 'Wi-Fi로 모델 다운로드'),
                  ),
                ),
                if (_phoneInstalled) ...[
                  const SizedBox(width: 7),
                  TextButton(
                      onPressed:
                          (_loading || _downloading) ? null : _deletePhoneModel,
                      child: const Text('삭제')),
                ],
              ]),
            ]),
          ),
          const SizedBox(height: 6),
          const Text(
              '권장: 갤럭시 A25에서는 1.7B Q4를 기본으로 사용하고, 메모리 부담이 크면 0.6B Q4_0로 전환하세요. 중단된 모델 다운로드는 다음 시도 때 이어받습니다.',
              style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF858585),
                  fontWeight: FontWeight.w600)),
        ] else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                color: const Color(0xFFF8F6F3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8E2DA))),
            child: Row(children: [
              const Icon(Icons.wifi_rounded,
                  size: 16, color: Color(0xFF024AD8)),
              const SizedBox(width: 7),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('PC AI 서버',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text(certiApiBaseUrl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF696969),
                            fontWeight: FontWeight.w600)),
                  ])),
              TextButton(
                  onPressed: _loading ? null : _editServerUrl,
                  child: const Text('변경')),
            ]),
          ),
          const SizedBox(height: 10),
          Row(children: [
            _pcModelButton(_pcModelOptions[0]),
            const SizedBox(width: 7),
            _pcModelButton(_pcModelOptions[1]),
            const SizedBox(width: 7),
            _pcModelButton(_pcModelOptions[2]),
          ]),
          const SizedBox(height: 6),
          const Text('PC 모드는 기존 Qwen3 14B/8B/4B Ollama를 사용합니다.',
              style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF858585),
                  fontWeight: FontWeight.w600)),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          maxLines: 2,
          minLines: 1,
          onSubmitted: (_) => _ask(),
          decoration: InputDecoration(
            hintText: '예: 시험 언제 봐? / 이 앱에는 어떤 기능이 있어?',
            suffixIcon: IconButton(
                onPressed: (_loading || _downloading) ? null : _ask,
                icon: const Icon(Icons.send_rounded)),
          ),
        ),
        if (_loading) ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(minHeight: 2),
          const SizedBox(height: 5),
          Text(
              _phoneMode
                  ? '휴대폰에서 AI 모델을 불러오고 답변을 생성하고 있습니다…'
                  : 'PC AI가 답변을 생성하고 있습니다…',
              style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF696969),
                  fontWeight: FontWeight.w600)),
        ],
        if (_aiError != null) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF1EA),
                borderRadius: BorderRadius.circular(14)),
            child: Text(_aiError!,
                style: const TextStyle(
                    fontSize: 10,
                    height: 1.45,
                    color: Color(0xFFCF4500),
                    fontWeight: FontWeight.w700)),
          ),
        ],
        if (_answer != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFFFCFBFA),
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(
                    _answerKind == 'fallback'
                        ? Icons.fact_check_outlined
                        : Icons.auto_awesome_rounded,
                    size: 15,
                    color: const Color(0xFF024AD8)),
                const SizedBox(width: 6),
                Text(answerLabel,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF024AD8))),
              ]),
              const SizedBox(height: 8),
              Text(_answer!,
                  style: const TextStyle(
                      fontSize: 12,
                      height: 1.55,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF696969))),
            ]),
          ),
        ],
      ]),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
    required this.acquired,
    required this.onToggleAcquired,
  });

  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;
  final Set<String> acquired;
  final ValueChanged<String> onToggleAcquired;

  @override
  Widget build(BuildContext context) {
    final favoriteExams =
        demoExams.where((e) => favorites.contains(e.id)).toList();
    favoriteExams.sort((a, b) {
      final aa = nextExamAction(a);
      final bb = nextExamAction(b);
      if (aa == null && bb == null) return a.name.compareTo(b.name);
      if (aa == null) return 1;
      if (bb == null) return -1;
      return aa.date.compareTo(bb.date);
    });
    final favoriteActions = allUpcomingExamActions()
        .where((a) => favorites.contains(a.exam.id))
        .toList();
    final alerts =
        favoriteActions.where((a) => a.days >= 0 && a.days <= 30).toList();
    final next = favoriteActions.isEmpty ? null : favoriteActions.first;

    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
        children: [
          const Text('MY',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                  color: Color(0xFF141413))),
          const SizedBox(height: 16),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () =>
                  showPlannerProfileSheet(context, favorites, acquired),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0xFFD1CDC7))),
                child: Row(children: [
                  const AppAssetThumb(
                      assetPath: 'assets/images/feature_profile.png',
                      width: 58,
                      height: 58,
                      borderRadius: 20),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('나의 자격증 플래너',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(
                          next == null
                              ? '관심 자격증을 추가해 준비 일정을 시작하세요'
                              : '다음 일정 · ${next.exam.name} ${next.label} ${next.dday}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xFF696969),
                              fontSize: 11,
                              height: 1.4,
                              fontWeight: FontWeight.w600),
                        ),
                      ])),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF696969)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(
                child: _MetricCard(
              icon: Icons.bookmark_rounded,
              label: '관심 자격증',
              value: '${favoriteExams.length}',
              color: const Color(0xFF024AD8),
              onTap: () =>
                  showFavoriteManager(context, favorites, onToggleFavorite),
            )),
            const SizedBox(width: 10),
            Expanded(
                child: _MetricCard(
              icon: Icons.notifications_active_rounded,
              label: '30일 내 알림',
              value: '${alerts.length}',
              color: const Color(0xFFCF4500),
              onTap: () => showUpcomingAlertsSheet(context, favorites),
            )),
            const SizedBox(width: 10),
            Expanded(
                child: _MetricCard(
              icon: Icons.check_circle_rounded,
              label: '취득 완료',
              value: '${acquired.length}',
              color: const Color(0xFFCF4500),
              onTap: () =>
                  showAcquiredManager(context, acquired, onToggleAcquired),
            )),
          ]),
          const SizedBox(height: 24),
          const _SectionTitle(
              title: '관심 자격증', subtitle: '저장한 자격증은 오늘 날짜 기준 다음 일정으로 자동 정렬돼요'),
          const SizedBox(height: 12),
          if (favoriteExams.isEmpty)
            const _NoSavedExam()
          else
            ...favoriteExams.map((exam) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ExamListTile(
                      exam: exam,
                      isFavorite: true,
                      onFavorite: () => onToggleFavorite(exam.id)),
                )),
          const SizedBox(height: 12),
          _SettingsGroup(favorites: favorites),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: const Color(0xFFD1CDC7))),
          child: Column(children: [
            Icon(icon, size: 19, color: color),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF696969),
                    fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }
}

class _NoSavedExam extends StatelessWidget {
  const _NoSavedExam();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1CDC7)),
      ),
      child: const Column(
        children: [
          AppAssetThumb(
            assetPath: 'assets/images/feature_profile.png',
            width: double.infinity,
            height: 120,
            borderRadius: 18,
          ),
          SizedBox(height: 14),
          Text(
            '아직 저장한 자격증이 없어요.',
            style: TextStyle(
                color: Color(0xFF696969), fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

void showPlannerProfileSheet(
    BuildContext context, Set<String> favorites, Set<String> acquired) {
  final actions = allUpcomingExamActions()
      .where((a) => favorites.contains(a.exam.id))
      .toList();
  final next = actions.isEmpty ? null : actions.first;
  final today = appToday();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('나의 준비 현황',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text('${today.year}년 ${today.month}월 ${today.day}일 기준',
                  style: const TextStyle(
                      color: Color(0xFF696969), fontWeight: FontWeight.w700)),
              const SizedBox(height: 18),
              const AppAssetThumb(
                  assetPath: 'assets/images/feature_profile.png',
                  width: double.infinity,
                  height: 150,
                  borderRadius: 22),
              const SizedBox(height: 16),
              _InfoStrip(
                  icon: Icons.bookmark_rounded,
                  text:
                      '관심 자격증 ${favorites.length}개 · 취득 완료 ${acquired.length}개'),
              const SizedBox(height: 8),
              _InfoStrip(
                  icon: Icons.event_available_rounded,
                  text: next == null
                      ? '등록된 다음 일정이 없습니다.'
                      : '다음 일정: ${next.exam.name} · ${next.label} ${shortDate(next.date)} (${next.dday})'),
            ]),
      ),
    ),
  );
}

void showFavoriteManager(BuildContext context, Set<String> favorites,
    ValueChanged<String> onToggleFavorite) {
  final items = demoExams.where((e) => favorites.contains(e.id)).toList()
    ..sort((a, b) {
      final aa = nextExamAction(a);
      final bb = nextExamAction(b);
      if (aa == null && bb == null) return a.name.compareTo(b.name);
      if (aa == null) return 1;
      if (bb == null) return -1;
      return aa.date.compareTo(bb.date);
    });
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          const Text('관심 자격증 관리',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('${items.length}개 저장됨',
              style: const TextStyle(
                  color: Color(0xFF696969), fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          if (items.isEmpty)
            const _InfoStrip(
                icon: Icons.bookmark_border_rounded,
                text: '탐색 화면에서 북마크를 눌러 관심 자격증을 추가하세요.'),
          ...items.map((exam) {
            final a = nextExamAction(exam);
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AppAssetThumb(
                  assetPath: categoryImageAsset(exam.category),
                  width: 46,
                  height: 46,
                  borderRadius: 14),
              title: Text(exam.name,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w900)),
              subtitle: Text(
                  a == null
                      ? '현재 회차 일정 종료'
                      : '${a.label} ${shortDate(a.date)} · ${a.dday}',
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF696969))),
              trailing: IconButton(
                  icon: const Icon(Icons.bookmark_remove_rounded,
                      color: Color(0xFFCF4500)),
                  onPressed: () {
                    onToggleFavorite(exam.id);
                    Navigator.pop(context);
                  }),
            );
          }),
        ],
      ),
    ),
  );
}

void showUpcomingAlertsSheet(BuildContext context, Set<String> favorites) {
  final actions = allUpcomingExamActions()
      .where(
          (a) => favorites.contains(a.exam.id) && a.days >= 0 && a.days <= 30)
      .toList();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('30일 내 예정 알림',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text('관심 자격증의 다음 행동 일정을 오늘 기준으로 계산합니다.',
                  style: TextStyle(
                      color: Color(0xFF696969),
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              if (actions.isEmpty)
                const _InfoStrip(
                    icon: Icons.notifications_none_rounded,
                    text: '앞으로 30일 안에 예정된 관심 일정이 없습니다.'),
              ...actions.take(12).map((a) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                        backgroundColor: a.color.withValues(alpha: 0.10),
                        child: Icon(a.icon, color: a.color, size: 19)),
                    title: Text(a.exam.name,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w900)),
                    subtitle: Text('${a.label} · ${shortDate(a.date)}',
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF696969))),
                    trailing: Text(a.dday,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: a.color)),
                  )),
            ]),
      ),
    ),
  );
}

void showAcquiredManager(BuildContext context, Set<String> acquired,
    ValueChanged<String> onToggleAcquired) {
  final names = demoExams
      .map((e) => _baseCertificateName(e.name))
      .where((e) => e.isNotEmpty)
      .toSet()
      .toList()
    ..sort();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      String query = '';
      return StatefulBuilder(builder: (context, setSheetState) {
        final filtered = names
            .where((n) => n.toLowerCase().contains(query.toLowerCase()))
            .take(80)
            .toList();
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.82,
          minChildSize: 0.5,
          maxChildSize: 0.94,
          builder: (context, controller) => ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
            children: [
              const Text('취득 자격증 관리',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              TextField(
                  onChanged: (v) => setSheetState(() => query = v),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: '취득한 자격증 검색')),
              const SizedBox(height: 12),
              ...filtered.map((name) {
                final checked = acquired.contains(name);
                return CheckboxListTile(
                  value: checked,
                  onChanged: (_) {
                    onToggleAcquired(name);
                    setSheetState(() {});
                  },
                  title: Text(name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w800)),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                );
              }),
            ],
          ),
        );
      });
    },
  );
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.favorites});

  final Set<String> favorites;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD1CDC7)),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            title: '알림 설정',
            subtitle: '접수 시작·마감·시험 전 알림',
            onTap: () => _simpleMessage(
                context, '알림 설정은 실제 서비스에서 푸시 알림 서버와 연결할 수 있습니다.'),
          ),
          const Divider(height: 1, indent: 54, color: Color(0xFFF3F0EE)),
          _SettingsTile(
            icon: Icons.cloud_sync_outlined,
            title: '데이터 동기화',
            subtitle: '공식 일정 업데이트 상태',
            trailing: const Text(
              '정상',
              style: TextStyle(
                  color: Color(0xFFCF4500),
                  fontWeight: FontWeight.w900,
                  fontSize: 11),
            ),
            onTap: () => _simpleMessage(context,
                '현재 앱에는 2026-08-16 기준 공식 고정 일정 101건 + 상시시험 6종이 내장되어 있습니다. 서버 연결 시 공식 출처 재검증 결과와 자동 동기화됩니다.'),
          ),
          const Divider(height: 1, indent: 54, color: Color(0xFFF3F0EE)),
          _SettingsTile(
            icon: Icons.route_rounded,
            title: '진로별 자격증 로드맵',
            subtitle: 'AI·데이터·IT·사무·전기 분야 추천 순서',
            onTap: () => showCareerRoadmapSheet(context),
          ),
          const Divider(height: 1, indent: 54, color: Color(0xFFF3F0EE)),
          _SettingsTile(
            icon: Icons.radar_rounded,
            title: '접수 위험 레이더',
            subtitle: '3·7·14일 안에 놓칠 접수 마감 자동 탐지',
            onTap: () => showDeadlineRadar(context),
          ),
          const Divider(height: 1, indent: 54, color: Color(0xFFF3F0EE)),
          _SettingsTile(
            icon: Icons.verified_user_rounded,
            title: '데이터 신뢰센터',
            subtitle: '공식 출처·검증 범위·데이터 수 확인',
            onTap: () => showTrustCenter(context),
          ),
          const Divider(height: 1, indent: 54, color: Color(0xFFF3F0EE)),
          _SettingsTile(
            icon: Icons.merge_type_rounded,
            title: '관심 시험 충돌 검사',
            subtitle: '저장한 시험끼리 7일 이내 일정·접수 겹침 탐지',
            onTap: () => showScheduleConflictSheet(context, favorites),
          ),
          const Divider(height: 1, indent: 54, color: Color(0xFFF3F0EE)),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'AI·개인정보 안내',
            subtitle: '출처 우선·로컬 AI 개인정보 보호',
            onTap: () => _showPrivacyDialog(context),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF024AD8)),
      title: Text(title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF696969),
            fontWeight: FontWeight.w600),
      ),
      trailing: trailing ??
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF696969)),
    );
  }
}

void showExamDetail(
  BuildContext context,
  Exam exam,
  bool isFavorite,
  VoidCallback onFavorite,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      var localFavorite = isFavorite;

      return StatefulBuilder(
        builder: (context, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.84,
            minChildSize: 0.58,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFCFBFA),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1CDC7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppAssetThumb(
                          assetPath: categoryImageAsset(exam.category),
                          width: 54,
                          height: 54,
                          borderRadius: 18,
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exam.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  height: 1.2,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                exam.organizer,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF696969),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            onFavorite();
                            setSheetState(
                              () => localFavorite = !localFavorite,
                            );
                          },
                          icon: Icon(
                            localFavorite
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: localFavorite
                                ? const Color(0xFF024AD8)
                                : const Color(0xFF696969),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _DetailSchedule(exam: exam),
                    const SizedBox(height: 12),
                    AppAssetThumb(
                      assetPath: categoryImageAsset(exam.category),
                      width: double.infinity,
                      height: 148,
                      borderRadius: 22,
                    ),
                    const SizedBox(height: 16),
                    _DetailBlock(
                      icon: Icons.auto_awesome_rounded,
                      title: 'AI 30초 요약',
                      child: Text(
                        exam.aiSummary,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailBlock(
                      icon: Icons.person_search_rounded,
                      title: '응시자격',
                      child: Text(
                        exam.eligibility,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.55,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailBlock(
                      icon: Icons.menu_book_rounded,
                      title: '시험과목',
                      child: Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: exam.subjects
                            .map(
                              (subject) => Chip(
                                label: Text(subject),
                                side: BorderSide.none,
                                backgroundColor: const Color(0xFFF3F0EE),
                                labelStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailBlock(
                      icon: Icons.fact_check_outlined,
                      title: '합격기준',
                      child: Text(
                        exam.passRule,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.55,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailBlock(
                      icon: Icons.verified_user_outlined,
                      title: '공식 출처',
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              exam.scheduleNote.isEmpty
                                  ? exam.officialSource
                                  : '${exam.officialSource} · ${exam.scheduleNote}',
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                _showSourceDialog(sheetContext, exam),
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailBlock(
                      icon: Icons.event_available_rounded,
                      title: '일정 내보내기',
                      child: Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: () => copyExamIcs(sheetContext, exam),
                              icon: const Icon(Icons.content_copy_rounded,
                                  size: 17),
                              label: const Text('ICS 복사'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: exam.sourceUrl));
                                if (sheetContext.mounted)
                                  _simpleMessage(
                                      sheetContext, '공식 URL을 복사했습니다.');
                              },
                              icon:
                                  const Icon(Icons.verified_rounded, size: 17),
                              label: const Text('출처 복사'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

class _DetailSchedule extends StatelessWidget {
  const _DetailSchedule({required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ScheduleBox(
            label: '접수 마감',
            value: shortDate(exam.applyEnd),
            color: const Color(0xFFCF4500),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ScheduleBox(
            label: '시험일',
            value: shortDate(exam.examDate),
            color: const Color(0xFF024AD8),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ScheduleBox(
            label: '발표일',
            value:
                exam.resultDateKnown ? shortDate(exam.resultDate) : '공식 공지 확인',
            color: const Color(0xFFCF4500),
          ),
        ),
      ],
    );
  }
}

class _ScheduleBox extends StatelessWidget {
  const _ScheduleBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 9, color: color, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1CDC7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: const Color(0xFF024AD8)),
              const SizedBox(width: 7),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

void _showNoticeCenter(BuildContext context) {
  final today = appToday();
  final actions = allUpcomingExamActions(today: today).take(4).toList();
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('알림 센터',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text('${today.year}년 ${today.month}월 ${today.day}일 기준 가까운 일정',
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF696969),
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            if (actions.isEmpty)
              const _NoticeTile(
                  icon: Icons.event_busy_rounded,
                  title: '현재 등록된 미래 일정이 없습니다.',
                  subtitle: '새 공식 일정이 동기화되면 여기에 표시됩니다.')
            else
              ...actions.map((a) => _NoticeTile(
                    icon: a.icon,
                    title: '${a.exam.name} · ${a.label} ${a.dday}',
                    subtitle: '${shortDate(a.date)} · ${a.exam.organizer}',
                  )),
          ],
        ),
      ),
    ),
  );
}

class _NoticeTile extends StatelessWidget {
  const _NoticeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0EE),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: const Color(0xFF024AD8)),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 11, color: Color(0xFF696969))),
    );
  }
}

class _SmartToolGrid extends StatelessWidget {
  const _SmartToolGrid({
    required this.favorites,
    required this.onToggleFavorite,
  });

  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.74,
      children: [
        _SmartToolCard(
          icon: Icons.explore_rounded,
          imageAsset: 'assets/images/feature_recommend.png',
          eyebrow: 'PERSONAL PICK',
          title: '스마트 추천',
          body: '목표·난이도·남은 일정으로 지금 도전할 자격증을 골라요.',
          accent: const Color(0xFF024AD8),
          onTap: () =>
              showRecommendationSheet(context, favorites, onToggleFavorite),
        ),
        _SmartToolCard(
          icon: Icons.compare_arrows_rounded,
          imageAsset: 'assets/images/feature_compare.png',
          eyebrow: 'COMPARE',
          title: '자격증 비교',
          body: '최대 3개를 골라 일정·난이도·과목을 한눈에 비교해요.',
          accent: const Color(0xFFCF4500),
          onTap: () => showCompareSheet(context),
        ),
        _SmartToolCard(
          icon: Icons.edit_calendar_rounded,
          imageAsset: 'assets/images/feature_planner.png',
          eyebrow: 'STUDY PLAN',
          title: '공부계획 생성',
          body: '시험일까지 남은 날과 과목을 기준으로 7일 계획을 만들어요.',
          accent: const Color(0xFF141413),
          onTap: () => showStudyPlannerSheet(context),
        ),
        _SmartToolCard(
          icon: Icons.all_inclusive_rounded,
          imageAsset: 'assets/images/feature_rolling.png',
          eyebrow: 'ROLLING',
          title: '상시시험 허브',
          body: '컴활·워드처럼 매일 접수 가능한 시험을 따로 관리해요.',
          accent: const Color(0xFF024AD8),
          onTap: () => showRollingExamHub(context),
        ),
      ],
    );
  }
}

class _SmartToolCard extends StatelessWidget {
  const _SmartToolCard({
    required this.icon,
    required this.imageAsset,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String imageAsset;
  final String eyebrow;
  final String title;
  final String body;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFD1CDC7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(icon, color: accent, size: 19),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_outward_rounded,
                      size: 17, color: Color(0xFF696969)),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: AppAssetThumb(
                  assetPath: imageAsset,
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                eyebrow,
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w900,
                  color: accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(
                body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 9.5,
                    height: 1.35,
                    color: Color(0xFF696969),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RollingSearchBanner extends StatelessWidget {
  const _RollingSearchBanner({required this.count, required this.query});

  final int count;
  final String query;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF141413),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => showRollingExamHub(context, initialQuery: query),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const AppAssetThumb(
                  assetPath: 'assets/images/feature_rolling.png',
                  width: 58,
                  height: 58,
                  borderRadius: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '상시시험 $count종도 찾았어요',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '고정 날짜 대신 지역 시험장별 접수 가능일을 확인하는 시험입니다.',
                      style: TextStyle(
                          color: Color(0xFFD1CDC7),
                          fontSize: 10,
                          height: 1.4,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

String _baseCertificateName(String name) {
  var value = name.trim();
  value = value.replaceAll(RegExp(r'\s*제\d+회.*$'), '');
  value = value.replaceAll(RegExp(r'\s+\d{4}회.*$'), '');
  value = value.replaceAll(RegExp(r'\s+26\d{2}회.*$'), '');
  value = value.replaceAll(RegExp(r'\s+26\d{2}.*$'), '');
  value = value.replaceAll(RegExp(r'\s+제\d+회.*$'), '');
  return value.trim();
}

List<Exam> _nextUniqueExams({int limit = 60}) {
  final now = appToday();
  final sorted = demoExams
      .where((e) => !DateUtils.dateOnly(e.examDate).isBefore(now))
      .toList()
    ..sort((a, b) => a.examDate.compareTo(b.examDate));
  final seen = <String>{};
  final result = <Exam>[];
  for (final exam in sorted) {
    final key = _baseCertificateName(exam.name).toLowerCase();
    if (seen.add(key)) result.add(exam);
    if (result.length >= limit) break;
  }
  return result;
}

void showRecommendationSheet(
  BuildContext context,
  Set<String> favorites,
  ValueChanged<String> onToggleFavorite,
) {
  String goal = '취업';
  double maxDifficulty = 4;
  const goalCategory = <String, String?>{
    '취업': null,
    'AI': 'AI',
    '데이터': '데이터',
    'IT': 'IT·개발',
    '사무': '사무·OA',
    '전기': '전기·전자',
  };

  List<Exam> ranked() {
    final now = appToday();
    final desired = goalCategory[goal];
    final scored = _nextUniqueExams(limit: 80).map((exam) {
      var score = 0.0;
      if (desired == null || exam.category == desired)
        score += desired == null ? 8 : 35;
      final applyStart = DateUtils.dateOnly(exam.applyStart);
      final applyEnd = DateUtils.dateOnly(exam.applyEnd);
      final examDate = DateUtils.dateOnly(exam.examDate);
      if (!now.isBefore(applyStart) && !now.isAfter(applyEnd)) score += 24;
      if (now.isBefore(applyStart)) score += 15;
      final days = examDate.difference(now).inDays;
      if (days >= 14 && days <= 120) score += 15;
      if (exam.difficulty <= maxDifficulty.round()) score += 18;
      if (favorites.contains(exam.id)) score += 4;
      if (goal == '취업' &&
          (exam.name.contains('기사') ||
              exam.name.contains('SQLD') ||
              exam.name.contains('TOEIC'))) score += 5;
      return MapEntry(exam, score);
    }).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return scored.take(5).map((e) => e.key).toList();
  }

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setSheetState) {
        final picks = ranked();
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.62,
          maxChildSize: 0.96,
          expand: false,
          builder: (context, controller) => Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFCFBFA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                const _SheetHandle(),
                const SizedBox(height: 18),
                const _SheetHeadline(
                  eyebrow: 'SMART MATCH',
                  title: '지금 도전하기 좋은 자격증',
                  subtitle: '분야, 난이도, 접수 상태와 시험일까지 남은 시간을 함께 계산합니다.',
                ),
                const SizedBox(height: 18),
                const Text('목표',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: goalCategory.keys.map((item) {
                    final selected = item == goal;
                    return ChoiceChip(
                      selected: selected,
                      showCheckmark: false,
                      label: Text(item),
                      onSelected: (_) => setSheetState(() => goal = item),
                      selectedColor: const Color(0xFF024AD8),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFD1CDC7)),
                      labelStyle: TextStyle(
                          color:
                              selected ? Colors.white : const Color(0xFF696969),
                          fontWeight: FontWeight.w800),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(
                        child: Text('감당 가능한 난이도',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w900))),
                    Text('${maxDifficulty.round()} / 5',
                        style: const TextStyle(
                            color: Color(0xFF024AD8),
                            fontWeight: FontWeight.w900)),
                  ],
                ),
                Slider(
                  value: maxDifficulty,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (v) => setSheetState(() => maxDifficulty = v),
                ),
                const SizedBox(height: 8),
                ...picks.asMap().entries.map((entry) {
                  final rank = entry.key + 1;
                  final exam = entry.value;
                  final d = daysUntil(exam.applyEnd);
                  final isFavorite = favorites.contains(exam.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () =>
                            showExamDetail(sheetContext, exam, isFavorite, () {
                          onToggleFavorite(exam.id);
                          setSheetState(() {});
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFD1CDC7)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: rank == 1
                                        ? const Color(0xFF024AD8)
                                        : const Color(0xFFF3F0EE),
                                    borderRadius: BorderRadius.circular(11)),
                                child: Text('$rank',
                                    style: TextStyle(
                                        color: rank == 1
                                            ? Colors.white
                                            : const Color(0xFF141413),
                                        fontWeight: FontWeight.w900)),
                              ),
                              const SizedBox(width: 11),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(exam.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900)),
                                    const SizedBox(height: 4),
                                    Text(
                                        '${exam.category} · 난이도 ${exam.difficulty}/5 · ${d >= 0 ? '접수마감 D-$d' : '시험 ${shortDate(exam.examDate)}'}',
                                        style: const TextStyle(
                                            fontSize: 9.5,
                                            color: Color(0xFF696969),
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  onToggleFavorite(exam.id);
                                  setSheetState(() {});
                                },
                                icon: Icon(
                                    isFavorite
                                        ? Icons.bookmark_rounded
                                        : Icons.bookmark_border_rounded,
                                    color: isFavorite
                                        ? const Color(0xFF024AD8)
                                        : const Color(0xFF696969)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                const _InfoStrip(
                  icon: Icons.psychology_alt_rounded,
                  text:
                      '이 추천은 오프라인에서도 작동하는 규칙 기반 추천입니다. 서버 연결 시 공식 데이터 기반 AI 추천으로 확장할 수 있습니다.',
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

void showCompareSheet(BuildContext context) {
  final selected = <String>{};
  String query = '';
  final candidates = _nextUniqueExams(limit: 70);

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setSheetState) {
        final normalized = query.trim().toLowerCase();
        final filtered = candidates
            .where((e) =>
                normalized.isEmpty ||
                '${e.name} ${e.category} ${e.organizer}'
                    .toLowerCase()
                    .contains(normalized))
            .take(24)
            .toList();
        final selectedExams =
            candidates.where((e) => selected.contains(e.id)).toList();
        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.65,
          maxChildSize: 0.97,
          expand: false,
          builder: (context, controller) => Container(
            decoration: const BoxDecoration(
                color: Color(0xFFFCFBFA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 34),
              children: [
                const _SheetHandle(),
                const SizedBox(height: 18),
                const _SheetHeadline(
                  eyebrow: 'SIDE BY SIDE',
                  title: '자격증 최대 3개 비교',
                  subtitle: '시험 일정, 난이도, 과목 수와 공식 주관처를 같은 기준으로 비교합니다.',
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (v) => setSheetState(() => query = v),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: '비교할 자격증 검색'),
                ),
                const SizedBox(height: 12),
                if (selectedExams.isNotEmpty) ...[
                  Row(
                    children: [
                      Text('${selectedExams.length}/3 선택',
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      const Spacer(),
                      TextButton(
                          onPressed: () => setSheetState(selected.clear),
                          child: const Text('초기화')),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: selectedExams
                          .map((exam) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _CompareCard(exam: exam),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
                const Text('후보 선택',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                ...filtered.map((exam) {
                  final checked = selected.contains(exam.id);
                  final disabled = !checked && selected.length >= 3;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD1CDC7))),
                    child: CheckboxListTile(
                      value: checked,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: disabled
                          ? null
                          : (_) => setSheetState(() {
                                if (checked)
                                  selected.remove(exam.id);
                                else
                                  selected.add(exam.id);
                              }),
                      title: Text(exam.name,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w900)),
                      subtitle: Text(
                          '${exam.category} · 시험 ${shortDate(exam.examDate)}',
                          style: const TextStyle(
                              fontSize: 9.5, color: Color(0xFF696969))),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _CompareCard extends StatelessWidget {
  const _CompareCard({required this.exam});
  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 205,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141413),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exam.badge,
              style: const TextStyle(
                  color: Color(0xFFCF4500),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8)),
          const SizedBox(height: 6),
          Text(exam.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.25,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          _CompareMetric(label: '접수 마감', value: shortDate(exam.applyEnd)),
          _CompareMetric(label: '시험일', value: shortDate(exam.examDate)),
          _CompareMetric(label: '난이도', value: '${exam.difficulty}/5'),
          _CompareMetric(label: '과목', value: '${exam.subjects.length}개'),
        ],
      ),
    );
  }
}

class _CompareMetric extends StatelessWidget {
  const _CompareMetric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: Color(0xFFD1CDC7),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600))),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900)),
        ]),
      );
}

void showStudyPlannerSheet(BuildContext context) {
  final candidates = _nextUniqueExams(limit: 45);
  if (candidates.isEmpty) {
    _simpleMessage(context, '앞으로 예정된 시험을 찾지 못했습니다.');
    return;
  }
  Exam selected = candidates.first;
  double weeklyHours = 8;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setSheetState) {
        final plan = _buildSevenDayPlan(selected, weeklyHours.round());
        return DraggableScrollableSheet(
          initialChildSize: 0.90,
          minChildSize: 0.65,
          maxChildSize: 0.97,
          expand: false,
          builder: (context, controller) => Container(
            decoration: const BoxDecoration(
                color: Color(0xFFFCFBFA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 34),
              children: [
                const _SheetHandle(),
                const SizedBox(height: 18),
                const _SheetHeadline(
                  eyebrow: '7-DAY SPRINT',
                  title: '시험 준비 플래너',
                  subtitle: '시험일까지 남은 기간과 과목을 이용해 바로 실행 가능한 7일 공부계획을 만듭니다.',
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<String>(
                  initialValue: selected.id,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: '준비할 시험'),
                  items: candidates
                      .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (id) {
                    if (id == null) return;
                    setSheetState(() =>
                        selected = candidates.firstWhere((e) => e.id == id));
                  },
                ),
                const SizedBox(height: 14),
                Row(children: [
                  const Expanded(
                      child: Text('주간 공부 가능 시간',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w900))),
                  Text('${weeklyHours.round()}시간',
                      style: const TextStyle(
                          color: Color(0xFF024AD8),
                          fontWeight: FontWeight.w900)),
                ]),
                Slider(
                    value: weeklyHours,
                    min: 3,
                    max: 21,
                    divisions: 18,
                    onChanged: (v) => setSheetState(() => weeklyHours = v)),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: const Color(0xFF141413),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    const Icon(Icons.timer_outlined, color: Color(0xFFCF4500)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(
                            '${selected.name}\n시험 ${shortDate(selected.examDate)} · D-${math.max(0, daysUntil(selected.examDate))}',
                            style: const TextStyle(
                                color: Colors.white,
                                height: 1.45,
                                fontSize: 11,
                                fontWeight: FontWeight.w800))),
                  ]),
                ),
                const SizedBox(height: 14),
                ...plan.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: const Color(0xFFD1CDC7))),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 34,
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: index == 0
                                        ? const Color(0xFF024AD8)
                                        : const Color(0xFFF3F0EE),
                                    borderRadius: BorderRadius.circular(11)),
                                child: Text('D${index + 1}',
                                    style: TextStyle(
                                        color: index == 0
                                            ? Colors.white
                                            : const Color(0xFF141413),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900))),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(item.$1,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 3),
                                  Text(item.$2,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          height: 1.45,
                                          color: Color(0xFF696969),
                                          fontWeight: FontWeight.w600)),
                                ])),
                          ]),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                FilledButton.icon(
                  onPressed: () async {
                    final text =
                        _studyPlanAsText(selected, weeklyHours.round(), plan);
                    await Clipboard.setData(ClipboardData(text: text));
                    if (sheetContext.mounted)
                      _simpleMessage(sheetContext, '7일 공부계획을 복사했습니다.');
                  },
                  icon: const Icon(Icons.copy_all_rounded),
                  label: const Text('공부계획 복사'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

List<(String, String)> _buildSevenDayPlan(Exam exam, int weeklyHours) {
  final subjects =
      exam.subjects.isEmpty ? <String>['공식 출제기준 확인'] : exam.subjects;
  final minutesPerDay = math.max(25, (weeklyHours * 60 / 7).round());
  final daysLeft = math.max(1, daysUntil(exam.examDate));
  return List.generate(7, (index) {
    final subject = subjects[index % subjects.length];
    final isReview = index == 5;
    final isMock = index == 6;
    final title = isMock
        ? '실전 점검 · 오답 정리'
        : isReview
            ? '누적 복습 · 약점 보완'
            : subject;
    final detail = isMock
        ? '${math.max(30, minutesPerDay - 10)}분 실전 문제 + 10분 오답 기록. 시험장·준비물도 함께 확인하세요.'
        : isReview
            ? '${minutesPerDay}분 동안 1~5일 학습내용을 빠르게 회독하고 틀린 부분만 재학습하세요.'
            : '${minutesPerDay}분 집중 학습 · 핵심개념 → 기출/예제 → 5분 복습 순서. 현재 시험까지 약 $daysLeft일 남았습니다.';
    return (title, detail);
  });
}

String _studyPlanAsText(
    Exam exam, int weeklyHours, List<(String, String)> plan) {
  final b = StringBuffer(
      'CERTI:ON 7일 공부계획\n${exam.name}\n시험일: ${exam.examDate.year}-${exam.examDate.month.toString().padLeft(2, '0')}-${exam.examDate.day.toString().padLeft(2, '0')} · 주간 ${weeklyHours}시간\n\n');
  for (var i = 0; i < plan.length; i++) {
    b.writeln('${i + 1}일차 | ${plan[i].$1}\n${plan[i].$2}\n');
  }
  b.writeln('공식 출처: ${exam.sourceUrl}');
  return b.toString();
}

void showRollingExamHub(BuildContext context, {String initialQuery = ''}) {
  String query = initialQuery;
  final searchController = TextEditingController(text: initialQuery);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setSheetState) {
        final normalized = query.trim().toLowerCase();
        final filtered = rollingExams
            .where((e) =>
                normalized.isEmpty ||
                '${e.name} ${e.category} ${e.organizer}'
                    .toLowerCase()
                    .contains(normalized))
            .toList();
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.58,
          maxChildSize: 0.96,
          expand: false,
          builder: (context, controller) => Container(
            decoration: const BoxDecoration(
                color: Color(0xFFFCFBFA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 34),
              children: [
                const _SheetHandle(),
                const SizedBox(height: 18),
                const _SheetHeadline(
                  eyebrow: 'ALWAYS OPEN',
                  title: '상시시험 허브',
                  subtitle: '고정된 전국 시험일이 아니라 지역 시험장별로 날짜를 선택하는 시험을 정확히 분리했습니다.',
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: searchController,
                  onChanged: (v) => setSheetState(() => query = v),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: '컴활, 워드, 전산회계운용사...'),
                ),
                const SizedBox(height: 12),
                const _InfoStrip(
                    icon: Icons.info_outline_rounded,
                    text:
                        '상시시험은 “앞으로 6개월의 특정 시험일”을 임의 생성하지 않습니다. 접수는 공식 시험장 가용일을 기준으로 확인해야 합니다.'),
                const SizedBox(height: 12),
                if (rollingExams.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                        child: Text('상시시험 데이터를 불러오는 중입니다.',
                            style: TextStyle(color: Color(0xFF696969)))),
                  )
                else if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                        child: Text('검색 결과가 없습니다.',
                            style: TextStyle(color: Color(0xFF696969)))),
                  )
                else
                  ...filtered.map((exam) => _RollingExamCard(exam: exam)),
              ],
            ),
          ),
        );
      },
    ),
  ).whenComplete(searchController.dispose);
}

class _RollingExamCard extends StatelessWidget {
  const _RollingExamCard({required this.exam});
  final RollingExam exam;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD1CDC7))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                  color: const Color(0xFF141413),
                  borderRadius: BorderRadius.circular(999)),
              child: Text(exam.badge,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900))),
          const Spacer(),
          ...List.generate(
              5,
              (i) => Icon(
                  i < exam.difficulty ? Icons.circle : Icons.circle_outlined,
                  size: 7,
                  color: i < exam.difficulty
                      ? const Color(0xFFCF4500)
                      : const Color(0xFFD1CDC7))),
        ]),
        const SizedBox(height: 9),
        Text(exam.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(exam.benefit,
            style: const TextStyle(
                fontSize: 10,
                height: 1.45,
                color: Color(0xFF696969),
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _RollingRow(icon: Icons.how_to_reg_rounded, text: exam.schedule),
        _RollingRow(icon: Icons.fact_check_outlined, text: exam.result),
        _RollingRow(icon: Icons.person_search_rounded, text: exam.eligibility),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: exam.sourceUrl));
              if (context.mounted)
                _simpleMessage(context, '공식 시험안내 URL을 복사했습니다.');
            },
            icon: const Icon(Icons.verified_rounded, size: 16),
            label: const Text('공식 URL 복사'),
          ),
        ),
      ]),
    );
  }
}

class _RollingRow extends StatelessWidget {
  const _RollingRow({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 15, color: const Color(0xFF024AD8)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 10, height: 1.4, fontWeight: FontWeight.w700))),
        ]),
      );
}

void showTrustCenter(BuildContext context) {
  final allowed = <String>[
    'q-net.or.kr',
    'data.go.kr',
    'dataq.or.kr',
    'historyexam.go.kr',
    'exam.toeic.co.kr',
    'license.kpc.or.kr',
    'ihd.or.kr',
    'license.korcham.net',
  ];
  bool official(String url) {
    final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
    return allowed.any((d) => host == d || host.endsWith('.$d'));
  }

  final verified = demoExams.where((e) => official(e.sourceUrl)).length;
  final uniqueCerts = demoExams
          .map((e) => _baseCertificateName(e.name).toLowerCase())
          .toSet()
          .length +
      rollingExams.length;
  final byBadge = <String, int>{};
  for (final exam in demoExams) {
    byBadge.update(exam.badge, (v) => v + 1, ifAbsent: () => 1);
  }
  final topSources = byBadge.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final updated = localSnapshotUpdatedAt;
  final updatedText = updated == null
      ? '앱 번들 기준'
      : '${updated.year}.${updated.month}.${updated.day}';

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.55,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(
            color: Color(0xFFFCFBFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 34),
          children: [
            const _SheetHandle(),
            const SizedBox(height: 18),
            const _SheetHeadline(
              eyebrow: 'TRUST CENTER',
              title: '데이터를 믿어도 되는 이유',
              subtitle: '일정 수보다 더 중요한 것은 “어디에서 가져왔고, 확인 가능한가”입니다.',
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                  child: _TrustMetric(
                      value: '${demoExams.length}',
                      label: '고정 일정',
                      accent: const Color(0xFF024AD8))),
              const SizedBox(width: 8),
              Expanded(
                  child: _TrustMetric(
                      value: '${rollingExams.length}',
                      label: '상시시험',
                      accent: const Color(0xFFCF4500))),
              const SizedBox(width: 8),
              Expanded(
                  child: _TrustMetric(
                      value: '$uniqueCerts+',
                      label: '자격/시험군',
                      accent: const Color(0xFF141413))),
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                  color: const Color(0xFF141413),
                  borderRadius: BorderRadius.circular(21)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.verified_user_rounded,
                          color: Color(0xFFCF4500)),
                      const SizedBox(width: 9),
                      Text('$verified / ${demoExams.length} 고정 일정이 허용된 공식 도메인',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 12)),
                    ]),
                    const SizedBox(height: 8),
                    Text(
                        '스냅샷 갱신: $updatedText · ${certiApiBaseUrl.isEmpty && certiDataUrl.isEmpty ? '오프라인 안전모드' : '원격 동기화 연결'}',
                        style: const TextStyle(
                            color: Color(0xFFD1CDC7),
                            fontSize: 10,
                            height: 1.45)),
                  ]),
            ),
            const SizedBox(height: 16),
            const Text('데이터 구성',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: topSources
                  .take(10)
                  .map((e) => Chip(
                      label: Text('${e.key} ${e.value}'),
                      side: const BorderSide(color: Color(0xFFD1CDC7)),
                      backgroundColor: Colors.white,
                      labelStyle: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w800)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const _InfoStrip(
                icon: Icons.rule_rounded,
                text:
                    '검증 원칙: 공식 공개일정만 저장 · 미발표 날짜는 추측 금지 · 상시시험은 고정일로 변환하지 않음 · AI 답변보다 공식 원문을 우선.'),
            const SizedBox(height: 10),
            const _InfoStrip(
                icon: Icons.cloud_sync_rounded,
                text:
                    '실서비스에서는 백엔드가 공식 도메인만 허용한 웹 검색/공공 API로 갱신하고, 앱은 최신 JSON을 받아오며 실패하면 번들 데이터로 복귀합니다.'),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () async {
                final audit =
                    'CERTI:ON DATA AUDIT\n고정 일정: ${demoExams.length}\n상시시험: ${rollingExams.length}\n공식 도메인 검증: $verified/${demoExams.length}\n스냅샷: $updatedText\n정책: official-only, no guessed dates';
                await Clipboard.setData(ClipboardData(text: audit));
                if (sheetContext.mounted)
                  _simpleMessage(sheetContext, '데이터 감사 요약을 복사했습니다.');
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('검증 요약 복사'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _TrustMetric extends StatelessWidget {
  const _TrustMetric(
      {required this.value, required this.label, required this.accent});
  final String value;
  final String label;
  final Color accent;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD1CDC7))),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: accent)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF696969),
                  fontWeight: FontWeight.w700)),
        ]),
      );
}

RollingExam? _findRollingExam(String keyword) {
  for (final exam in rollingExams) {
    if (exam.name.contains(keyword)) return exam;
  }
  return null;
}

void showCareerRoadmapSheet(BuildContext context) {
  String track = 'AI';
  const routes = <String, List<String>>{
    'AI': ['AI상식', '프롬프트엔지니어 2급', 'AI 프로그래밍 2급', 'AI 서비스 기획 전문가'],
    '데이터': ['SQLD', 'ADsP', '빅데이터분석기사', 'SQLP'],
    'IT': ['리눅스마스터 2급', '정보처리기능사', '정보처리기사', '리눅스마스터 1급'],
    '사무': ['워드프로세서', '컴퓨터활용능력 2급', 'ITQ', '컴퓨터활용능력 1급'],
    '전기': ['전기기능사', '전자기기기능사', '전기기사', '전기공사기사'],
  };

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setSheetState) {
        final steps = routes[track]!;
        return DraggableScrollableSheet(
          initialChildSize: 0.80,
          minChildSize: 0.55,
          maxChildSize: 0.93,
          expand: false,
          builder: (context, controller) => Container(
            decoration: const BoxDecoration(
                color: Color(0xFFFCFBFA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 34),
              children: [
                const _SheetHandle(),
                const SizedBox(height: 18),
                const _SheetHeadline(
                  eyebrow: 'CAREER ROADMAP',
                  title: '무엇부터 따야 할지 순서까지',
                  subtitle: '입문 → 실무 → 심화 흐름을 한 번에 보여주고, 앱의 다음 공식 일정과 연결합니다.',
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: routes.keys.map((item) {
                    final selected = item == track;
                    return ChoiceChip(
                        selected: selected,
                        showCheckmark: false,
                        label: Text(item),
                        onSelected: (_) => setSheetState(() => track = item),
                        selectedColor: const Color(0xFF024AD8),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : const Color(0xFF696969),
                            fontWeight: FontWeight.w800));
                  }).toList(),
                ),
                const SizedBox(height: 18),
                ...steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final keyword = entry.value;
                  final fixed = _findNextExam(keyword);
                  final rolling = _findRollingExam(keyword);
                  final scheduleText = fixed != null
                      ? '다음 시험 ${shortDate(fixed.examDate)} · 접수 ${shortDate(fixed.applyStart)}~${shortDate(fixed.applyEnd)}'
                      : rolling != null
                          ? '상시접수 · 지역 시험장 일정 선택'
                          : '다음 공식 일정 발표 대기';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [
                            Container(
                                width: 34,
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: index == 0
                                        ? const Color(0xFF024AD8)
                                        : const Color(0xFF141413),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text('${index + 1}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900))),
                            if (index < steps.length - 1)
                              Container(
                                  width: 2,
                                  height: 42,
                                  color: const Color(0xFFD1CDC7)),
                          ]),
                          const SizedBox(width: 11),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17),
                                border:
                                    Border.all(color: const Color(0xFFD1CDC7))),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(keyword,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 4),
                                  Text(scheduleText,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF696969),
                                          height: 1.4,
                                          fontWeight: FontWeight.w600)),
                                ]),
                          )),
                        ]),
                  );
                }),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                        text:
                            'CERTI:ON $track 로드맵\n${steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}'));
                    if (sheetContext.mounted)
                      _simpleMessage(sheetContext, '$track 로드맵을 복사했습니다.');
                  },
                  icon: const Icon(Icons.copy_all_rounded),
                  label: const Text('로드맵 복사'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Exam? _findNextExam(String keyword) {
  final now = appToday();
  final matches = demoExams
      .where((e) =>
          e.name.contains(keyword) &&
          !DateUtils.dateOnly(e.examDate).isBefore(now))
      .toList()
    ..sort((a, b) => a.examDate.compareTo(b.examDate));
  return matches.isEmpty ? null : matches.first;
}

void showScheduleConflictSheet(BuildContext context, Set<String> favorites) {
  final saved = demoExams
      .where((e) => favorites.contains(e.id) && nextExamAction(e) != null)
      .toList()
    ..sort((a, b) => a.examDate.compareTo(b.examDate));
  final conflicts = <(Exam, Exam, String)>[];
  for (var i = 0; i < saved.length; i++) {
    for (var j = i + 1; j < saved.length; j++) {
      final a = saved[i];
      final b = saved[j];
      final examGap = DateUtils.dateOnly(a.examDate)
          .difference(DateUtils.dateOnly(b.examDate))
          .inDays
          .abs();
      final applyOverlap = !a.applyEnd.isBefore(b.applyStart) &&
          !b.applyEnd.isBefore(a.applyStart);
      if (examGap <= 7 || applyOverlap) {
        final reasons = <String>[];
        if (examGap <= 7) reasons.add('시험일 $examGap일 차이');
        if (applyOverlap) reasons.add('접수기간 겹침');
        conflicts.add((a, b, reasons.join(' · ')));
      }
    }
  }

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.90,
      expand: false,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(
            color: Color(0xFFFCFBFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 34),
          children: [
            const _SheetHandle(),
            const SizedBox(height: 18),
            const _SheetHeadline(
              eyebrow: 'CONFLICT CHECK',
              title: '관심 시험 일정 충돌 검사',
              subtitle: '저장한 시험 중 시험일이 7일 안으로 붙어 있거나 접수기간이 겹치는 조합을 찾습니다.',
            ),
            const SizedBox(height: 16),
            if (saved.length < 2)
              const _InfoStrip(
                  icon: Icons.bookmark_add_outlined,
                  text: '관심 자격증을 2개 이상 저장하면 일정 충돌을 자동으로 비교합니다.')
            else if (conflicts.isEmpty)
              const _InfoStrip(
                  icon: Icons.check_circle_outline_rounded,
                  text: '현재 저장한 관심 시험 사이에 7일 이내 시험 충돌이나 접수기간 겹침이 없습니다.')
            else ...[
              Text('${conflicts.length}개 충돌 가능성',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFCF4500))),
              const SizedBox(height: 9),
              ...conflicts.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFD1CDC7))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.$3,
                              style: const TextStyle(
                                  color: Color(0xFFCF4500),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 7),
                          Text(item.$1.name,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w900)),
                          Text(
                              '시험 ${shortDate(item.$1.examDate)} · 접수마감 ${shortDate(item.$1.applyEnd)}',
                              style: const TextStyle(
                                  fontSize: 9.5,
                                  color: Color(0xFF696969),
                                  height: 1.4)),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              child: Icon(Icons.swap_vert_rounded,
                                  size: 17, color: Color(0xFF024AD8))),
                          Text(item.$2.name,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w900)),
                          Text(
                              '시험 ${shortDate(item.$2.examDate)} · 접수마감 ${shortDate(item.$2.applyEnd)}',
                              style: const TextStyle(
                                  fontSize: 9.5,
                                  color: Color(0xFF696969),
                                  height: 1.4)),
                        ]),
                  )),
            ],
          ],
        ),
      ),
    ),
  );
}

void showDeadlineRadar(BuildContext context) {
  final now = appToday();
  final items = demoExams.where((exam) {
    final end = DateUtils.dateOnly(exam.applyEnd);
    final start = DateUtils.dateOnly(exam.applyStart);
    final d = end.difference(now).inDays;
    return d >= 0 && d <= 14 && !now.isBefore(start);
  }).toList()
    ..sort((a, b) => a.applyEnd.compareTo(b.applyEnd));
  final coming = demoExams.where((exam) {
    final start = DateUtils.dateOnly(exam.applyStart);
    final d = start.difference(now).inDays;
    return d > 0 && d <= 14;
  }).toList()
    ..sort((a, b) => a.applyStart.compareTo(b.applyStart));

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => DraggableScrollableSheet(
      initialChildSize: 0.80,
      minChildSize: 0.52,
      maxChildSize: 0.93,
      expand: false,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(
            color: Color(0xFFFCFBFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 34),
          children: [
            const _SheetHandle(),
            const SizedBox(height: 18),
            const _SheetHeadline(
              eyebrow: 'DEADLINE RADAR',
              title: '놓치기 쉬운 접수만 먼저',
              subtitle: '현재 접수 중이면서 14일 안에 끝나는 시험과 곧 열릴 접수를 자동으로 찾습니다.',
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const _InfoStrip(
                  icon: Icons.check_circle_outline_rounded,
                  text: '현재 14일 안에 마감되는 접수는 없습니다.')
            else ...[
              const Text('접수 마감 임박',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              ...items.take(12).map((exam) => _DeadlineTile(
                  exam: exam,
                  days: daysUntil(exam.applyEnd),
                  isOpening: false)),
            ],
            if (coming.isNotEmpty) ...[
              const SizedBox(height: 18),
              const Text('14일 안에 접수 시작',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              ...coming.take(10).map((exam) => _DeadlineTile(
                  exam: exam,
                  days: daysUntil(exam.applyStart),
                  isOpening: true)),
            ],
          ],
        ),
      ),
    ),
  );
}

class _DeadlineTile extends StatelessWidget {
  const _DeadlineTile(
      {required this.exam, required this.days, required this.isOpening});
  final Exam exam;
  final int days;
  final bool isOpening;
  @override
  Widget build(BuildContext context) {
    final urgent = days <= 3;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
              color:
                  urgent ? const Color(0xFFCF4500) : const Color(0xFFD1CDC7))),
      child: Row(children: [
        Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color:
                    urgent ? const Color(0xFFCF4500) : const Color(0xFF024AD8),
                borderRadius: BorderRadius.circular(14)),
            child: Text('D-$days',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900))),
        const SizedBox(width: 11),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(exam.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(
              isOpening
                  ? '접수 시작 ${shortDate(exam.applyStart)}'
                  : '접수 마감 ${shortDate(exam.applyEnd)} · 시험 ${shortDate(exam.examDate)}',
              style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF696969),
                  fontWeight: FontWeight.w700)),
        ])),
        IconButton(
            onPressed: () => _showSourceDialog(context, exam),
            icon: const Icon(Icons.verified_outlined,
                color: Color(0xFF024AD8), size: 19)),
      ]),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
                color: const Color(0xFFD1CDC7),
                borderRadius: BorderRadius.circular(999))),
      );
}

class _SheetHeadline extends StatelessWidget {
  const _SheetHeadline(
      {required this.eyebrow, required this.title, required this.subtitle});
  final String eyebrow;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                  color: Color(0xFFCF4500), shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(eyebrow,
              style: const TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF024AD8))),
        ]),
        const SizedBox(height: 7),
        Text(title,
            style: const TextStyle(
                fontSize: 23,
                height: 1.2,
                letterSpacing: -0.6,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        Text(subtitle,
            style: const TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Color(0xFF696969),
                fontWeight: FontWeight.w600)),
      ]);
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: const Color(0xFFF3F0EE),
            borderRadius: BorderRadius.circular(16)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 18, color: const Color(0xFF024AD8)),
          const SizedBox(width: 9),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 10,
                      height: 1.5,
                      color: Color(0xFF696969),
                      fontWeight: FontWeight.w700))),
        ]),
      );
}

Future<void> copyExamIcs(BuildContext context, Exam exam) async {
  String date(DateTime d) =>
      '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';
  DateTime nextDay(DateTime d) => d.add(const Duration(days: 1));
  String esc(String value) => value
      .replaceAll('\\', '\\\\')
      .replaceAll(',', '\\,')
      .replaceAll(';', '\\;')
      .replaceAll('\n', '\\n');
  final events = <(String, DateTime)>[
    ('${exam.name} 원서접수 마감', exam.applyEnd),
    ('${exam.name} 시험일', exam.examDate),
    if (exam.resultDateKnown) ('${exam.name} 합격자 발표', exam.resultDate),
  ];
  final b = StringBuffer(
      'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//CERTI:ON//KO\r\nCALSCALE:GREGORIAN\r\n');
  for (var i = 0; i < events.length; i++) {
    final event = events[i];
    b
      ..write('BEGIN:VEVENT\r\n')
      ..write('UID:${exam.id}-$i@certion.local\r\n')
      ..write('DTSTART;VALUE=DATE:${date(event.$2)}\r\n')
      ..write('DTEND;VALUE=DATE:${date(nextDay(event.$2))}\r\n')
      ..write('SUMMARY:${esc(event.$1)}\r\n')
      ..write('DESCRIPTION:${esc('공식 출처: ${exam.sourceUrl}')}\r\n')
      ..write('END:VEVENT\r\n');
  }
  b.write('END:VCALENDAR\r\n');
  await Clipboard.setData(ClipboardData(text: b.toString()));
  if (context.mounted)
    _simpleMessage(context, '캘린더용 ICS 내용을 복사했습니다. 캘린더 앱/파일에 붙여 넣어 사용할 수 있습니다.');
}

void _showSourceDialog(BuildContext context, Exam exam) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.verified_rounded, color: Color(0xFFCF4500)),
          SizedBox(width: 8),
          Text('출처 확인'),
        ],
      ),
      content: Text(
        '${exam.name}은 “${exam.officialSource}”의 2026 공식 공개 일정을 기준으로 저장된 데이터입니다.\n\n'
        '출처: ${exam.sourceUrl}\n'
        '${exam.scheduleNote.isEmpty ? '' : '검증 메모: ${exam.scheduleNote}'}',
        style: const TextStyle(height: 1.55),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: exam.sourceUrl));
            if (context.mounted) _simpleMessage(context, '공식 출처 URL을 복사했습니다.');
          },
          child: const Text('URL 복사'),
        ),
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('확인')),
      ],
    ),
  );
}

void _showFilterInfo(BuildContext context) {
  _simpleMessage(context,
      '현재 분야 + 일정 상태(접수중·접수예정·시험임박·발표대기) 필터를 지원합니다. 이후 지역·응시료·시험 방식 필터까지 확장할 수 있습니다.');
}

void _showSyncInfo(BuildContext context) {
  _simpleMessage(
      context,
      (certiApiBaseUrl.isEmpty && certiDataUrl.isEmpty)
          ? '현재는 앱에 포함된 공식 고정 일정 101건 + 상시시험 6종으로 동작합니다. CERTI_API_BASE_URL 또는 CERTI_DATA_URL을 지정하면 앱 시작 시 최신 공식 일정 DB를 자동으로 불러옵니다.'
          : '공식 일정 원격 동기화 주소가 연결되어 있습니다. 앱 시작 시 최신 DB를 불러오며, 네트워크 오류가 나면 내장 공식 일정으로 자동 복귀합니다.');
}

void _showPrivacyDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('AI·개인정보 원칙'),
      content: const Text(
        '• 공식 출처를 AI 요약보다 우선합니다.\n'
        '• AI 답변에는 원문 확인 경로를 제공합니다.\n'
        '• Android에서는 GGUF 모델을 휴대폰 내부에 내려받아 기기에서 직접 실행할 수 있습니다.\n'
        '• iPhone에서는 현재 공식 일정·플래너 기능과 같은 Wi-Fi의 PC Ollama AI 모드를 사용할 수 있습니다.\n'
        '• PC 고성능 모드는 Qwen3 14B/8B/4B Ollama 서버를 선택적으로 사용합니다.\n'
        '• 사용자의 관심 자격증·알림 설정은 최소한으로 수집하는 구조를 권장합니다.',
        style: TextStyle(height: 1.65),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('확인')),
      ],
    ),
  );
}

void _simpleMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

int daysUntil(DateTime date) {
  final today = appToday();
  final target = DateTime(date.year, date.month, date.day);
  return target.difference(today).inDays;
}

String shortDate(DateTime date) {
  return '${date.month}.${date.day.toString().padLeft(2, '0')}';
}

bool sameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'IT·개발':
      return Icons.code_rounded;
    case '데이터':
      return Icons.storage_rounded;
    case '사무·OA':
      return Icons.grid_view_rounded;
    case '어학':
      return Icons.translate_rounded;
    case '공기업·공무원':
      return Icons.account_balance_rounded;
    default:
      return Icons.workspace_premium_rounded;
  }
}
