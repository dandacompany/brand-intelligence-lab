# 임무 (CEO 의 최상위 부트스트랩 task)

Brand Intelligence Lab 의 첫 번째 운영 task.
**무신사 시장조사 보고서**를 4단계 자동 워크플로로 생성하고, 그 다음 같은 워크플로를 **29CM** 에 변수 치환으로 재실행해 재사용성을 검증한다.

각 child issue 는 정확히 매핑된 project 아래에 만들고, 담당자는 회사 import 로 이미 만들어진 3명 직원에게만 위임한다. **추가 채용 절대 금지.**

각 child 완료 시 **사람 단테의 명시적 코멘트 승인**을 게이트로 둔다 (아래 "단테 승인 게이트" 섹션 참조).

---

# 조직 / 프로젝트 ID 맵 (child issue 생성 시 참조)

| 역할 | name | id |
|---|---|---|
| 브랜드 리서처 | researcher | `44d6f186-ab43-4849-8a7d-42dff6b66bb1` |
| 데이터 분석가 | analyst (general) | `af481151-e1a1-4a3c-b2f9-03bd07ea4177` |
| 슬라이드 제작자 | engineer | `ed8c280b-cdce-45fb-9aee-74058d14f0a4` |
| CEO | ceo (self) | `8e43753d-a18c-4f44-a249-f4e48f5918f8` |

| project name | id |
|---|---|
| Onboarding (이 부트스트랩 이슈 자체) | `45b83249-c1a8-4ba1-be23-35eb579a3b58` |
| 브랜드 리서치 시스템 (단계 1) | `525b2f82-2bec-4492-bae4-856f4e8fde9e` |
| 분석 + SWOT + 팩트 체크 (단계 2) | `a15b027d-2035-4a5f-b93a-140b16bebc77` |
| 슬라이드 빌더 (단계 3, 4) | `caa19fe2-c756-4c31-9b30-0ce19bd3c8be` |

---

# 진행 흐름 (4단계 child issue 자동 위임)

각 단계는 직전 단계가 사람 단테의 승인까지 받은 다음에만 시작한다 (`blockedByIssueIds` + 단테 승인 코멘트 둘 다 충족).

## 단계 1 — 브랜드 리서처에게 위임

- **assigneeAgentId**: `44d6f186-ab43-4849-8a7d-42dff6b66bb1` (브랜드 리서처)
- **projectId**: `525b2f82-2bec-4492-bae4-856f4e8fde9e` (브랜드 리서치 시스템)
- **parentId**: 이 부트스트랩 issue 의 id
- **title**: `[무신사] 시장조사 데이터 6종 수집·구조화`
- **description**: 아래 "본문 — 단계 1" 그대로 사용

### 본문 — 단계 1

```markdown
# 임무

지정 브랜드 무신사의 시장조사 데이터 6종을 Bright Data 게이트와 공개 웹을 통해 수집하고,
workspace 안에 구조화 파일로 떨굽니다.

# 입력 변수 (1차 실행)

- BRAND: "무신사"
- OFFICIAL_URL: "musinsa.com"
- COMPETITORS: ["29CM", "W컨셉", "LF몰"]

# 사용 도구 (코멘트 첫 줄에 명시)

- brightdata CLI (bash 셸로 직접 호출 — 컨테이너 ~/.brightdata/ 에 이미 OAuth 인증되어 있음)
  - brightdata scrape <URL>
  - brightdata search "<query>"
  - brightdata discover "<query>"
  - brightdata pipelines <type> ...
  - 호출 패턴은 회사 라이브러리의 brightdata-cli, scrape, search, bright-data-best-practices 스킬 참고
- 공식 사이트·위키·보도자료 fetch (curl)

# 수집 절차 (산출물 6종)

1. brand_profile.md       — 위키·공식 사이트 + 회사 개요 (brightdata scrape)
2. competitor_matrix.csv  — COMPETITORS 각각의 가격대·타겟·핵심 라인 (brightdata scrape)
3. pricing_scrape.csv     — {BRAND} + COMPETITORS 베스트/랭킹 상위 50~100건 (brightdata scrape)
4. serp_trends.json       — brightdata search 로 4종 쿼리 12개월 트렌드
5. social_mentions.json   — brightdata pipelines 로 Instagram·TikTok·Threads 해시태그 멘션
6. dataset_imports/       — brightdata pipelines / discover 로 Naver·Coupang·SPA 4종·LinkedIn·Trustpilot

# 신뢰 규칙

- 14일 이내 자료 우선. 90일 초과는 별도 표시.
- 모든 행에 source_url 보존.
- 봇 차단 시 brightdata 의 unlocker zone 으로 우회 + 코멘트에 명시.

# 절대 제약

- 추측·평가성 어휘 금지. 비공식 평가·소문 인용 금지.
- API 키 평문 노출 금지 (첫 8자 + ***).
- robots.txt·ToS 위반 행위 금지. 일반 시장조사 범위 내.
- 결과는 반드시 paperclip API 코멘트로 POST.
- MCP 도구 호출 시도 금지. brightdata CLI 만 사용 (이번 회사는 CLI 트랙).

# 출력 (코멘트, 마크다운)

사용 도구: brightdata CLI (scrape · search · discover · pipelines)

## brand_profile
| 항목 | 값 |

## competitor_matrix (CSV 5행 요약)
| brand | price_range | target | strength | source_url |

## pricing_scrape (요약)
| 출처 | 수집 건수 | 평균가 | 중앙값 | 시간 |

## serp_trends (요약)
| 키워드 | 12개월 추세 | 피크 월 | 시즌성 |

## social_mentions (요약)
| 플랫폼 | 멘션 수 | 상위 해시태그 | 감성 분포 |

## dataset_imports
| 데이터셋 | 파일 | 행수 | 핵심 컬럼 |
```

