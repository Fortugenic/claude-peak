[English](README.md)

# Claude Peak

Claude Max 사용량 한도를 모니터링하는 macOS 메뉴바 앱 — 토큰을 소모할수록 더 뜨겁게 타오르는 실시간 불꽃 애니메이션.

## Screenshots

<p align="center">
  <img src="assets/demo.gif" alt="Claude Peak demo" width="300">
</p>

<p align="center">
  <img src="assets/screenshot-usage.png" alt="Claude Peak usage" width="300">
  <img src="assets/screenshot-settings.png" alt="Claude Peak settings" width="300">
</p>

메뉴바에 현재 5-hour 사용률(%)과 reset 남은 시간이 표시되며, 클릭하면 상세 사용량을 확인할 수 있다.
토큰을 사용 중이면 불꽃 아이콘이 활동량에 따라 애니메이션된다.

## Why Claude Peak?

| | |
|---|---|
| 🔥 **실시간 불꽃 애니메이션** | JSONL 토큰 로그를 실시간 모니터링하는 유일한 앱 — tps가 올라갈수록 불꽃이 거세짐 |
| 🎮 **MADMAX 모드** | *"Pathetic"* 부터 *"WITNESS ME"* 까지 — 게이미피케이션 챌린지 |
| 🔐 **원클릭 OAuth** | 세션키 복사 불필요, DevTools 불필요 — 브라우저 로그인만으로 완료 |
| ⚡ **Pure Swift** | Electron 없음, 외부 의존성 zero, SPM으로 8개 소스 파일 |

## MADMAX Challenge

MADMAX 모드를 켜고 토큰 처리량의 한계를 밀어봐. 불꽃 단계마다 새로운 도전 메시지가 해금된다:

| 불꽃 | tps | 메시지 |
|------|-----|--------|
| 🔥 × 0 | 0 | *Light it up. If you can.* |
| 🔥 × 1–2 | 1 – 19,999 | *That's it? Pathetic.* |
| 🔥 × 3–4 | 20,000 – 39,999 | *Warming up...* |
| 🔥 × 5–6 | 40,000 – 59,999 | *Now we're cooking.* |
| 🔥 × 7–8 | 60,000 – 79,999 | *FEEL THE BURN* |
| 🔥 × 9 | 80,000 – 89,999 | *ONE MORE. DO IT.* |
| 🔥 × 10 | 90,000+ | ***WITNESS ME*** |

> **불꽃 10개 찍을 수 있어?** 대부분은 *"That's it? Pathetic."* 에서 멈춘다.

### 불꽃 모드

설정에서 네 가지 모드 선택 가능:

- **Off** — 불꽃 아이콘 없음
- **1** — 고정 1개, 토큰 활동 시 애니메이션만
- **3** (기본) — tps에 따라 1~3개 유동
- **MADMAX** — tps에 따라 1~10개 유동 (10,000 tps당 불꽃 1개)

<details>
<summary>Dynamic (3) 모드 — 애니메이션 속도 테이블</summary>

| tps | 불꽃 | 애니메이션 속도 |
|-----|------|----------------|
| 0 | 🔥 (작은 불씨, 정적) | 없음 |
| 0 – 30,000 | 🔥 × 1 | 0.50초 → 0.20초 |
| 30,000 – 60,000 | 🔥 × 2 | 0.30초 → 0.15초 |
| 60,000+ | 🔥 × 3 | 0.20초 → 0.08초 |

</details>

<details>
<summary>MADMAX 모드 — 애니메이션 속도 테이블</summary>

| tps | 불꽃 | 애니메이션 속도 |
|-----|------|----------------|
| 0 | 🔥 (작은 불씨, 정적) | 없음 |
| 1 – 9,999 | 🔥 × 1 | 0.40초 |
| 10,000 – 19,999 | 🔥 × 2 | ↓ |
| ... | ... | ↓ |
| 90,000+ | 🔥 × 10 | 0.06초 |

</details>

## 기능

