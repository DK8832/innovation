(() => {
  "use strict";

  // GitHub Pages/file:// 공개 데모에서 FastAPI 없이도 핵심 화면이 동작하도록 하는 정적 API 어댑터입니다.
  // localhost/실서버에서는 원래 fetch를 그대로 사용해 FastAPI 기능 전체를 사용합니다.
  const isStatic = location.hostname.endsWith("github.io") || location.protocol === "file:";
  if (!isStatic) return;

  const EXAMS = [{"id":"information-processing-engineer","name":"정보처리기사","category":"national_tech","category_label":"국가기술자격","organizer":"한국산업인력공단(큐넷)","organizer_short":"큐넷","homepage":"https://www.q-net.or.kr","description":"IT 분야 대표 국가기술자격. 필기와 실기로 나뉘며 연 3회 시행된다.","sessions":[{"round":"2026년 3회","phase":"필기","apply_start":"2026-07-20","apply_end":"2026-07-23","exam_start":"2026-08-07","exam_end":"2026-09-01","result_date":"2026-09-09","verified":true,"note":null},{"round":"2026년 3회","phase":"실기","apply_start":"2026-09-21","apply_end":"2026-09-23","exam_start":"2026-10-24","exam_end":"2026-11-13","result_date":null,"verified":true,"note":"추가접수 9.28(월) 별도 진행. 합격자 발표일은 큐넷 공고 예정"}]},{"id":"industrial-safety-engineer","name":"산업안전기사","category":"national_tech","category_label":"국가기술자격","organizer":"한국산업인력공단(큐넷)","organizer_short":"큐넷","homepage":"https://www.q-net.or.kr","description":"산업 현장 안전관리 국가기술자격. 필기와 실기로 나뉘며 연 3회 시행된다.","sessions":[{"round":"2026년 3회","phase":"필기","apply_start":"2026-07-20","apply_end":"2026-07-23","exam_start":"2026-08-07","exam_end":"2026-09-01","result_date":"2026-09-09","verified":true,"note":null},{"round":"2026년 3회","phase":"실기","apply_start":"2026-09-21","apply_end":"2026-09-23","exam_start":"2026-10-24","exam_end":"2026-11-13","result_date":null,"verified":true,"note":"추가접수 9.28(월) 별도 진행. 합격자 발표일은 큐넷 공고 예정"}]},{"id":"electrical-engineer","name":"전기기사","category":"national_tech","category_label":"국가기술자격","organizer":"한국산업인력공단(큐넷)","organizer_short":"큐넷","homepage":"https://www.q-net.or.kr","description":"전기설비 설계·운영 국가기술자격. 필기와 실기로 나뉘며 연 3회 시행된다.","sessions":[{"round":"2026년 3회","phase":"필기","apply_start":"2026-07-20","apply_end":"2026-07-23","exam_start":"2026-08-07","exam_end":"2026-09-01","result_date":"2026-09-09","verified":true,"note":null},{"round":"2026년 3회","phase":"실기","apply_start":"2026-09-21","apply_end":"2026-09-23","exam_start":"2026-10-24","exam_end":"2026-11-13","result_date":null,"verified":true,"note":"추가접수 9.28(월) 별도 진행. 합격자 발표일은 큐넷 공고 예정"}]},{"id":"computer-literacy","name":"컴퓨터활용능력","category":"chamber","category_label":"상공회의소 자격","organizer":"대한상공회의소 자격평가사업단","organizer_short":"상공회의소","homepage":"https://license.korcham.net","description":"1급·2급으로 나뉘는 사무 자격증. 정해진 회차 없이 연중 상시로 접수·응시한다.","sessions":[{"round":"상시","phase":"상시","apply_start":null,"apply_end":null,"exam_start":null,"exam_end":null,"result_date":null,"rolling":true,"verified":false,"note":"연중 상시 접수·시험(예약일로부터 4주 이내 응시). 지역·시험장별 잔여 좌석은 공식 사이트에서 실시간 확인 필요"}]},{"id":"computerized-accounting-operator-1","name":"전산회계운용사 1급","category":"chamber","category_label":"상공회의소 자격","organizer":"대한상공회의소 자격평가사업단","organizer_short":"상공회의소","homepage":"https://license.korcham.net","description":"회계 소프트웨어 실무 자격증. 필기는 5·8·11월 일요일, 실기는 4월과 10월에 시행된다.","sessions":[{"round":"2026년 실기(10월)","phase":"실기","apply_start":null,"apply_end":null,"exam_start":"2026-10-10","exam_end":"2026-10-10","result_date":null,"verified":false,"note":"실기 시행일만 확인됨(10.10). 정확한 접수기간·필기(11월 일요일) 일정은 공식 사이트에서 확인 필요"}]},{"id":"korean-history-exam","name":"한국사능력검정시험","category":"history","category_label":"한국사능력검정","organizer":"국사편찬위원회","organizer_short":"국사편찬위원회","homepage":"https://www.historyexam.go.kr","description":"한국사 이해 수준을 평가하는 국가공인 시험. 공무원 가산점 등으로 널리 활용된다.","sessions":[{"round":"제80회","phase":"심화","apply_start":"2026-09-15","apply_end":"2026-09-22","exam_start":"2026-10-17","exam_end":"2026-10-17","result_date":null,"verified":true,"note":"제80회는 심화 등급만 시행(기본 등급 미시행)"}]},{"id":"toeic","name":"TOEIC","category":"language","category_label":"어학","organizer":"한국TOEIC위원회(YBM)","organizer_short":"YBM","homepage":"https://exam.toeic.co.kr","description":"국내에서 가장 널리 쓰이는 영어 어학 자격시험. 매달 여러 회차가 시행된다.","sessions":[{"round":"9월 6일 시험","phase":"정기시험","apply_start":"2026-07-20","apply_end":"2026-08-24","exam_start":"2026-09-06","exam_end":"2026-09-06","result_date":"2026-09-15","verified":true,"note":null},{"round":"9월 20일 시험","phase":"정기시험","apply_start":"2026-08-03","apply_end":"2026-09-07","exam_start":"2026-09-20","exam_end":"2026-09-20","result_date":"2026-09-29","verified":true,"note":null}]},{"id":"toeic-speaking","name":"TOEIC Speaking","category":"language","category_label":"어학","organizer":"한국TOEIC위원회(YBM)","organizer_short":"YBM","homepage":"https://www.toeicswt.co.kr","description":"영어 말하기 능력을 평가하는 어학시험. 매달 여러 회차가 시행된다.","sessions":[{"round":"9월 26일 시험","phase":"정기시험","apply_start":"2026-08-24","apply_end":"2026-09-23","exam_start":"2026-09-26","exam_end":"2026-09-26","result_date":"2026-10-01","verified":true,"note":null},{"round":"10월 4일 시험","phase":"정기시험","apply_start":"2026-08-31","apply_end":"2026-10-01","exam_start":"2026-10-04","exam_end":"2026-10-04","result_date":"2026-10-09","verified":true,"note":null}]},{"id":"opic","name":"OPIc","category":"language","category_label":"어학","organizer":"(주)한국외국어평가원","organizer_short":"OPIc","homepage":"https://www.opic.or.kr","description":"컴퓨터 기반 영어 말하기 평가. 일부 공휴일을 제외하고 거의 매일 시행된다.","sessions":[{"round":"상시","phase":"상시","apply_start":null,"apply_end":null,"exam_start":null,"exam_end":null,"result_date":null,"rolling":true,"verified":false,"note":"일부 공휴일을 제외하고 거의 매일 시행. 원하는 날짜를 선택해 온라인으로 접수(선착순 마감)"}]}];
  const APK_URL = "https://github.com/DK8832/innovation/releases/download/v3.0.0/CERTI_ON_v3.0.0_ANDROID.apk";
  const originalFetch = window.fetch.bind(window);
  const EVENT_LABELS = {
    apply_start: "접수 시작",
    apply_end: "접수 마감",
    exam_start: "시험",
    exam_end: "시험 종료",
    result_date: "합격자 발표",
  };

  function response(data, status = 200) {
    return Promise.resolve(new Response(JSON.stringify(data), {
      status,
      headers: { "Content-Type": "application/json; charset=utf-8" },
    }));
  }
  function todayKST() {
    const parts = new Intl.DateTimeFormat("en-CA", {
      timeZone: "Asia/Seoul", year: "numeric", month: "2-digit", day: "2-digit"
    }).formatToParts(new Date());
    const v = Object.fromEntries(parts.map(p => [p.type, p.value]));
    return `${v.year}-${v.month}-${v.day}`;
  }
  function daysBetween(a, b) {
    const A = Date.parse(`${a}T00:00:00Z`), B = Date.parse(`${b}T00:00:00Z`);
    return Math.round((B - A) / 86400000);
  }
  function events() {
    const today = todayKST();
    const out = [];
    for (const exam of EXAMS) {
      for (const s of exam.sessions || []) {
        if (s.rolling) continue;
        for (const key of ["apply_start","apply_end","exam_start","exam_end","result_date"]) {
          const date = s[key];
          if (!date) continue;
          if (key === "exam_end" && s.exam_end === s.exam_start) continue;
          out.push({
            exam_id: exam.id, exam_name: exam.name, category: exam.category,
            category_label: exam.category_label, organizer_short: exam.organizer_short,
            round: s.round, phase: s.phase, event_type: key, event_label: EVENT_LABELS[key],
            date, d_day: daysBetween(today, date), verified: !!s.verified, note: s.note || null,
          });
        }
      }
    }
    return out.sort((a,b) => a.date.localeCompare(b.date));
  }
  function extractDates(text) {
    const matches = [];
    const patterns = [/(20\d{2})\s*년\s*(\d{1,2})\s*월\s*(\d{1,2})\s*일/g, /(20\d{2})\s*[.\-/]\s*(\d{1,2})\s*[.\-/]\s*(\d{1,2})/g];
    const labels = [["원서접수","apply"],["접수기간","apply"],["접수 기간","apply"],["시험일자","exam"],["필기시험","exam"],["실기시험","exam"],["시험일","exam"],["합격자 발표","result"],["합격자발표","result"],["발표일","result"]];
    const seen = new Set();
    for (const re of patterns) {
      let m;
      while ((m = re.exec(text))) {
        const y=+m[1], mo=+m[2], d=+m[3];
        if (mo<1 || mo>12 || d<1 || d>31) continue;
        const iso=`${y}-${String(mo).padStart(2,"0")}-${String(d).padStart(2,"0")}`;
        const head=text.slice(Math.max(0,m.index-40),m.index);
        let kind="unknown", best=-1;
        for (const [label,k] of labels) { const pos=head.lastIndexOf(label); if (pos>best) { best=pos; kind=k; } }
        const key=`${iso}|${kind}`; if (seen.has(key)) continue; seen.add(key);
        matches.push({date:iso,kind,kind_label:{apply:"접수",exam:"시험",result:"발표"}[kind]||"구분 미상",context:text.slice(Math.max(0,m.index-30),Math.min(text.length,re.lastIndex+20)).replace(/\s+/g," ")});
      }
    }
    return matches.sort((a,b)=>a.date.localeCompare(b.date));
  }
  function section(text, aliases) {
    const headers=["응시자격","응시 자격","시험과목","시험 과목","합격기준","합격 기준","검정방법","시험방법","응시수수료","응시료","원서접수","접수기간","시험일자","필기시험","실기시험","합격자 발표"];
    for (const a of aliases) {
      const i=text.indexOf(a); if (i<0) continue;
      const start=i+a.length; let end=text.length;
      for (const h of headers) { if (h===a) continue; const p=text.indexOf(h,start); if (p>=0) end=Math.min(end,p); }
      const value=text.slice(start,end).replace(/^[\s:：\-–·|]+/,"").replace(/\s+/g," ").trim().slice(0,300);
      if (value) return value;
    }
    return null;
  }
  function summarize(text) {
    const specs={eligibility:["응시자격","응시 자격","지원자격","응시대상"],subjects:["시험과목","시험 과목","검정과목","출제과목"],passing:["합격기준","합격 기준","합격결정기준"],method:["검정방법","시험방법","출제형태","시험형식"],fee:["응시수수료","응시료","수수료"]};
    const labels={eligibility:"응시자격",subjects:"시험과목",passing:"합격기준",method:"검정방법",fee:"응시수수료"};
    const sections={};
    for (const [k,a] of Object.entries(specs)) { const v=section(text,a); sections[k]={label:labels[k],value:v,found:!!v}; }
    return {sections,dates:extractDates(text),method:"rule",llm_used:false,rejected_by_grounding:[],notes:["공개 웹 데모에서는 개인정보·API 키를 서버로 보내지 않고 브라우저의 규칙 기반 추출만 사용합니다."]};
  }

  window.fetch = async function(input, options = {}) {
    const raw = typeof input === "string" ? input : input.url;
    const url = new URL(raw, location.href);
    const path = url.pathname;
    const apiPos = path.indexOf("/api/");
    if (apiPos < 0) return originalFetch(input, options);
    const api = path.slice(apiPos);
    const method = (options.method || "GET").toUpperCase();

    if (api === "/api/exams") return response(EXAMS);
    if (api.startsWith("/api/exams/")) {
      const id = decodeURIComponent(api.slice("/api/exams/".length));
      const exam = EXAMS.find(e => e.id === id);
      return exam ? response(exam) : response({detail:"해당 시험을 찾을 수 없습니다"},404);
    }
    if (api === "/api/upcoming") {
      const days = Math.max(1, Math.min(365, +(url.searchParams.get("days") || 30)));
      return response(events().filter(e => e.d_day >= 0 && e.d_day <= days));
    }
    if (api === "/api/calendar") {
      const start=url.searchParams.get("start"), end=url.searchParams.get("end");
      return response(events().filter(e => (!start || e.date>=start) && (!end || e.date<=end)));
    }
    if (api === "/api/app/android") return response({available:true,platform:"Android",version:"3.0.0",filename:"CERTI_ON_v3.0.0_ANDROID.apk",size_bytes:23600984,download_url:APK_URL});
    if (api === "/api/sources") return response([
      {id:"curated",label:"공식 출처 확인 데이터",kind:"curated",enabled:true,detail:`${EXAMS.length}개 시험 종목의 저장 데이터를 브라우저에서 사용합니다. 최신 접수 전에는 공식 사이트를 다시 확인하세요.`},
      {id:"public_api",label:"공공데이터 자동 동기화",kind:"public_api",enabled:false,detail:"GitHub Pages 공개 데모는 서버가 없어 자동 동기화가 꺼져 있습니다. Full-Stack 실행에서 DATA_GO_KR_KEY를 사용할 수 있습니다."},
      {id:"ai_summary",label:"모집요강 요약",kind:"ai",enabled:true,detail:"공개 데모에서는 브라우저 규칙 기반 요약이 동작합니다. 날짜는 생성형 AI를 사용하지 않습니다."}
    ]);
    if (api === "/api/review") return response({sync:{last_run:null,reason:"공개 정적 데모"},changes:[]});
    if (api === "/api/subscribe" && method === "POST") {
      try { const body=JSON.parse(options.body||"{}"); localStorage.setItem(`certion-sub-${Date.now()}`, JSON.stringify(body)); } catch (_) {}
      return response({token:`local-${Date.now()}`,email:"local-demo",exam_id:"static",remind_days:[7,1],created_at:todayKST()});
    }
    if (api === "/api/summarize" && method === "POST") {
      let body={}; try { body=JSON.parse(options.body||"{}"); } catch (_) {}
      return response(summarize(String(body.text||"")));
    }
    return response({detail:"공개 정적 데모에서 지원하지 않는 API입니다."},404);
  };
})();
