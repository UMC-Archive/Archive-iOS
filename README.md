# Front
Front

Branch Convention
작업 브랜치 생성
기능 개발: [feature/#이슈번호]-title
ex) [feature/#32]-title
버그 수정: [fix/#이슈번호]-title
ex) [fix/#32]-login
리팩토링: [refactor/#이슈번호]-title
ex) [refactor/#32]-login

-----------------------------------------------
Issue Convention
Feature: 기능 추가 시 작성
Issue: ✅ Feature
내용: 작업하고자 하는 기능을 입력
TODO:
 구현 내용 입력
ETC: 논의가 필요한 사항이나 참고 내용 작성
Fix/Bug: 오류/버그 발생 시 작성
Issue: 🐞 Fix / Bug
내용: 발생한 문제 설명
원인 파악
해결 방안
결과 확인
ETC: 논의할 사항 작성
Refactor: 리팩토링 작업 시 작성
Issue: ♻️ Refactor
내용: 리팩토링이 필요한 부분 작성
Before: 변경 전 상태 및 이유 설명
After: 변경 후 예상되는 구조 설명
TODO:
 변경 내용 입력
ETC: 논의할 사항 작성

-----------------------------------------------------
PR Convention
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

PR에 대해 추가적으로 논의하거나 참고해야 할 내용을 작성해주세요. 
(예: 변경사항이 코드베이스에 미치는 영향, 테스트 방법 등)

-----------------------------------------------------------
COMMIT Convention
feature : 새로운 기능이 추가되는 경우
fix : bug가 수정되는 경우
docs : 문서에 변경 사항이 있는 경우
style : 코드 스타일 변경하는 경우 (공백 제거 등)
refactor : 코드 리팩토링하는 경우 (기능 변경 없이 구조 개선)
design : UI 디자인을 변경하는 경우
// Format
[[Type]/#[이슈 번호]]: [Description]

// Example
[feature/#1]: 로그인 기능 구현
[fix/#32]: 로그인 api 오류 수정
-----------------------------------------

📁 Foldering Convention 📁
📦Blism
┣ 📂App                    # 앱의 진입점 (AppDelegate, SceneDelegate)
┣ 📂Models                 # 데이터 모델 폴더
┣ 📂Views                  # UI 레이아웃 폴더
┣ 📂ViewControllers        # ViewController 폴더
┣ 📂Network                # 네트워크 통신 폴더
┣ 📂Service                # 서비스 계층 (Keychain 관리 등)
┃ ┗ 📂Keychain             # Keychain 관리
┣ 📂Extension              # Extension 파일 관리
┗ 📂Font                   # Font 파일 관리