---

## 단계 2 — 데이터 분석가에게 위임

- **assigneeAgentId**: `af481151-e1a1-4a3c-b2f9-03bd07ea4177` (데이터 분석가)
- **projectId**: `a15b027d-2035-4a5f-b93a-140b16bebc77` (분석 + SWOT + 팩트 체크)
- **parentId**: 이 부트스트랩 issue 의 id
- **blockedByIssueIds**: [단계 1 child issue id]
- **title**: `[무신사] 수집물 정제 + 인사이트 + SWOT + 팩트 체크`
- **description**: 아래 "본문 — 단계 2" 그대로 사용

### 본문 — 단계 2

```markdown
# 임무

브랜드 리서처(단계 1)가 떨군 6종 입력을 정제·분석해 다음 5종 산출물을 만듭니다.

# 입력

- workspace/brand_profile.md
- workspace/competitor_matrix.csv
- workspace/pricing_scrape.csv
- workspace/serp_trends.json
- workspace/social_mentions.json
- workspace/dataset_imports/*.csv
- 단계 1 브랜드 리서처의 paperclip 코멘트

# 사용 도구 (코멘트 첫 줄)

- pandas + numpy + plotly (워크스페이스 내 파이썬)
- (필요 시) brightdata scrape — 의심 인용 재검증 한정 1회

# 산출물 (5종)

1. cleaned_data.parquet — 통합 정제본
2. insights.md          — 핵심 인사이트 5개 (각 1~2문장 + 근거)
3. swot_matrix.json     — 강·약·기·위 각 3개씩 + 근거 URL
4. fact_check.md        — 정성 인용 10건 재검증 + 정량 시그널 재계산
5. chart_spec.json      — 4~6개 차트 spec (슬라이드 제작자용)

# 분석 절차

1. 모든 CSV/JSON 로드 → 스키마·결측·중복 점검
2. 가격 분포 (평균·중앙값·표준편차, 브랜드별)
3. 검색 트렌드 시즌성 (월별 평균 + σ)
4. SNS 멘션 토픽 클러스터링 (키워드 빈도 상위 10)
5. SWOT 자동 도출 (수집물 신호어 매칭, swot-from-signals 스킬 참고)
6. 팩트 체크:
   - 정성 인용 10건 → brightdata scrape 재 fetch → title·published_at·본문 키워드 일치
   - 정량 시그널 → 원본에서 직접 재계산 → 오차 ±2% 이내

# 절대 제약

- "추천"·"매수"·"좋다"·"나쁘다" 평가성 어휘 금지. "관찰"·"주목" 사용.
- 자신 의견과 인용 명확 구분. 인용은 출처 URL.
- 결과는 반드시 paperclip API 코멘트로 POST.

# 출력 (코멘트, 마크다운)

사용 도구: pandas + brightdata 재검증

## 핵심 인사이트 5개
1. ... — 근거: <출처 URL 또는 시그널값>

## SWOT (각 3개)
| 구분 | 항목 | 근거 |

## 팩트 체크 결과
| # | 인용 출처 | scrape HTTP | title 일치 | date ±1d | 본문 키워드 | OK |
| 정량 시그널 | 리서처 보고 | 재계산 | 오차% | OK |

## 종합 신뢰도
- 정정 필요: N건
- 신뢰도: 0~1.0
- 한 줄 코멘트
```

