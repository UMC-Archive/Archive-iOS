> <img src="https://github.com/user-attachments/assets/827a0a8d-00ca-4416-8806-0116f52732fd" width="150"><br/>
> UMC 7기 데모데이 우수상작

<div align=center>

# 🍎 Archive_iOS 🍎

## 👶🏼 iOS Members 👶🏼
<img width="160px" src="https://avatars.githubusercontent.com/u/105594739?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/106726806?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/147061193?v=4"/> | 
|:-----:|:-----:|:-----:|
|[이수현 (Soo)](https://github.com/LeeeeSuHyeon)|[송재곤 (Azin)](https://github.com/worhs02)|[손현빈 (Lemon)](https://github.com/SickofU)|
|팀장 👑|팀원 👨🏻‍💻|팀원 👨🏻‍💻|
|`네트워크 레이어`<br/>`Home`<br/>`앨범 큐레이션`<br/>`Explore`<br/>`아티스트 뷰`<br/>`탭바 / 음악 재생 바`<br/>|`Library`<br/>`마이페이지`<br/>`Recap`<br/>|`온보딩`<br/>`회원가입`<br/>`로그인`<br/>`음악 재생 뷰`<br/>
</div>
<br/>

## 🎥 주요 기능 시연 영상

<table>
  <tr>
    <td align="center">회원가입</td>
    <td align="center">로그인-홈-앨범</td>
    <td align="center">홈-아티스트</td>
    <td align="center">시대별 음악 탐색</td>
    <td align="center">음악 재생</td>
    <td align="center">보관함</td>
    <td align="center">마이페이지</td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/feed0dce-0bee-474d-b317-3f6299894ea6" width="200">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/fbfa854d-329f-499d-a5c0-9ee7f93314cf" width="200">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/3777c1ba-93a2-41ff-a2e6-7a9461e96c40" width="200">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/5cd45aea-63c6-4046-9183-78018818926e" width="200">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/38d3b752-a767-42ba-a9f9-384d0482b707" width="200">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/ff59b4c3-a376-4984-a7b0-78ae3d0ff445" width="200">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/a0db3582-459b-4eaa-ba8f-d6f761e34831" width="200">
    </td>
  </tr>
</table>


## 🛠️ Development Environment 🛠️
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)

## 🥞 Stacks 🥞
| Name          | Description   |
| ------------  | ------------- |
| <img src="https://img.shields.io/badge/-UIKit-2396F3?style=flat&logo=uikit&logoColor=white"> | iOS 앱의 UI를 구축하고 사용자 인터페이스를 관리하는 기본 프레임워크.|
| <img src="https://img.shields.io/badge/-Git-F05032?style=flat&logo=git&logoColor=white"> | 분산 버전 관리 시스템으로, 코드 히스토리 관리와 협업을 효율적으로 지원.|
| <img src="https://img.shields.io/badge/-Notion-000000?style=flat&logo=notion&logoColor=white"> | 작업 관리 및 문서화를 위한 통합 협업 도구.|
| <img src="https://img.shields.io/badge/-Discord-5865F2?style=flat&logo=discord&logoColor=white"> | 팀 커뮤니케이션 및 실시간 협업을 위한 음성 및 텍스트 기반 플랫폼.|

## 📚 Libraries 📚
| Name         | Version  |  Description        |
| ------------ |  :-----: |  ------------ |
| [Then](https://github.com/devxoul/Then) | `3.0.0` | 간결하고 직관적인 방식으로 객체를 설정할 수 있게 도와준다. |
| [SnapKit](https://github.com/SnapKit/SnapKit) | `5.7.1` | Auto Layout을 코드로 작성할 때 간단하게 가독성을 높일 수 있다. |
| [Moya](https://github.com/Moya/Moya) |  `15.0.3`  | 네트워크 요청을 관리하는 데 도움을 주는 Alamofire 기반의 네트워크 추상화 라이브러리.|
| [Kingfisher](https://github.com/onevcat/Kingfisher) | `8.1.2` | URL 기반의 이미지를 효율적으로 다운로드 및 캐싱할 수 있다. |


## 💻 Convention 💻

## 🌲 Branch Convention 🌲
1. **기본 브랜치 설정**
    - main : 배포 가능한 안정적인 코드가 유지되는 브랜치
    - develop: 기본 브랜치로, 기능을 개발하는 브랜치
2. **작업 순서**
    
    1. 작업할 이슈 작성
    
    예) `#111 사용자 로그인 기능 구현`
    
    2. 작업 브랜치 생성
        - 기능 개발: `feature/#[이슈번호]-title`
            - ex) feature/#111-login
        - 버그 수정: `fix/#[이슈번호]-title`
            - ex) fix/#111-login
        - 리팩토링: `refactor/#[이슈번호]-title`
            - ex) refactor/#111-login
    3. **생성한 브랜치에서 작업 수행** 
    4. **원격 저장소에 작업 브랜치 푸시** 
    5. **Pull Request 생성**
    - `develop` 브랜치 대상으로 Pull Request 생성
    - 리뷰어의 리뷰를 받은 후 PR을 승인 받고 `develop` 브랜치에 병합 후 브랜치 삭제