- **실시간 불꽃 애니메이션** — `~/.claude/projects/` JSONL 로그를 감시, 토큰 처리량에 따라 불꽃 애니메이션
- **메뉴바 표시** — 5-hour utilization %, reset 남은 시간 (설정 가능)
- **상세 Popover** — 5-hour, 7-day(All models), 7-day(Sonnet) 사용량 + reset 타이머
- **설정** — 표시 형식, 갱신 주기 (1/5/10분), 불꽃 모드
- **OAuth PKCE** — 브라우저 기반 인증, 자동 토큰 갱신

## 설치

### Homebrew (추천)

```bash
brew tap letsur-dev/claude-peak https://github.com/letsur-dev/claude-peak.git
brew install claude-peak

# 실행 (첫 실행 시 ~/Applications에 자동 링크)
claude-peak
```

### 소스에서 빌드

```bash
git clone https://github.com/letsur-dev/claude-peak.git
cd claude-peak
./build.sh

# 실행
open ~/Applications/Claude\ Peak.app
```

## Tech Details

<details>
<summary>인증 플로우</summary>

첫 실행 시 "Login with Claude" 버튼 → 브라우저에서 Claude 계정 로그인 → 자동 토큰 저장.

1. 앱이 로컬 HTTP 서버 시작 (랜덤 포트, IPv6)
2. 브라우저로 `claude.ai/oauth/authorize` 열기 (PKCE code_challenge 포함)
3. 사용자 인증 후 `http://localhost:PORT/callback?code=xxx`로 리다이렉트
4. 앱이 code를 받아 `platform.claude.com/v1/oauth/token`에서 토큰 교환
5. `~/.config/claude-peak/tokens.json`에 저장 (0600 권한)

**토큰 갱신:**
- access token 만료 5분 전 자동 refresh
- refresh 실패 시 재로그인 안내

</details>

<details>
<summary>API</summary>

### Usage 조회

```
GET https://api.anthropic.com/api/oauth/usage
Headers:
  Authorization: Bearer {access_token}
  anthropic-beta: oauth-2025-04-20
  User-Agent: claude-code/2.0.32
```

응답 예시:

```json
{
  "five_hour": { "utilization": 2.0, "resets_at": "2026-01-29T09:59:59Z" },
  "seven_day": { "utilization": 63.0, "resets_at": "2026-01-29T23:59:59Z" },
  "seven_day_sonnet": { "utilization": 0.0, "resets_at": null },
  "extra_usage": { "is_enabled": false }
}
```

- `utilization`: 0~100 (퍼센트)
- `resets_at`: ISO 8601 타임스탬프 또는 null

### Token Refresh

```
POST https://platform.claude.com/v1/oauth/token
Content-Type: application/json

{
  "grant_type": "refresh_token",
  "refresh_token": "...",
  "client_id": "9d1c250a-e61b-44d9-88ed-5944d1962f5e",
  "scope": "user:profile user:inference"
}
```

</details>

<details>
<summary>개발 과정에서 발견한 것들</summary>

- **Keychain 토큰 만료 문제**: Claude Code는 매 세션마다 브라우저 OAuth로 재인증하며, Keychain의 refresh token이 무효화될 수 있다. 따라서 앱 자체 OAuth 플로우가 필요.
- **`claude setup-token`의 한계**: inference-only 토큰(`user:inference` scope만)을 발급하므로 usage API(`user:profile` 필요)에 사용 불가.
- **OAuth redirect URI**: 반드시 `http://localhost:PORT/callback` 형식이어야 함. `127.0.0.1`이나 `/oauth/callback` 경로는 거부됨.
- **IPv6**: macOS에서 `localhost`는 `::1`(IPv6)로 해석될 수 있으므로 IPv6 소켓 필요.
- **Token exchange**: `state` 파라미터가 authorize와 token exchange 양쪽에 필요.
- **utilization 값**: API 응답의 utilization은 0~100 정수 (0~1 소수가 아님).
- **필드명**: API 응답은 `resets_at` (복수형 s).
- **JSONL 토큰 로그**: Claude Code는 `~/.claude/projects/` 아래에 세션별 JSONL 파일을 생성하며, 각 라인의 `message.usage`에 토큰 사용량이 기록됨.

</details>
