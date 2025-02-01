import UIKit
import Foundation

class PreferGenreView: UIView {

    // 검색 바
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "장르 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // 회원가입 타이틀
    lazy var title = UILabel().then { make in
        make.textColor = .white
        make.text = "회원가입"
        make.font = UIFont.boldSystemFont(ofSize: 18)
        make.textAlignment = .center
    }
    
    // 오른쪽 화살표 버튼
    lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // 왼쪽 화살표 버튼
    lazy var leftArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
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
            dot.backgroundColor = i == 3 ? .white : .darkGray // 네 번째 점만 흰색
            dot.layer.cornerRadius = 4 // 모서리 둥글게
            dot.snp.makeConstraints { make in
                if i == 3 {
                    make.width.equalTo(16) // 네 번째 점은 긴 점
                } else {
                    make.width.equalTo(8) // 나머지는 짧은 점
                }
                make.height.equalTo(8) // 높이는 동일
            }
            stackView.addArrangedSubview(dot)
        }
        return stackView
    }()
    
    // 장르 선택 컬렉션 뷰
    lazy var GenreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 140) // 셀 크기
        layout.minimumInteritemSpacing = 10 // 열 간 간격
        layout.minimumLineSpacing = 10 // 행 간 간격
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 섹션 여백

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // 다음 버튼
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        button.layer.cornerRadius = 8
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(searchBar)
        addSubview(GenreCollectionView)
        addSubview(nextButton)
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        addSubview(pageIndicator)
        addSubview(title)
    }

    private func setupConstraints() {
        // 검색 바
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        // 장르 선택 컬렉션 뷰
        GenreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }

        // 다음 버튼
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(50)
        }

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
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
        }
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pageIndicator.snp.bottom).offset(8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

