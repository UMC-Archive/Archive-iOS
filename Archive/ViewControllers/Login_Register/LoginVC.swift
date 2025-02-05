import UIKit

class LoginVC: UIViewController {
    private let loginView = LoginView()
    private let userService = UserService() // UserService 인스턴스 추가

    override func viewDidLoad() {
        super.viewDidLoad()

        // 배경색 설정
        view.backgroundColor = .black

        // LoginView 추가
        view.addSubview(loginView)

        // Auto Layout 설정
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 버튼 액션 설정
        setupActions()
        
        
        // 음악 재생 기록 예시
        postPlayingRecord(musicId: "1")
    }

    private func setupActions() {
        // 회원가입 버튼 액션
        loginView.onRegisterButtonTapped = { [weak self] in
            self?.navigateToRegister()
        }

        // 로그인 버튼 액션
        loginView.loginButton.addTarget(self, action: #selector(handleLoginButtonTap), for: .touchUpInside)
    }

    private func navigateToRegister() {
        let registerVC = RegisterVC() // 회원가입 화면 생성
        navigationController?.pushViewController(registerVC, animated: true)
    }

    @objc private func handleLoginButtonTap() {
        guard let email = loginView.emailField.text, !email.isEmpty,
              let password = loginView.passwordField.text, !password.isEmpty else {
            // 입력값이 없을 경우 알림 표시
            showAlert(title: "Error", message: "이메일과 비밀번호를 입력해주세요.")
            return
        }

        // LoginRequestDTO 생성
        let loginParameter = LoginRequestDTO(email: email, password: password)

        // 로그인 API 호출
        userService.login(parameter: loginParameter) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("Login Success: \(response.message)")
                    // 다음 화면으로 전환
                    self?.navigateToNextScreen()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self?.present(alert, animated: true)
                print("실패: \(error.description)")
//                DispatchQueue.main.async {
//                    print("Login Failed: \(error.localizedDescription)")
//                    self?.showAlert(title: "Login Failed", message: error.localizedDescription)
//                }
            }
        }
    }

    private func navigateToNextScreen() {
        // 로그인 성공 시 이동할 화면 여기를 다른거로 이으면 돼요
        let nextVC = TabBarViewController()
        self.present(nextVC, animated: true)
        //navigationController?.pushViewController(nextVC, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // 음악 기록 API
    func postPlayingRecord(musicId: String){
        userService.playingRecord(musicId: musicId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("postPlayingRecord() 성공")
                print(response?.musicId)
                Task{
//                    LoginViewController.keychain.set(response.token, forKey: "serverAccessToken")
//                    LoginViewController.keychain.set(response.nickname, forKey: "userNickname")
//                    self.goToNextView()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
}

