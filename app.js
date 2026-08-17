(() => {
  "use strict";

  const CATEGORY_LABELS = {
    national_tech: "국가기술자격",
    chamber: "상공회의소 자격",
    history: "한국사능력검정",
    language: "어학",
  };
  const CATEGORY_COLOR_VAR = {
    national_tech: "--cat-national_tech",
    chamber: "--cat-chamber",
    history: "--cat-history",
    language: "--cat-language",
  };
  const WEEKDAYS = ["일", "월", "화", "수", "목", "금", "토"];

  const state = {
    view: "calendar",
    category: "",
    query: "",
    monthCursor: firstOfMonth(new Date()),
    exams: [],
    examsById: {},
    monthEvents: [],
    listEvents: [],
    selectedDateKey: null,
  };

  // ---------- utils ----------
  function firstOfMonth(d) {
    return new Date(d.getFullYear(), d.getMonth(), 1);
  }
  function toISODate(d) {
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
  }
  function fmtHuman(iso) {
    const [y, m, d] = iso.split("-").map(Number);
    const dt = new Date(y, m - 1, d);
    return `${m}월 ${d}일(${WEEKDAYS[dt.getDay()]})`;
  }
  function categoryColor(cat) {
    return getComputedStyle(document.documentElement).getPropertyValue(CATEGORY_COLOR_VAR[cat] || "--muted").trim();
  }
  function ddayClass(d) {
    if (d === 0) return "today";
    if (d <= 3) return "urgent";
    if (d <= 14) return "soon";
    return "normal";
  }
  function ddayText(d) {
    if (d === 0) return "D-DAY";
    return `D-${d}`;
  }
  async function fetchJSON(url, opts) {
    const res = await fetch(url, opts);
    if (!res.ok) {
      let detail = res.statusText;
      try {
        const body = await res.json();
        detail = body.detail || JSON.stringify(body);
      } catch (_) {}
      const err = new Error(detail);
      err.status = res.status;
      throw err;
    }
    return res.json();
  }
  function matchesFilter(exam_id, category_ok_field) {
    return true;
  }
  function passesQuery(text) {
    if (!state.query) return true;
    return text.toLowerCase().includes(state.query.toLowerCase());
  }

  // ---------- data loading ----------
  async function loadExams() {
    state.exams = await fetchJSON("/api/exams");
    state.examsById = Object.fromEntries(state.exams.map((e) => [e.id, e]));
  }

  function formatMegabytes(bytes) {
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  }

  async function loadAndroidAppInfo() {
    const button = document.getElementById("apkDownloadButton");
    const meta = document.getElementById("apkMeta");
    try {
      const info = await fetchJSON("/api/app/android");
      if (!info.available || !info.download_url) throw new Error("설치 파일이 준비되지 않았습니다");
      meta.textContent = `v${info.version} · ${info.platform} · ${formatMegabytes(info.size_bytes)}`;
      button.href = info.download_url;
      button.setAttribute("download", info.filename);
    } catch (error) {
      meta.textContent = "현재 설치 파일을 내려받을 수 없습니다.";
      button.removeAttribute("href");
      button.removeAttribute("download");
      button.classList.add("is-disabled");
      button.setAttribute("aria-disabled", "true");
      button.textContent = "설치 파일 준비 중";
    }
  }

  async function loadUpcomingForUpcomingRow() {
    const events = await fetchJSON("/api/upcoming?days=45");
    return events.slice(0, 8);
  }

  async function loadMonthEvents() {
    const start = state.monthCursor;
    const end = new Date(start.getFullYear(), start.getMonth() + 1, 0);
    const events = await fetchJSON(`/api/calendar?start=${toISODate(start)}&end=${toISODate(end)}`);
    state.monthEvents = events;
  }

  async function loadListEvents() {
    state.listEvents = await fetchJSON("/api/upcoming?days=365");
  }

  // ---------- rendering: upcoming row ----------
  function renderUpcomingRow(events) {
    const el = document.getElementById("upcomingRow");
    if (!events.length) {
      el.innerHTML = `<div class="empty-row">앞으로 45일 안에 예정된 마감이 없습니다.</div>`;
      return;
    }
    el.innerHTML = events
      .map(
        (ev) => `
      <div class="upcoming-card" data-exam-id="${ev.exam_id}">
        <span class="dday ${ddayClass(ev.d_day)}">${ddayText(ev.d_day)}</span>
        <div class="exam-name" style="margin-top:8px">
          <span class="cat-dot" style="background:${categoryColor(ev.category)}"></span>${ev.exam_name}
        </div>
        <div class="event-label">${ev.event_label} · ${fmtHuman(ev.date)}</div>
      </div>`
      )
      .join("");
    el.querySelectorAll(".upcoming-card").forEach((card) => {
      card.addEventListener("click", () => openExamModal(card.dataset.examId));
    });
  }

  // ---------- rendering: rolling exams ----------
  function renderRolling() {
    const rolling = state.exams.filter((e) => e.sessions.some((s) => s.rolling));
    const el = document.getElementById("rollingRow");
    if (!rolling.length) {
      el.innerHTML = `<div class="empty-row">상시 접수 시험이 없습니다.</div>`;
      return;
    }
    el.innerHTML = rolling
      .map(
        (e) => `
      <div class="rolling-card" data-exam-id="${e.id}">
        <div class="exam-name"><span class="cat-dot" style="background:${categoryColor(e.category)}"></span>${e.name}</div>
        <div class="rolling-note">${e.organizer_short} · ${e.sessions[0].note || "상시 접수"}</div>
      </div>`
      )
      .join("");
    el.querySelectorAll(".rolling-card").forEach((card) => {
      card.addEventListener("click", () => openExamModal(card.dataset.examId));
    });
  }

  // ---------- rendering: calendar ----------
  function filteredMonthEvents() {
    return state.monthEvents.filter((ev) => {
      if (state.category && ev.category !== state.category) return false;
      return passesQuery(ev.exam_name + " " + ev.organizer_short);
    });
  }

  function renderCalendar() {
    const label = document.getElementById("calendarMonthLabel");
    label.textContent = `${state.monthCursor.getFullYear()}년 ${state.monthCursor.getMonth() + 1}월`;

    const grid = document.getElementById("calendarGrid");
    const year = state.monthCursor.getFullYear();
    const month = state.monthCursor.getMonth();
    const firstWeekday = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const todayKey = toISODate(new Date());

    const eventsByDate = {};
    filteredMonthEvents().forEach((ev) => {
      (eventsByDate[ev.date] = eventsByDate[ev.date] || []).push(ev);
    });

    let html = "";
    for (let i = 0; i < firstWeekday; i++) html += `<div class="cal-cell is-empty"></div>`;
    for (let d = 1; d <= daysInMonth; d++) {
      const dateKey = `${year}-${String(month + 1).padStart(2, "0")}-${String(d).padStart(2, "0")}`;
      const dayEvents = eventsByDate[dateKey] || [];
      const isToday = dateKey === todayKey;
      const isSelected = dateKey === state.selectedDateKey;
      const dots = dayEvents
        .slice(0, 6)
        .map((ev) => `<span class="cal-dot" style="background:${categoryColor(ev.category)}"></span>`)
        .join("");
      html += `<div class="cal-cell ${isToday ? "is-today" : ""} ${isSelected ? "is-selected" : ""}" data-date="${dateKey}">
        <div class="cal-date">${d}</div>
        <div class="cal-dots">${dots}</div>
      </div>`;
    }
    grid.innerHTML = html;
    grid.querySelectorAll(".cal-cell:not(.is-empty)").forEach((cell) => {
      cell.addEventListener("click", () => selectDate(cell.dataset.date, eventsByDate[cell.dataset.date] || []));
    });

    if (state.selectedDateKey && eventsByDate[state.selectedDateKey]) {
      renderDayDetail(state.selectedDateKey, eventsByDate[state.selectedDateKey]);
    } else {
      document.getElementById("dayDetail").hidden = true;
    }
  }

  function selectDate(dateKey, events) {
    state.selectedDateKey = state.selectedDateKey === dateKey ? null : dateKey;
    renderCalendar();
    if (state.selectedDateKey) renderDayDetail(dateKey, events);
  }

  function renderDayDetail(dateKey, events) {
    const el = document.getElementById("dayDetail");
    if (!events.length) {
      el.hidden = true;
      return;
    }
    el.hidden = false;
    el.innerHTML = `<div class="day-detail-title">${fmtHuman(dateKey)}</div>` +
      events
        .map(
          (ev) => `
      <div class="event-row" data-exam-id="${ev.exam_id}">
        <div class="event-main">
          <div class="exam-name"><span class="cat-dot" style="background:${categoryColor(ev.category)}"></span>${ev.exam_name}</div>
          <div class="event-meta">${ev.organizer_short} · ${ev.round} ${ev.phase} · ${ev.event_label}${ev.verified ? "" : ' <span class="badge-unverified">날짜 확인 필요</span>'}</div>
        </div>
        <span class="dday ${ddayClass(ev.d_day)}">${ddayText(ev.d_day)}</span>
      </div>`
        )
        .join("");
    el.querySelectorAll(".event-row").forEach((row) => {
      row.addEventListener("click", () => openExamModal(row.dataset.examId));
    });
  }

  // ---------- rendering: list view ----------
  function renderListView() {
    const el = document.getElementById("listBody");
    const filtered = state.listEvents.filter((ev) => {
      if (state.category && ev.category !== state.category) return false;
      return passesQuery(ev.exam_name + " " + ev.organizer_short);
    });
    if (!filtered.length) {
      el.innerHTML = `<div class="empty-row">조건에 맞는 예정 일정이 없습니다.</div>`;
      return;
    }
    el.innerHTML = filtered
      .map(
        (ev) => `
      <div class="event-row" data-exam-id="${ev.exam_id}">
        <div class="event-main">
          <div class="exam-name"><span class="cat-dot" style="background:${categoryColor(ev.category)}"></span>${ev.exam_name}
            <span style="color:var(--muted);font-weight:500;font-size:12px">· ${ev.organizer_short}</span></div>
          <div class="event-meta">${ev.round} ${ev.phase} · ${ev.event_label}${ev.verified ? "" : ' <span class="badge-unverified">날짜 확인 필요</span>'}</div>
        </div>
        <div class="event-date">${fmtHuman(ev.date)}</div>
        <span class="dday ${ddayClass(ev.d_day)}">${ddayText(ev.d_day)}</span>
      </div>`
      )
      .join("");
    el.querySelectorAll(".event-row").forEach((row) => {
      row.addEventListener("click", () => openExamModal(row.dataset.examId));
    });
  }

  // ---------- modal ----------
  async function openExamModal(examId) {
    let exam;
    try {
      exam = await fetchJSON(`/api/exams/${encodeURIComponent(examId)}`);
    } catch (e) {
      alert("시험 정보를 불러오지 못했습니다: " + e.message);
      return;
    }
    const modal = document.getElementById("examModal");
    const body = document.getElementById("modalBody");

    const rows = exam.sessions
      .map((s) => {
        if (s.rolling) {
          return `<tr><td colspan="4">상시 접수 · ${s.note || ""}</td></tr>`;
        }
        const cell = (v) => (v ? fmtHuman(v) : "—");
        return `<tr>
          <td>${s.round}${s.phase ? " · " + s.phase : ""}${s.verified ? "" : ' <span class="badge-unverified">확인필요</span>'}</td>
          <td>${cell(s.apply_start)} ~ ${cell(s.apply_end)}</td>
          <td>${cell(s.exam_start)}${s.exam_end && s.exam_end !== s.exam_start ? " ~ " + cell(s.exam_end) : ""}</td>
          <td>${cell(s.result_date)}</td>
        </tr>${s.note ? `<tr><td colspan="4" style="color:var(--muted);font-size:11.5px;padding-top:0">${s.note}</td></tr>` : ""}`;
      })
      .join("");

    body.innerHTML = `
      <h3>${exam.name}</h3>
      <div class="modal-organizer">${exam.category_label} · ${exam.organizer}</div>
      <p class="modal-desc">${exam.description}</p>
      <table>
        <thead><tr><th>회차</th><th>접수기간</th><th>시험일</th><th>발표일</th></tr></thead>
        <tbody>${rows}</tbody>
      </table>
      <div class="modal-links"><a class="btn-ink-pill outline" href="${exam.homepage}" target="_blank" rel="noopener">공식 홈페이지 열기 ↗</a></div>

      <form class="subscribe-form" id="subscribeForm" data-exam-id="${exam.id}">
        <h4>이메일로 마감 알림 받기</h4>
        <div class="row">
          <input type="email" name="email" placeholder="you@example.com" required>
        </div>
        <div class="remind-options">
          <label><input type="checkbox" name="remind" value="14"> D-14</label>
          <label><input type="checkbox" name="remind" value="7" checked> D-7</label>
          <label><input type="checkbox" name="remind" value="1" checked> D-1</label>
        </div>
        <button type="submit" class="btn-ink-pill">알림 신청</button>
        <div class="subscribe-msg" id="subscribeMsg"></div>
      </form>
    `;

    document.getElementById("subscribeForm").addEventListener("submit", onSubscribeSubmit);
    modal.hidden = false;
  }

  async function onSubscribeSubmit(evt) {
    evt.preventDefault();
    const form = evt.target;
    const email = form.email.value.trim();
    const remindDays = Array.from(form.querySelectorAll('input[name="remind"]:checked')).map((cb) => Number(cb.value));
    const msgEl = document.getElementById("subscribeMsg");
    const btn = form.querySelector("button");

    if (!remindDays.length) {
      msgEl.textContent = "알림 시점을 하나 이상 선택하세요.";
      msgEl.className = "subscribe-msg error";
      return;
    }

    btn.disabled = true;
    msgEl.textContent = "";
    try {
      await fetchJSON("/api/subscribe", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, exam_id: form.dataset.examId, remind_days: remindDays }),
      });
      msgEl.textContent = "알림이 신청되었습니다. (서버에 SMTP가 설정되어 있어야 실제 메일이 발송됩니다)";
      msgEl.className = "subscribe-msg ok";
      form.reset();
    } catch (e) {
      msgEl.textContent = "신청 실패: " + e.message;
      msgEl.className = "subscribe-msg error";
    } finally {
      btn.disabled = false;
    }
  }

  function closeModal() {
    document.getElementById("examModal").hidden = true;
  }

  // ---------- data sources ----------
  async function renderSources() {
    const el = document.getElementById("sourcesRow");
    let sources;
    try {
      sources = await fetchJSON("/api/sources");
    } catch (e) {
      el.innerHTML = `<div class="empty-row">출처 정보를 불러오지 못했습니다: ${e.message}</div>`;
      return;
    }
    el.innerHTML = sources
      .map(
        (s) => `
      <div class="source-card">
        <div class="src-head">
          <span class="src-name">${s.label}</span>
          <span class="src-state ${s.enabled ? "on" : "off"}">${s.enabled ? "동작 중" : "미설정"}</span>
        </div>
        <div class="src-detail">${s.detail}</div>
      </div>`
      )
      .join("");

    // 검토 대기 중인 변경이 있으면 함께 알린다
    try {
      const review = await fetchJSON("/api/review");
      const box = document.getElementById("reviewSummary");
      const count = (review.changes || []).length;
      if (count > 0) {
        box.hidden = false;
        box.innerHTML = `<strong>검토 대기 ${count}건</strong> — 자동 수집이 기존 일정과 다른 값을 찾았습니다.
          사람이 확인하기 전까지 캘린더에 반영하지 않습니다.`;
      } else {
        box.hidden = true;
      }
    } catch (_) {
      /* 검토 큐는 부가 정보라 실패해도 화면을 막지 않는다 */
    }
  }

  // ---------- summarizer ----------
  const SAMPLE_NOTICE = `2026년도 제3회 정보처리기사 국가기술자격 검정 시행공고

1. 원서접수 기간
   - 필기시험 원서접수: 2026년 7월 20일(월) 09:00 ~ 2026년 7월 23일(목) 18:00
   - 실기시험 원서접수: 2026. 9. 21. ~ 2026. 9. 23.

2. 시험일자
   - 필기시험: 2026년 8월 7일(금) ~ 2026년 9월 1일(화) CBT 시행
   - 실기시험: 2026년 10월 24일(토)

3. 합격자 발표
   - 필기 합격자발표: 2026년 9월 9일(수)

4. 응시자격
   대학졸업자 또는 졸업예정자, 관련학과 전문대학 졸업자로서 실무경력 2년 이상인 자,
   기능사 자격 취득 후 동일 직무분야에서 3년 이상 실무에 종사한 자

5. 시험과목
   필기: 소프트웨어설계, 소프트웨어개발, 데이터베이스구축, 프로그래밍언어활용, 정보시스템 구축관리
   실기: 정보처리실무

6. 합격기준
   필기: 과목당 100점 만점에 40점 이상, 전과목 평균 60점 이상
   실기: 100점 만점에 60점 이상

7. 응시수수료
   필기 19,400원 / 실기 22,600원`;

  async function runSummarize() {
    const input = document.getElementById("noticeInput");
    const box = document.getElementById("summarizeResult");
    const btn = document.getElementById("summarizeBtn");
    const text = input.value.trim();

    if (!text) {
      box.hidden = false;
      box.innerHTML = `<div class="empty-row">먼저 공고문을 붙여넣거나 '예시 공고문 넣기'를 눌러주세요.</div>`;
      return;
    }

    btn.disabled = true;
    box.hidden = false;
    box.innerHTML = `<div class="skeleton-row">분석 중…</div>`;

    let data;
    try {
      data = await fetchJSON("/api/summarize", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text, use_llm: true }),
      });
    } catch (e) {
      box.innerHTML = `<div class="empty-row">요약에 실패했습니다: ${e.message}</div>`;
      btn.disabled = false;
      return;
    }

    const methodLabel = data.llm_used ? "규칙 추출 + AI 보강" : "규칙 기반 추출 (AI 미사용)";
    const dateChips = (data.dates || [])
      .map(
        (d) => `<span class="date-chip">
          <span class="k ${d.kind}">${d.kind_label}</span>
          <span class="d">${d.date}</span>
        </span>`
      )
      .join("");

    const sectionItems = Object.values(data.sections || {})
      .map(
        (s) => `<div class="section-item ${s.found ? "" : "missing"}">
          <div class="lbl">${s.label}</div>
          <div class="val">${s.found ? s.value : "원문에서 찾지 못했습니다"}</div>
        </div>`
      )
      .join("");

    let notes = "";
    if ((data.rejected_by_grounding || []).length) {
      notes += `<div class="grounding-note">원문 대조를 통과하지 못해 폐기한 AI 결과:
        <strong>${data.rejected_by_grounding.join(", ")}</strong> — 규칙 기반 결과로 대체했습니다.</div>`;
    }
    (data.notes || []).forEach((n) => {
      notes += `<div class="grounding-note">${n}</div>`;
    });

    box.innerHTML = `
      <span class="method-badge ${data.llm_used ? "ai" : ""}">${methodLabel}</span>
      <div class="result-block">
        <h4>추출된 날짜 <span style="font-weight:500;color:var(--muted);font-size:11.5px">· AI를 거치지 않고 원문에서 직접 추출</span></h4>
        ${dateChips ? `<div class="date-chip-row">${dateChips}</div>` : `<div class="empty-row">날짜를 찾지 못했습니다.</div>`}
      </div>
      <div class="result-block">
        <h4>표준 항목</h4>
        <div class="section-list">${sectionItems}</div>
      </div>
      ${notes}
    `;
    btn.disabled = false;
  }

  // ---------- 만든 과정: 전제에 취소선이 그어지는 순간 ----------
  // 화면에 들어온 가설 문장에 취소선을 긋는다.
  //
  // IntersectionObserver 대신 좌표를 직접 재는 이유: 관찰자는 브라우저가 화면을
  // 그리고 있을 때만 콜백을 준다. 실제로 검증 중에 콜백이 한 번도 오지 않아
  // 취소선이 영영 안 그어지는 상황을 만났다. 좌표 계산은 그런 조건에 기대지 않는다.
  // ⚠️ 이 함수는 반드시 하나의 참조로 유지한다. 호출할 때마다 새 함수를 만들어
  //    등록하면, removeEventListener가 등록된 적 없는 함수를 지우려 해서 아무것도
  //    지워지지 않는다. 탭을 오갈 때마다 리스너가 쌓인다.
  let strikeBound = false;

  function sweepAssumptions() {
    const lines = document.querySelectorAll("#processView .assumption-line");
    if (!lines.length) return;

    let remaining = 0;
    lines.forEach((line) => {
      const card = line.closest(".reversal");
      if (!card || card.classList.contains("struck")) return;
      const rect = line.getBoundingClientRect();
      const viewportH = window.innerHeight || document.documentElement.clientHeight;
      // 화면 밖이거나 패널이 숨겨져 있으면(rect가 전부 0) 긋지 않는다
      if (rect.bottom > 0 && rect.top < viewportH * 0.9) {
        card.classList.add("struck");
      } else {
        remaining += 1;
      }
    });

    if (remaining === 0 && strikeBound) {
      window.removeEventListener("scroll", sweepAssumptions);
      strikeBound = false;
    }
  }

  function strikeAssumptions() {
    sweepAssumptions();
    const pending = document.querySelectorAll("#processView .reversal:not(.struck)").length;
    if (pending && !strikeBound) {
      window.addEventListener("scroll", sweepAssumptions, { passive: true });
      strikeBound = true;
    }
  }

  // ---------- view switching / refresh ----------
  async function refreshCurrentView() {
    if (state.view === "calendar") {
      await loadMonthEvents();
      renderCalendar();
    } else if (state.view === "list") {
      await loadListEvents();
      renderListView();
    }
    // 요약기 뷰는 사용자가 입력해야 결과가 생기므로 새로 불러올 것이 없다
  }

  function setView(view) {
    state.view = view;
    document.querySelectorAll(".view-btn").forEach((b) => b.classList.toggle("is-active", b.dataset.view === view));
    document.getElementById("calendarView").hidden = view !== "calendar";
    document.getElementById("listView").hidden = view !== "list";
    document.getElementById("summarizerView").hidden = view !== "summarizer";
    document.getElementById("processView").hidden = view !== "process";

    // 필터·마감 요약·상시시험·출처는 일정을 보는 화면에서만 의미가 있다
    const scheduleViews = view === "calendar" || view === "list";
    document.querySelector(".filter-bar").hidden = !scheduleViews;
    document.querySelector(".upcoming-section").hidden = !scheduleViews;
    document.querySelector(".rolling-section").hidden = !scheduleViews;
    document.querySelector(".sources-section").hidden = !scheduleViews;

    if (view === "process") strikeAssumptions();
    refreshCurrentView();
  }

  function wireEvents() {
    document.querySelectorAll(".view-btn").forEach((b) => b.addEventListener("click", () => setView(b.dataset.view)));
    document.querySelectorAll(".chip").forEach((chip) => {
      chip.addEventListener("click", () => {
        document.querySelectorAll(".chip").forEach((c) => c.classList.remove("is-active"));
        chip.classList.add("is-active");
        state.category = chip.dataset.category;
        refreshCurrentView();
      });
    });
    let searchTimer;
    document.getElementById("searchInput").addEventListener("input", (e) => {
      clearTimeout(searchTimer);
      searchTimer = setTimeout(() => {
        state.query = e.target.value;
        refreshCurrentView();
      }, 200);
    });
    document.getElementById("prevMonth").addEventListener("click", () => {
      state.monthCursor = new Date(state.monthCursor.getFullYear(), state.monthCursor.getMonth() - 1, 1);
      state.selectedDateKey = null;
      loadMonthEvents().then(renderCalendar);
    });
    document.getElementById("nextMonth").addEventListener("click", () => {
      state.monthCursor = new Date(state.monthCursor.getFullYear(), state.monthCursor.getMonth() + 1, 1);
      state.selectedDateKey = null;
      loadMonthEvents().then(renderCalendar);
    });
    document.getElementById("summarizeBtn").addEventListener("click", runSummarize);
    document.getElementById("loadSampleBtn").addEventListener("click", () => {
      document.getElementById("noticeInput").value = SAMPLE_NOTICE;
    });
    document.getElementById("modalClose").addEventListener("click", closeModal);
    document.getElementById("examModal").addEventListener("click", (e) => {
      if (e.target.id === "examModal") closeModal();
    });
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape") closeModal();
    });

    // 리플 효과: .btn-ink-pill은 모달을 열 때마다 새로 생성되므로 위임(delegation)으로 처리
    document.addEventListener("mousedown", (e) => {
      const btn = e.target.closest(".btn-ink-pill");
      if (!btn) return;
      const existing = btn.querySelector(".ripple");
      if (existing) existing.remove();
      const circle = document.createElement("span");
      const diameter = Math.max(btn.clientWidth, btn.clientHeight);
      const rect = btn.getBoundingClientRect();
      circle.style.width = circle.style.height = `${diameter}px`;
      circle.style.left = `${e.clientX - rect.left - diameter / 2}px`;
      circle.style.top = `${e.clientY - rect.top - diameter / 2}px`;
      circle.className = "ripple";
      btn.appendChild(circle);
    });

    // 떠 있는 상단 네비게이션: 아래로 스크롤하면 숨기고 위로 스크롤하면 보여줌
    const nav = document.getElementById("floatingNav");
    let lastScroll = 0;
    window.addEventListener("scroll", () => {
      const cur = window.pageYOffset;
      nav.style.top = cur > 80 && cur > lastScroll ? "-100px" : "20px";
      lastScroll = cur;
    });
  }

  function initScrollReveal() {
    const observer = new IntersectionObserver(
      (entries, obs) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("in-view");
            obs.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.1 }
    );
    document.querySelectorAll(".fade-up").forEach((el) => observer.observe(el));
  }

  async function init() {
    wireEvents();
    initScrollReveal();
    await loadAndroidAppInfo();
    try {
      await loadExams();
      renderRolling();
      const upcoming = await loadUpcomingForUpcomingRow();
      renderUpcomingRow(upcoming);
      await loadMonthEvents();
      renderCalendar();
      // 출처 표시는 부가 정보라 실패해도 캘린더를 막지 않도록 마지막에 따로 부른다
      renderSources();
    } catch (e) {
      document.getElementById("upcomingRow").innerHTML = `<div class="empty-row">데이터를 불러오지 못했습니다: ${e.message}</div>`;
    }
  }

  document.addEventListener("DOMContentLoaded", init);
})();
