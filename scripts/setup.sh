#!/usr/bin/env bash
# Brand Intelligence Lab — 컨테이너 최초 셋업 스크립트
#
# 회사 import 직후 한 번만 실행. 시청자가 슬라이드 빌드 단계에서 만나던
# Chromium 의존성 누락 / marp-cli 매번 npx 다운로드 / brightdata CLI 미설치
# 같은 함정을 처음에 한 번에 해소한다.
#
# 실행 방법:
#   ssh DanteServer
#   docker exec -it -u root paperclip-r7b8-paperclip-1 bash
#   curl -fsSL https://raw.githubusercontent.com/dandacompany/brand-intelligence-lab/master/scripts/setup.sh | bash
#
# 또는 단테 사용자가 본인 sudo 권한으로:
#   sudo bash scripts/setup.sh

set -euo pipefail

echo "════════════════════════════════════════════════════════════════"
echo " Brand Intelligence Lab — 컨테이너 셋업"
echo "════════════════════════════════════════════════════════════════"
echo ""

# ─── 0. 권한 점검 ────────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
  echo "⚠️  이 스크립트는 root 권한이 필요합니다 (apt-get + npm i -g)."
  echo "   docker exec -it -u root paperclip-r7b8-paperclip-1 bash 로 진입한 후 다시 실행해 주세요."
  exit 1
fi

# ─── 1. APT — Chromium 네이티브 의존성 + 폰트 + psql ────────────
echo "[1/3] APT 패키지 설치 — Marp PDF 빌드용 Chromium 의존성 + 한글 폰트 + psql..."
apt-get update -qq
apt-get install -y --no-install-recommends \
  libglib2.0-0 libnss3 libnspr4 \
  libatk1.0-0 libatk-bridge2.0-0 libatspi2.0-0 \
  libgtk-3-0 libdbus-1-3 libdrm2 libgbm1 \
  libxkbcommon0 libxss1 libxshmfence1 \
  libcups2 libxrandr2 libxcomposite1 libxdamage1 libxfixes3 libxrender1 \
  libpango-1.0-0 libcairo2 libasound2 \
  fonts-noto-cjk fonts-noto-cjk-extra \
  postgresql-client \
  ca-certificates curl

# ─── 2. NPM 글로벌 — brightdata CLI + Marp CLI ───────────────────
echo ""
echo "[2/3] NPM 글로벌 패키지 — brightdata CLI + Marp CLI..."
npm i -g @brightdata/cli @marp-team/marp-cli

echo ""
echo "  • brightdata $(brightdata --version 2>/dev/null) 설치 완료"
echo "  • marp $(marp --version 2>/dev/null | head -1) 설치 완료"

# ─── 3. Chromium 의존성 + CHROME_PATH 자동 export 자가 검증 ──────
echo ""
echo "[3/4] Chromium 의존성 자가 검증..."
CHROMIUM=$(find /paperclip/.cache/ms-playwright/chromium-*/chrome-linux64/ -maxdepth 1 -name chrome 2>/dev/null | head -1 || true)
if [[ -n "$CHROMIUM" ]]; then
  MISSING=$(ldd "$CHROMIUM" 2>/dev/null | grep "not found" || true)
  if [[ -z "$MISSING" ]]; then
    echo "  ✅ Chromium 공유 라이브러리 모두 해소"
  else
    echo "  ⚠️  미해결 의존성 발견:"
    echo "$MISSING" | sed 's/^/    /'
  fi
else
  echo "  (chromium 캐시가 아직 없음 — marp 첫 실행 시 playwright 가 자동 다운로드)"
  CHROMIUM="/paperclip/.cache/ms-playwright/chromium-1223/chrome-linux64/chrome"
fi

# ─── 4. CHROME_PATH 환경변수 영속 (marp 가 자동 인식) ────────────
echo ""
echo "[4/4] CHROME_PATH 환경변수 영속 (node 사용자 ~/.bashrc) + 폰트 캐시 재구성..."
NODE_HOME="/paperclip"
PROFILE="$NODE_HOME/.bashrc"
if ! grep -q "CHROME_PATH=$CHROMIUM" "$PROFILE" 2>/dev/null; then
  echo "" >> "$PROFILE"
  echo "# Marp PDF 빌드용 — Playwright 가 내장한 chromium 을 marp/puppeteer 가 자동 인식" >> "$PROFILE"
  echo "export CHROME_PATH=\"$CHROMIUM\"" >> "$PROFILE"
  echo "  ✅ ~/.bashrc 에 export CHROME_PATH 추가"
else
  echo "  (이미 등록되어 있음)"
fi
chown node:node "$PROFILE" 2>/dev/null || true

# 폰트 캐시 재구성 (방금 설치한 fonts-noto-cjk 가 즉시 인식되도록)
fc-cache -fv >/dev/null 2>&1 || true
KOREAN_FONTS=$(fc-list :lang=ko 2>/dev/null | wc -l)
echo "  ✅ 한글 폰트 ${KOREAN_FONTS}개 인식됨 (Noto Sans/Serif CJK KR)"

# ─── 마무리 안내 ─────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════════════"
echo " ✅ 시스템 셋업 완료"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo " 다음 단계 — node 사용자 셸로 돌아가서 brightdata OAuth 인증:"
echo ""
echo "   exit                              # root 셸 종료"
echo "   docker exec -it paperclip-r7b8-paperclip-1 bash"
echo "   brightdata login --device         # 헤드리스 OAuth (브라우저 URL+코드)"
echo "   brightdata zones                  # zone 자동 생성 확인"
echo ""
echo " 그 다음:"
echo "   1. paperclipai company import https://github.com/dandacompany/brand-intelligence-lab --ref master --yes"
echo "   2. §3 의 Goal 트리 4개 등록 (콘솔 또는 API)"
echo "   3. 브랜드 리서처 Skills 탭에서 6종 체크"
echo "   4. CEO 부트스트랩 이슈 발행 (issue-templates/ceo-bootstrap.md)"
echo ""