---

## 단계 3 — 슬라이드 제작자에게 위임 (Next.js + Tremor + Vercel 인터랙티브 보고서)

- **assigneeAgentId**: `ed8c280b-cdce-45fb-9aee-74058d14f0a4` (슬라이드 제작자)
- **projectId**: `caa19fe2-c756-4c31-9b30-0ce19bd3c8be` (슬라이드 빌더)
- **parentId**: 이 부트스트랩 issue 의 id
- **blockedByIssueIds**: [단계 2 child issue id]
- **title**: `[무신사] 시장조사 인터랙티브 보고서 빌드 + Vercel 배포`
- **description**: 아래 "본문 — 단계 3" 그대로 사용

### 본문 — 단계 3

````markdown
# 임무

브랜드 리서처(단계 1)와 데이터 분석가(단계 2)의 산출물을 입력으로 받아,
임원 보고용 **인터랙티브 웹 보고서**를 Next.js + shadcn/ui + Tremor + ECharts 로 빌드하고
Vercel 에 배포합니다. 정적 PDF 가 아니라 단테가 슬랙·이메일로 공유 가능한 URL 을 만듭니다.

# 입력

- workspace/{BRAND}/data/cleaned_data.parquet
- workspace/{BRAND}/data/insights.md
- workspace/{BRAND}/data/swot_matrix.json
- workspace/{BRAND}/data/fact_check.md
- workspace/{BRAND}/data/chart_spec.json
- workspace/{BRAND}/data/competitor_matrix_normalized.csv
- 단계 1·2 의 paperclip 코멘트

# 사용 도구 (코멘트 첫 줄)

- Next.js 15 + App Router + TypeScript + Tailwind
- shadcn/ui (Card · Tabs · Accordion · Table)
- Tremor (KPI · BarChart · LineChart · DonutChart)
- ECharts (Treemap · Geo · Network — 복잡 차트)
- Vercel CLI (배포)
- 회사 라이브러리의 **`nextjs-tremor-report`** 스킬에 풀 가이드 있음

# 사전 점검 (시작 전 통과해야 함)

```bash
node --version          # ≥ 20
vercel --version        # vercel CLI 존재 (setup.sh 가 설치)
echo "${VERCEL_API_TOKEN:0:8}***"   # paperclip secrets 에서 자동 주입됨
```

`VERCEL_API_TOKEN` 이 비어 있으면 즉시 단테에게 코멘트로 알리고 진행 중단.
(paperclip 콘솔 → Settings → Secrets 에 VERCEL_API_TOKEN 등록 필요)

# 스캐폴딩 + 빌드

```bash
WS=/workspace/{BRAND}
cd $WS
mkdir -p report-app && cd report-app

# 1) Next.js + Tailwind + shadcn/ui
npx create-next-app@latest . --typescript --tailwind --app --no-src-dir \
  --import-alias "@/*" --yes
npx shadcn@latest init --yes --base-color slate --css-variables true
npx shadcn@latest add card tabs accordion sheet button badge separator table --yes

# 2) Tremor + ECharts
npm i @tremor/react echarts echarts-for-react

# 3) Tailwind config 의 theme.extend 에 단테랩스 토큰 추가:
#    colors: { paper:"#F7F2E6", ink:"#1a1a1a", rust:"#A0522D" }
#    fontFamily: { serif:["Noto Serif KR","Noto Serif CJK KR","serif"],
#                  sans: ["Noto Sans KR","Noto Sans CJK KR","system-ui"] }
#    (자세한 토큰은 nextjs-tremor-report 스킬 참조)

# 4) 페이지 구성 (분석가 산출물 → 컴포넌트 매핑)
#    app/page.tsx            홈: 핵심 인사이트 5개 (Tremor Metric Card)
#    app/swot/page.tsx       SWOT 2x2 grid (shadcn Card)
#    app/charts/page.tsx     Tremor 4개 + ECharts 2개
#    app/fact-check/page.tsx Accordion (정성 인용 10건 재검증)
#    app/competitors/page.tsx shadcn Table (경쟁사 정규화 CSV)

# 5) 로컬 빌드 검증
npm run build
```

