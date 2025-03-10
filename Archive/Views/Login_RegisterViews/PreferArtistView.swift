import UIKit
import Then

class PreferArtistView: UIView {
    lazy var leftArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        button.tintColor = .white
        return button
    }()
    lazy var progress5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress5")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var title = UILabel().then { make in
        make.textColor = .white
        make.text = "선호하는 아티스트를 선택해주세요"
        make.font = .customFont(font: .SFPro, ofSize: 18, rawValue : 700)
        make.textAlignment = .center
    }
    lazy var pageIndicator: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8

        for i in 0..<5 {
            let dot = UIView()
            dot.backgroundColor = i == 4 ? .white : .darkGray // 네 번째 점 강조
            dot.layer.cornerRadius = 4
            dot.snp.makeConstraints { make in
                make.width.equalTo(i == 4 ? 16 : 8) // 네 번째 점은 길게
                make.height.equalTo(8)
            }
            stackView.addArrangedSubview(dot)
        }
        return stackView
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "아티스트 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white_35
        searchBar.layer.cornerRadius = 8
        searchBar.clipsToBounds = true
        return searchBar
    }()

    lazy var ArtistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 140) // 셀 크기
        layout.minimumInteritemSpacing = 10 // 열 간 간격
        layout.minimumLineSpacing = 10 // 행 간 간격
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 섹션 여백

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        return button
    }()
    lazy var nextButton: UIButton = {
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
        backgroundColor = .black
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        addSubview(title)
        addSubview(progress5)
        addSubview(pageIndicator)
        addSubview(searchBar)
        addSubview(ArtistCollectionView)
        addSubview(nextButton)
    }

    private func setupConstraints() {
        leftArrowButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(title)
            make.width.height.equalTo(24)
        }
      
        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
           
            make.centerX.equalToSuperview()
            
        }
        progress5.snp.makeConstraints { make in
            make.top.equalTo(leftArrowButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
      
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(progress5.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        ArtistCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(nextButton.snp.top).offset(-16)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(50)
        }
    }
    func updateNextButtonState(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
        
        if isEnabled {
            nextButton.backgroundColor = UIColor(hex: "#2D2D2C")
            nextButton.setTitleColor(.white, for: .normal)
        } else {
            nextButton.backgroundColor = .clear
            nextButton.setTitleColor(UIColor(white: 1.0, alpha: 0.5), for: .normal)
            nextButton.layer.borderWidth = 1
            nextButton.layer.borderColor = UIColor(hex: "#2D2D2C")?.cgColor
        }
    }
}

