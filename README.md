# 📼 작은  영화관  (Pocket Theater)
> ### 나야, 네 손 안에 작은 영화관 😉🍿

<br />

## 프로젝트 소개
> **개발 기간** : 2024. 10. 04 (금) ~ 2024. 10. 14 (월)<br />
> **개발 인원** : 3인<br />
> **최소 버전** : iOS 15.0+<br />

<br />

<div align="center">
  <img width="19%" src="https://github.com/user-attachments/assets/dff42df6-bd86-4a81-bdda-f6f369c87380" />
  <img width="19%" src="https://github.com/user-attachments/assets/255c6abb-65bd-4509-92fb-0c071330193d" />
  <img width="19%" src="https://github.com/user-attachments/assets/16f3642c-b0b2-48e6-b76e-6d7206422381" />
  <img width="19%" src="https://github.com/user-attachments/assets/0a1e0973-72c5-4a98-b882-158c06e685dc" />
  <img width="19%" src="https://github.com/user-attachments/assets/99cf9275-7b2f-49dc-8ff5-f40278f43cec" />
</div>

<br /><br />

| **[김윤우](https://github.com/yoonwooiOS)** | **[김준희](https://github.com/dev-junehee)** | **[소정섭](https://github.com/wjdtjq6)** |
| :-: | :-: | :-: |
| <a href="https://github.com/dev-junehee"><img src="https://avatars.githubusercontent.com/u/170070172?v=4" width=200px alt="김준희" /> | <a href="https://github.com/dev-junehee"><img src="https://avatars.githubusercontent.com/u/116873887?v=4" width=200px alt="김준희" /> | <a href="https://github.com/dev-junehee"><img src="https://avatars.githubusercontent.com/u/71679088?v=4" width=200px alt="김준희" /> |
| 프로젝트 초기 세팅<br />공용 컴포넌트<br />검색 탭 | 좋아요 탭<br />미디어 상세 화면 | 홈 탭<br />네트워크 통신 로직<br />커스텀 Alert |

<br />

## 사용 기술 및 개발 환경
- **iOS** : Swift 5, Xcode 15.3, UIKit
- **UI** : Codebase UI, SnapKit, Then
- **Architecture** : MVVM (Input-Output)
- **Reactive** : RxSwift, RxDataSource, RxTapGesture
- **Network** : URLSession (Swift Concurrency)
- **Local DB** : Realm

<br />

## 주요 기능
### TMDB API를 활용한 인기 미디어(영화/시리즈) 조회 및 검색 기능
-  throttle/distinctUntilChanged Operator를 활용한 실시간 검색 적용 및 중복 검색 예외 처리
- flatMap, combineLatest Operator를 활용해 출연진/비슷한 콘텐츠 API 응답값을 조합한 미디어 상세 정보 조회 기능 구현
- Swift Concurrency Async-Await, Task 기반의 비동기 네트워크 통신 구현

### Realm DB를 활용한 미디어 좋아요 기능
- Repository Pattern을 사용해 일관된 인터페이스로 미디어 좋아요 관련 기능 처리
- Auto Refresh 기능으로 미디어 좋아요 상태 실시간으로 반영, 사용자 액션에 따라 상태 업데이트
- 각 미디어 ID와 사용자의 좋아요 여부를 Realm DB에 저장하여, 앱 재시작 시에도 좋아요 상태를 유지

<br />

## 브랜치 전략
### 간소화된 Git Flow 및 Branch Protect 도입
- **`main`**
  - 실제 서비스 배포용 브랜치
  - 최소 2명의 Approve가 있어야 Merge 가능
- **`dev`**
  - 개발 작업용 브랜치 (Main 브랜치에서 분기)
  - 최소 1명의 Approve가 있어야 Merge 가능
- **`feat`** , **`design`**, **`fix`**...
  - 기능 단위 브랜치 (dev 브랜치에서 분기)
  - 대표 작업 단위 브랜치로 Issue, Commit 컨벤션과 동일한 Prefix 사용하여 작업 구분
- 각 브랜치별 작업 내용과 개발자 확인을 위해 브랜치명 컨벤션 도입
  - prefix/개발자명/이슈번호-작업설명
  - `feat/junehee/11-media-detail`

<br />

| Prefix  | Description | Prefix  | Description | 
|------------|-----------|------------|-----------|
| Feat | 새로운 기능에 대한 커밋 | Style | UI 스타일에 관한 커밋 |
| Fix | 버그 수정에 대한 커밋 | Refactor | 코드 리팩토링에 대한 커밋 |
| Build | 빌드 관련 파일 수정에 대한 커밋 | Test | 테스트 코드 수정에 대한 커밋 |
| Chore | 그 외 자잘한 수정에 대한 커밋 | Init | 프로젝트 시작에 대한 커밋 |
| Ci | CI 관련 설정 수정에 대한 커밋 | Release | 릴리즈에 대한 커밋 |
| Docs | 문서 수정에 대한 커밋 | WIP | 미완성 작업에 대한 임시 커밋 |

<br />

## 트러블 슈팅
### 1. 페이지네이션 구현 시, 사용자가 빠르게 스크롤하면 동일한 데이터가 중복 요청
-  중복 요청을 방지하고 데이터 로드를 정확한 시점에 수행하기 위해 isFetching, hasMorePages Flag 변수를 사용하여 상태 관리
    
### 2. 미디어 상세 화면에서 ScrollView 활용 시 기기별 Height 값을 대응해야 하는 이슈
- 프로젝트 초반의 미디어 상세 화면은 ScrollView 위에 상세 정보를 담는 뷰 객체들과 비슷한 콘텐츠를 노출하는 SimilarCollectionView로 구성
- 하지만 SimilarCollectionView에 담기는 데이터 수가 일정하지 않고, layout 구성 시 UICollecionViewCompositinalLayout을 사용하여 기기별 Cell Size가 달라 ScrollView 대응을 위한 Height 값을 지정할 수 없는 문제가 발생
- RxDataSource 라이브러리를 활용해 ScrollView 대신 CollectionView를 기반으로 SectionModelType 프로토콜을 구현하여 각 섹션 별로 정의된 데이터 모델을 사용해 화면 재구성

<br />

## 회고
### Keep (좋았던 점)
#### 1. 템플릿을 활용한 Issue, Pull Request 관리 및 다한 컨벤션 도입
- 개발 진행 현황과 프로젝트 관리를 위해 Issue, Pull Request 템플릿을 도입하여 프로젝트 이슈와 PR을 관리하고 문서화하여 효율적인 협업이 될 수 있도록 노력하였습니다.
- 원활한 협업을 위해 코드, 브랜치, 커밋 등에 다양한 컨벤션을 적용하여 일관성 있는 프로젝트가 될 수 있도록 하였습니다.

#### 2. 이전에 사용해보지 않았던 RxDataSource 라이브러리 도입
- 미디어 상세 화면에서 다양한 정보를 보여주기 위해 CollectionView에 다중 섹션이 필요하였고, RxSwift를 채택한 프로젝트였기 때문에 프로젝트 전반에 걸쳐 일관된 코드 구조를 위해 RxDateSource도 함께 적용하였습니다.


### Problem (아쉬웠던 점)
#### 1. 프로젝트 초기 세팅 시 협업에 대한 다양한 케이스를 고려하지 못한 점
- 공통 컴포넌트와 네트워크 로직을 각각 한 사람이 담당하면서 프로젝트 전반의 다양한 케이스를 고려하지 못해, 이후 기능 작업 중 수정사항이 다수 발생하여 초기 세팅 단계에서 더 세부적인 고려가 필요했습니다.

#### 2. Pull Request(PR) 코드 리뷰가 부족했던 점
- Pull Request를 통해 변경 사항을 dev 브랜치에 반영 시, 변경된 코드에 대한 팀원들의 다양한 피드백을 수용하기보다 단순히 PR을 올리고 Approve하는 과정 자체에만 집중된 거 같아 아쉬웠습니다.
    
#### 3. 새로운 라이브러리(RxDataSource) 도입 후 프로젝트 완성도와 진행도가 다소 떨어진 점
- RxDataSource 라이브러리에 대한 러닝커브가 예상보다 높아 프로젝트 초반 진행 속도가 예상보다 늦어지고 전반적인 완성도가 떨어진 점이 아쉬웠습니다. 

### Try (앞으로 시도해볼 점)
- 데일리 스크럼을 통해 팀원별 진행 상황 공유하고 보다 효율적인 커뮤니케이션 시도
- 기능 작업 단위를 작게 가져가면서 PR에 대한 팀원간의 원활한 상호 코드리뷰 진행
- 완성도가 중요한 프로젝트에서는 새로운 기술을 일정 시간 내에 시도해보고, 기대한 성과가 나오지 않으면 과감하게 포기하는 결단력이 필요했지만, 이번 프로젝트에서는 그런 결단력이 부족해 진행 속도와 완성도에 영향을 미쳤습니다. (도전적인 프로젝트에서는 다양한 기술을 적용해보는 것도 의미 있다고 생각합니다!)