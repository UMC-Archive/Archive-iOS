import UIKit
import SnapKit

class ProfileSelectView: UIView, UITextFieldDelegate {
    public let backgroundView = UIView()
    // 회원가입 타이틀
    lazy var title = UILabel().then { make in
        make.textColor = .white
        make.text = "회원가입"
        make.font = .customFont(font: .SFPro, ofSize: 18,rawValue : 700)
        make.textAlignment = .center
    }
    lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        return button
    }()
    lazy var progress3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress3")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var leftArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        button.tintColor = .white
        return button
    }()
    // 프로필 설명 레이블
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 사진을 설정해주세요"
        label.font = .customFont(font: .SFPro, ofSize: 21,rawValue : 700)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var pageIndicator: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8

        for i in 0..<5 {
            let dot = UIView()
            dot.backgroundColor = i == 2 ? .white : .darkGray // 두 번째 점만 흰색
            dot.layer.cornerRadius = 4 // 모서리 둥글게 설정
            dot.snp.makeConstraints { make in
                if i == 2 {
                    make.width.equalTo(16) // 두 번째 점은 긴 점
                } else {
                    make.width.equalTo(8) // 나머지는 짧은 점
                }
                make.height.equalTo(8) // 높이는 동일
            }
            stackView.addArrangedSubview(dot)
        }
        return stackView
    }()
    
    // 프로필 이미지
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.image = UIImage(named: "profileSample") // 기본 아이콘
        imageView.tintColor = .lightGray
        imageView.backgroundColor = .darkGray
        imageView.isUserInteractionEnabled = true // 터치 가능
        return imageView
    }()
    private let divideLine = UIView().then{
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 0.5
    }
    // 프로필 이름 입력 필드
    lazy var profileName: UITextField = {
        let textField = UITextField()
        textField.font = .customFont(font: .SFPro, ofSize: 26,rawValue : 700)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "이름을 입력해주세요",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.customFont(font: .SFPro, ofSize: 28, rawValue: 700)
            ]
        )
        textField.borderStyle = .none
       
        return textField
    }()

    // 펜 이미지
    lazy var penImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pencil")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()

    // 완료 버튼
    lazy var completeButton: UIButton = {
       
            let button = UIButton()
            button.setTitle("다음", for: .normal)
            button.titleLabel?.font = .customFont(font: .SFPro, ofSize: 16,rawValue : 700)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(white: 0.2, alpha: 1) // 초기 비활성화 색상
            button.backgroundColor = .clear
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
        addTapGestureToProfileImage()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(backgroundView)
        addSubview(leftArrowButton)
        addSubview(title)
        addSubview(rightArrowButton)
        addSubview(pageIndicator)
        addSubview(descriptionLabel)
        addSubview(profileImage)
        addSubview(progress3)
        addSubview(profileName)
        addSubview(divideLine)
        addSubview(penImage)
        addSubview(completeButton)
    }

    private func setupConstraints() {
        backgroundView.snp.makeConstraints{
            make in
            make.edges.equalToSuperview()
        }
        leftArrowButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(title)
            make.width.height.equalTo(24)
        }
      
        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(leftArrowButton.snp.trailing).offset(8)
        }
        progress3.snp.makeConstraints { make in
            make.top.equalTo(leftArrowButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.top).offset(100)
            make.centerX.equalToSuperview()
        }

        profileImage.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }

        profileName.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        divideLine.snp.makeConstraints{
            $0.top.equalTo(profileName.snp.bottom).offset(8.5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
//            $0.width.equalTo(330)
            $0.height.equalTo(1)
        }
        penImage.snp.makeConstraints { make in
            make.centerY.equalTo(profileName) // 같은 수직선상
            make.leading.equalTo(profileName.snp.trailing).offset(8)
            make.width.height.equalTo(24)
        }

        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.equalTo(50)
        }
    }

    private func addTapGestureToProfileImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
    }

    @objc private func didTapProfileImage() {
        // ViewController에서 구현해야 함
        onProfileImageTapped?()
    }
    func updateNextButtonState(isEnabled: Bool) {
        completeButton.isEnabled = isEnabled
        
        if isEnabled {
            completeButton.backgroundColor = UIColor(hex: "#2D2D2C")
            completeButton.setTitleColor(.white, for: .normal)
        } else {
            completeButton.backgroundColor = .clear
            completeButton.setTitleColor(UIColor(white: 1.0, alpha: 0.5), for: .normal)
            completeButton.layer.borderWidth = 1
            completeButton.layer.borderColor = UIColor(hex: "#2D2D2C")?.cgColor
        }
    }

    // 클로저로 탭 이벤트 전달
    var onProfileImageTapped: (() -> Void)?
}