# Vercel 배포

```bash
export VERCEL_TOKEN="$VERCEL_API_TOKEN"

# 첫 배포면 link (프로젝트 자동 생성)
vercel link --yes --token "$VERCEL_TOKEN" --project "brand-intelligence-{BRAND}"

# production 배포
vercel deploy --prod --yes --token "$VERCEL_TOKEN" 2>&1 | tee /tmp/vercel-deploy.log

# 배포 URL 추출
DEPLOY_URL=$(grep -oE 'https://[a-z0-9-]+\.vercel\.app' /tmp/vercel-deploy.log | tail -1)
echo "DEPLOY_URL=$DEPLOY_URL"
```

# 자가 검증

```bash
# HTTP 200 + 한글 정상 표시
curl -sI "$DEPLOY_URL" | head -1                                  # HTTP/2 200
curl -s  "$DEPLOY_URL" | grep -oE "무신사|29CM|브랜드" | sort -u   # 한글 토큰 OK
```

# 디자인 가드 (단테랩스)

- 색상: paper(#F7F2E6) + ink(#1a1a1a) + rust(#A0522D) — Tailwind config
- 폰트: Noto Serif KR (본문) + Noto Sans KR (UI)
- 좌측 4px rust accent stripe — 컴포넌트별 `border-l-4 border-rust pl-4`
- corner radius ≤ 8px (Tailwind `rounded-lg` 까지만)
- shadow: hard `shadow-[2px_2px_0_0_rgba(0,0,0,0.08)]` (컬러 드롭섀도 금지)
- **금지**: 글래스모피즘 · backdrop-filter · mesh gradient · 네온 · 이모지 · 사진 배경 · 8px 초과 corner radius

# 절대 제약

- 데이터·문구 임의 가공 금지. 분석가 산출물 그대로 인용. 평가성 어휘 금지.
- `VERCEL_API_TOKEN` 평문 노출 금지 (첫 8자 + ***). 환경변수로만 사용, 코드/코멘트 직접 게시 금지.
- 결과는 반드시 paperclip API 코멘트로 POST + 배포 URL 명시.
- Vercel 프로젝트 명은 `brand-intelligence-{BRAND}` 명명 규칙 준수.

# 절대 제약

- 데이터·문구 임의 가공 금지. 분석가 산출물 그대로 인용.
- 디자인 가드 위반 0건.
- 평문 키 노출 금지.
- 결과는 반드시 paperclip API 코멘트로 POST.

# 출력 (코멘트)

사용 도구: Next.js 15 + shadcn/ui + Tremor + ECharts + Vercel

| 항목              | 값                                                       |
| ----------------- | -------------------------------------------------------- |
| **배포 URL**      | https://brand-intelligence-{BRAND}-xxxx.vercel.app       |
| 페이지 수         | 5 (홈 · SWOT · 차트 · 팩트체크 · 경쟁사)                 |
| 차트 수           | 6 (Tremor 4 + ECharts 2)                                 |
| 디자인 가드 위반  | 0건 (paper+ink+rust + Noto Serif/Sans KR)                |
| Lighthouse        | Performance ≥90, Accessibility ≥95                       |
| 한글 표시         | ✓ (curl + 시각 점검)                                     |
| 빌드 시간         | XmYs                                                     |
````

---

## 단계 4 — CEO 본인이 직접 처리 (Routines 변환 + 29CM 재실행)

- **assigneeAgentId**: `8e43753d-a18c-4f44-a249-f4e48f5918f8` (CEO self)
- **projectId**: `caa19fe2-c756-4c31-9b30-0ce19bd3c8be` (슬라이드 빌더 — 빌드 결과물 위에서 이루어짐)
- **parentId**: 이 부트스트랩 issue 의 id
- **blockedByIssueIds**: [단계 3 child issue id]
- **title**: `Routines 로 워크플로 패키징 + 29CM 갈아끼우기`
- **description**: 아래 "본문 — 단계 4" 그대로 사용

### 본문 — 단계 4

```markdown
# 임무

단계 1~3 의 워크플로를 Paperclip Routines 로 묶고,
입력 변수 BRAND·OFFICIAL_URL·COMPETITORS 를 치환해 29CM 로 재실행한다.

# 절차

1. 단계 1~3 의 child issue 본문을 routine "brand-research-pipeline" 으로 패키징
2. 본문의 "무신사" → {BRAND}, "musinsa.com" → {OFFICIAL_URL}, 경쟁사 리스트 → {COMPETITORS} 변수화
3. routine 실행:
     BRAND="29CM"
     OFFICIAL_URL="29cm.co.kr"
     COMPETITORS=["무신사","W컨셉","LF몰"]
4. 3명 직원이 동일 워크플로로 29CM 보고서 자동 생성
5. 무신사 보고서와 29CM 보고서를 나란히 비교 검증

# 절대 제약

- 워크플로 구조·페르소나 capabilities 변경 금지. 입력 변수만 치환.
- 29CM 도 robots.txt·ToS 범위 내 시장조사만.
- 결과는 반드시 paperclip API 코멘트로 POST.

# 출력 (코멘트)

| 단계                  | 무신사                                              | 29CM                                              | 일치 |
| --------------------- | --------------------------------------------------- | ------------------------------------------------- | ---- |
| 수집 6종 파일 수      | 6                                                   | 6                                                 | ✓    |
| 분석 산출물 5종       | ✓                                                   | ✓                                                 | ✓    |
| 보고서 페이지 수      | 5                                                   | 5                                                 | ✓    |
| 차트 수               | 6                                                   | 6                                                 | ✓    |
| 디자인 가드 위반      | 0                                                   | 0                                                 | ✓    |
| 빌드 + 배포 시간      | XmYs                                                | XmYs                                              | -    |
| **배포 URL**          | https://brand-intelligence-musinsa-xxxx.vercel.app  | https://brand-intelligence-29cm-xxxx.vercel.app   | -    |

## 결론
브랜드만 갈아끼워 동일 구조 인터랙티브 보고서 생성 가능 = 재현성 검증 OK.
두 URL 을 슬랙·이메일로 임원진에게 공유 가능.
```

---

# 단테 승인 게이트 (절대 제약)

각 child issue 가 done 으로 넘어가기 전에 **본 부트스트랩 이슈 (parent) 에 다음 형식으로 코멘트를 작성**한 다음, **사람 단테의 명시적 코멘트 응답 ("승인" 또는 "Approve")** 을 받은 후에만 다음 child 단계를 위임한다.

## 보고 형식 (각 단계 종료 시 parent 코멘트)

```
### 단계 N 완료 보고 ({담당자명})

- 산출물: <파일/링크 리스트>
- 핵심 결과: <2~3줄 요약>
- 검토 포인트: <단테가 확인해야 할 항목>
- 다음 단계 예고: <위임할 child 의 담당자와 임무>

@dante 위 결과 검토 후 "승인" 또는 "반려: <이유>" 코멘트 부탁드립니다.
```

단테가 "**반려: <이유>**" 로 응답하면 **수정 child issue 를 새로 만들어** 그 단계를 다시 진행한다 (원본 child 는 in_review 로 두고 수정본 done 후 묶어서 다시 보고).

---

# 사용 도구 (모든 child 공통)

- **brightdata CLI** (bash 셸로 직접 호출) — 컨테이너 `~/.brightdata/` OAuth 인증 영속
  - 가이드 스킬: brightdata-cli, scrape, search, bright-data-best-practices (브랜드 리서처에만 켜져 있음)
- **paperclip 공식 스킬** — paperclip, paperclip-converting-plans-to-tasks 등
- **회사 도메인 스킬** — brand-research-glossary, swot-from-signals, marp-slide-build, report-evidence-citation

# 절대 제약 (회사 전역)

- **새 에이전트 채용 금지**. 3명 직원 + CEO 의 4인 구성 고정. paperclip-create-agent 스킬 호출 금지.
- **단테 승인 게이트 우회 금지**. 각 child done 전 반드시 단테 코멘트 응답 확인.
- **MCP 도구 호출 금지**. 이 회사는 brightdata CLI 트랙으로만 운영 (mcp 서버 등록 안 되어 있음).
- 추측·평가성 어휘 금지. API 키 평문 노출 금지 (첫 8자 + ***).
- 결과는 반드시 paperclip API 코멘트로 POST.
