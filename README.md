# 사이사이 (Saisai)

남은 시간과 취향을 기준으로, 목적지로 가는 길에 들를 수 있는 관광지를 추천하는 Flutter Golden Path 프로토타입입니다. 내일 기술 컨설팅에서는 아래 흐름을 처음부터 끝까지 시연하는 것을 목표로 합니다.

`출발/도착 입력 → 남은 시간 → 여행 취향 → 추천 후보 → 장소 상세 → 코스 결과`

## 실행

Flutter 3.22 이상과 Dart 3.3 이상을 준비한 뒤, 프로젝트 루트에서 실행합니다.

```bash
# 이 저장소를 처음 받은 경우: Android/iOS/Web 플랫폼 파일 생성
flutter create .

flutter pub get
flutter run
```

지도 키 없이도 mock 지도로 실행됩니다. 네이버 지도 Client ID를 전달하면 실제 지도로 자동 전환되며, 후보 필터와 코스 계산은 실제로 동작합니다.

### 네이버 지도 연결

네이버 클라우드 콘솔에서 `Mobile Dynamic Map`을 신청하고 다음 앱 정보를 등록합니다.

- Android 패키지: `com.example.saisai`
- iOS Bundle ID: `com.example.saisai`

발급받은 Client ID는 저장소에 적지 않고 실행 시 전달합니다.

```bash
flutter run --dart-define=NAVER_MAP_CLIENT_ID=발급받은_CLIENT_ID
```

키가 없거나 인증이 실패하면 앱 전체가 중단되지 않고 코드 기반 mock 지도를 사용할 수 있습니다.

## 구조

```text
lib/
  app/                  # 앱 조립, go_router (공통 소유)
  core/                 # theme, 공통 UI (공통 소유)
  models/               # 화면 간 데이터 계약 (공통 소유)
  data/                 # MockRepository (공통 소유)
  services/             # 시간 제약 필터 및 코스 생성
  features/
    search_flow/        # 시작~취향 선택
    course_flow/        # 후보~장소 상세~결과
    placeholders/       # 마이/경로 기록 임시 화면
```

## 2인 브랜치 전략

하루짜리 프로토타입은 `main`과 두 feature 브랜치만 사용합니다. `develop` 브랜치는 만들지 않습니다.

```text
main
├── feature/search-flow  # 담당 A: 시작, 출발/도착, 시간/카테고리
└── feature/course-flow  # 담당 B: 후보, 장소 상세, 코스 결과
```

1. 공통 골격을 `main`에 먼저 반영하고 두 브랜치를 만듭니다.
2. 각 기능은 자기 `features/` 하위에서만 수정합니다.
3. `app/router.dart`, `core/`, `models/`, `data/`는 충돌 위험이 높으므로 수정 전 상대에게 알립니다.
4. 화면 연결은 `SearchCondition`, `CandidatePlace`, `CoursePlan` 계약을 사용합니다. 모델 필드 변경은 반드시 먼저 합의합니다.
5. 기능 하나가 끝날 때마다 `main`으로 작은 단위로 병합하고, 병합 직후 Golden Path를 한 번 실행합니다.

## 역할 분담

| 담당 | 범위 | 주 파일 |
| --- | --- | --- |
| A | 시작, 출발/도착, 남은 시간, 카테고리 | `features/search_flow/` |
| B | 추천 후보, 장소 상세, 코스 결과 | `features/course_flow/` |
| 공동 | 모델, mock 데이터, 라우팅, theme | 병합 전 합의 |

## 데모 데이터와 로직

`MockTourRepository`가 서울역 주변의 관광지 후보를 제공합니다. `CoursePlanner`는 `체류 시간 + 우회 시간`이 남은 시간보다 작은 후보만 노출하고, 추천 점수 대비 시간 효율이 높은 순서로 코스를 만듭니다. 실제 관광 API로 전환할 때는 repository 구현만 교체하면 됩니다.
