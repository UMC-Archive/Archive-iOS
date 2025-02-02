import UIKit
import SnapKit
import Then

class RegisterView: UIView {

    // 회원가입 타이틀
    lazy var titleLabel = UILabel().then { make in
        make.textColor = .white
        make.text = "회원가입"
        make.font = UIFont.boldSystemFont(ofSize: 18)
        make.textAlignment = .center
    }
    lazy var leftArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        return button
    }()
    // 오른쪽 화살표 버튼
    lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        return button
    }()
    // 페이지 인디케이터
    lazy var pageIndicator: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8

        for i in 0..<5 {
            let dot = UIView()
            dot.backgroundColor = i == 0 ? .white : .darkGray
            dot.layer.cornerRadius = i == 0 ? 4 : 4
            dot.snp.makeConstraints { make in
                if i == 0 {
                    make.width.equalTo(16) // 현재 위치를 나타내는 긴 점
                } else {
                    make.width.equalTo(8)
                }
                make.height.equalTo(8)
            }
            stackView.addArrangedSubview(dot)
        }
        return stackView
    }()

    // 이메일 입력 섹션
    lazy var instructionLabel = UILabel().then { make in
        make.textColor = .white
        make.text = "이메일 주소를 입력해주세요"
        make.font = UIFont.boldSystemFont(ofSize: 21)
        make.textAlignment = .center
    }

    lazy var emailField = UITextField().then { make in
        make.placeholder = "이메일"
        make.borderStyle = .roundedRect
        make.font = UIFont.systemFont(ofSize: 16)
        make.backgroundColor = UIColor(white: 0.2, alpha: 1)
        make.textColor = .white
        make.attributedPlaceholder = NSAttributedString(
            string: "이메일",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
    }

    lazy var errorLabel = UILabel().then { make in
        make.textColor = .red
        make.font = UIFont.systemFont(ofSize: 14)
        make.text = "올바르지 않은 형식의 이메일입니다."
        make.isHidden = true
    }

    lazy var successLabel = UILabel().then { make in
        make.textColor = .green
        make.font = UIFont.systemFont(ofSize: 14)
        make.text = "올바른 형식의 이메일입니다."
        make.isHidden = true
    }

    lazy var emailButton = UIButton().then { make in
        make.setTitle("인증메일 받기", for: .normal)
        make.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        make.setTitleColor(.white, for: .normal)
        make.backgroundColor = .darkGray
        make.layer.cornerRadius = 8
    }

    // 인증번호 입력 섹션
    lazy var authCodeLabel = UILabel().then { make in
        make.text = "이메일 인증번호를 입력해주세요"
        make.font = UIFont.boldSystemFont(ofSize: 21)
        make.textColor = .white
        make.isHidden = true
    }

    lazy var authCodeField = UITextField().then { make in
        make.placeholder = "인증번호"
        make.borderStyle = .roundedRect
        make.font = UIFont.systemFont(ofSize: 16)
        make.backgroundColor = UIColor(white: 0.2, alpha: 1)
        make.textColor = .white
        make.attributedPlaceholder = NSAttributedString(
            string: "인증번호",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        make.isHidden = true
    }

    lazy var authErrorLabel = UILabel().then { make in
        make.textColor = .red
        make.font = UIFont.systemFont(ofSize: 14)
        make.text = "잘못된 인증번호입니다."
        make.isHidden = true
    }

    lazy var authSuccessLabel = UILabel().then { make in
        make.textColor = .green
        make.font = UIFont.systemFont(ofSize: 14)
        make.text = "올바른 인증번호입니다."
        make.isHidden = true
    }
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(white: 0.2, alpha: 1) // 초기 비활성화 색상
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.isEnabled = false // 초기 상태에서 비활성화
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        addSubview(titleLabel)
        addSubview(pageIndicator)
        addSubview(instructionLabel)
        addSubview(emailField)
        addSubview(errorLabel)
        addSubview(successLabel)
        addSubview(emailButton)
        addSubview(authCodeLabel)
        addSubview(authCodeField)
        addSubview(authErrorLabel)
        addSubview(authSuccessLabel)
        addSubview(nextButton)
    }

    private func setupConstraints() {
     
        leftArrowButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(pageIndicator)
            make.width.height.equalTo(24)
        }
        
        rightArrowButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(pageIndicator)
            make.width.height.equalTo(24)
        }
        pageIndicator.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageIndicator.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(46)
        }

        emailField.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
            
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(8)
            make.leading.equalTo(emailField)
        }

        successLabel.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(8)
            make.leading.equalTo(emailField)
        }

        emailButton.snp.makeConstraints { make in
            make.top.equalTo(successLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(emailField.snp.width)
            
            make.height.equalTo(40)
        }

        authCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(emailButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(46)
        }

        authCodeField.snp.makeConstraints { make in
            make.top.equalTo(authCodeLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
        }

        authErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(authCodeField.snp.bottom).offset(8)
            make.leading.equalTo(authCodeField)
        }

        authSuccessLabel.snp.makeConstraints { make in
            make.top.equalTo(authCodeField.snp.bottom).offset(8)
            make.leading.equalTo(authCodeField)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
            make.height.equalTo(45)
        }
    }
}

