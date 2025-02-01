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
                DispatchQueue.main.async {
                    print("Login Failed: \(error.localizedDescription)")
                    self?.showAlert(title: "Login Failed", message: error.localizedDescription)
                }
            }
        }
    }

    private func navigateToNextScreen() {
        // 로그인 성공 시 이동할 화면 여기를 다른거로 이으면 돼요
        //navigationController?.pushViewController(nextVC, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