---
## 🧑‍💻 Code Convention 🧑‍💻
**저희는 Swift Style Guide을 따릅니다.**

[StyleShare](https://github.com/StyleShare/swift-style-guide?tab=readme-ov-file#%EB%93%A4%EC%97%AC%EC%93%B0%EA%B8%B0-%EB%B0%8F-%EB%9D%84%EC%96%B4%EC%93%B0%EA%B8%B0)

**네이밍 규칙**

- **변수/상수**: 카멜케이스 (예: `userName`)
- **클래스/구조체**: 파스칼케이스 (예: `UserProfile`)
- **함수/메서드**: 동사로 시작하며 카멜케이스 (예: `fetchData()`)

 **코드 스타일**

- **명시적 타입 선언**: 가능하면 타입 명시 (예: `var name : String = “name”`)
- **옵셔널 처리**: `guard`나 `if let`을 사용하여 안전하게 언래핑
- **함수 파라미터**: 간결하고 직관적인 이름 사용
---
## 💬 Issue Convention 💬
1. **Feature**: 기능 추가 시 작성
    - **Issue**: ✅ Feature
    - **내용**: 작업하고자 하는 기능을 입력
    - **TODO**:
        - [ ]  구현 내용 입력
    - **ETC**: 논의가 필요한 사항이나 참고 내용 작성
2. **Fix/Bug**: 오류/버그 발생 시 작성
    - **Issue**: 🐞 Fix / Bug
    - **내용**: 발생한 문제 설명
    - **원인 파악**
    - **해결 방안**
    - **결과 확인**
    - **ETC**: 논의할 사항 작성
3. **Refactor**: 리팩토링 작업 시 작성
    - **Issue**: ♻️ Refactor
    - **내용**: 리팩토링이 필요한 부분 작성
    - **Before**: 변경 전 상태 및 이유 설명
    - **After**: 변경 후 예상되는 구조 설명
    - **TODO**:
        - [ ]  변경 내용 입력
    - **ETC**: 논의할 사항 작성
---
## 🫷 PR Convention 🫸
```markdown
**🔗 관련 이슈**

연관된 이슈 번호를 적어주세요. (예: #123)

---

**📌 PR 요약**

PR에 대한 간략한 설명을 작성해주세요.

(예: 해당 변경 사항의 목적이나 주요 내용)

---

**📑 작업 내용**

작업의 세부 내용을 작성해주세요.

1. 작업 내용 1
2. 작업 내용 2
3. 작업 내용 3

---

**스크린샷 (선택)**

---

**💡 추가 참고 사항**

PR에 대해 추가적으로 논의하거나 참고해야 할 내용을 작성해주세요. (예: 변경사항이 코드베이스에 미치는 영향, 테스트 방법 등)
```
---
## 🙏 Commit Convention 🙏

- `feature` : 새로운 기능이 추가되는 경우
- `fix` : bug가 수정되는 경우
- `docs` :  문서에 변경 사항이 있는 경우
- `style` : 코드 스타일 변경하는 경우 (공백 제거 등)
- `refactor` : 코드 리팩토링하는 경우 (기능 변경 없이 구조 개선)
- `design` : UI 디자인을 변경하는 경우

```swift
// Format
[Type]/#[이슈번호]: [Description]

// Example
feature/#1: 로그인 기능 구현
fix/#32: 로그인 api 오류 수정
```
---
## 📁 Foldering Convention 📁
```markdown
📦Archive
┣ 📂App                    # 앱의 진입점 (AppDelegate, SceneDelegate)
┣ 📂Assets                 # 이미지 등을 효율적으로 관리하는 에셋 카탈로그
┣ 📂Models                 # 데이터 모델 폴더
┣ 📂Views                  # UI 레이아웃 폴더
┣ 📂Cells                  # Cell 폴더
┣ 📂ViewControllers        # ViewController 폴더
┣ 📂Network                # 네트워크 통신 폴더
┣ 📂Service                # 서비스 계층 (Keychain 관리 등)
┃ ┗ 📂Keychain             # Keychain 관리
┣ 📂Extension              # Extension 파일 관리
┗ 📂Font                   # Font 파일 관리
```
