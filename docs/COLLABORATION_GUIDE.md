# 사이사이 협업 가이드

이 문서는 기술 컨설팅 시연을 위한 Flutter Golden Path 프로토타입을 두 명이 빠르게 나눠 개발하기 위한 기준입니다.

## 현재 구현 상태

- 출발지·목적지 입력 및 접기/펼치기 가능한 지도 하단 패널
- 남은 시간, 이동수단, 여행 카테고리 선택
- 시간 제약을 통과한 추천 후보만 노출
- 지도 후보 → 장소 상세 → 코스 결과 → 코스 진행 흐름
- 네이버 지도 Client ID가 있으면 실제 지도, 없으면 mock 지도 사용
- 관광지 데이터는 `MockTourRepository` 기준이며 TourAPI 연동은 다음 단계
- 현재 지도 경로선은 시연용 좌표로, 실제 길찾기 API 결과가 아님

## 프로젝트 받기

```bash
git clone https://github.com/MinchoLover/saisai.git
cd saisai
git switch yeun
flutter pub get
```

iOS Simulator를 열고 실행합니다.

```bash
open -a Simulator
flutter devices
flutter run -d <SIMULATOR_ID> --dart-define=NAVER_MAP_CLIENT_ID=<CLIENT_ID>
```

Client ID는 커밋하지 않고 팀 내부로만 공유합니다. Client ID 없이 실행하면 mock 지도로 화면 흐름을 개발할 수 있습니다.

## 담당 범위

| 브랜치 | 담당 | 우선 수정 위치 |
| --- | --- | --- |
| `minchan` | 검색 흐름·공통 UI·전체 연결 | `lib/features/search_flow/` |
| `yeun` | 추천 후보·장소 상세·코스 결과 | `lib/features/course_flow/` |

다음 위치는 화면 간 계약이나 앱 전체에 영향을 주므로 수정 전 서로에게 알립니다.

- `lib/app/`
- `lib/core/`
- `lib/models/`
- `lib/data/`
- `pubspec.yaml`

## 일상 작업 순서

1. 자신의 브랜치로 이동합니다.
2. 작업 전 `origin/main`의 최신 변경을 반영합니다.
3. 한 PR은 하나의 목적만 담고 작은 단위로 커밋합니다.
4. 오류 검사와 iOS Simulator Golden Path를 확인합니다.
5. 자신의 브랜치를 push하고 `main`을 대상으로 PR을 엽니다.

```bash
git switch yeun
git fetch origin
git rebase origin/main

# 작업 후
dart format lib test
flutter analyze
flutter test
git push origin yeun
```

## 커밋 컨벤션

커밋 제목은 `type: 한글 요약`으로 작성합니다.

| type | 사용 시점 | 예시 |
| --- | --- | --- |
| `feat` | 새 기능 | `feat: 관광지 후보 필터 추가` |
| `fix` | 버그 수정 | `fix: 지도 패널 드래그 오류 수정` |
| `refactor` | 동작 변경 없는 구조 개선 | `refactor: 코스 계산 로직 분리` |
| `docs` | 문서 | `docs: TourAPI 연동 방법 추가` |
| `test` | 테스트 | `test: 시간 제약 필터 케이스 추가` |
| `chore` | 설정·의존성 | `chore: Flutter 의존성 업데이트` |

## PR 전 확인

- [ ] 내 브랜치에서 작업했는가?
- [ ] API 키·개인 설정 파일을 커밋하지 않았는가?
- [ ] `dart format`, `flutter analyze`, `flutter test`를 통과했는가?
- [ ] iOS Simulator에서 변경 화면와 이전·다음 흐름을 확인했는가?
- [ ] 공통 파일을 수정했다면 상대에게 알렸는가?
- [ ] PR 본문에 변경 이유와 확인 방법을 적었는가?

## Golden Path 확인

```text
출발지·목적지
  → 남은 시간·이동수단·카테고리
  → 추천 후보
  → 장소 상세
  → 코스 결과
  → 코스 진행
```

이 흐름 중 하나라도 끊기면 머지하지 않고 PR에 재현 방법을 남깁니다.
