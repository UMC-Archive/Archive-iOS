import UIKit

class RecommendView: UIView {
    
    private let albumInfoView = AlbumInfoView()
    
    
    
    lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "aespa") // 앨범 이미지
        return imageView
    }()
    
    lazy var songTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Title"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist Name"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    lazy var overlappingSquaresView = UIImageView().then { make in
        make.image = UIImage(systemName: "rectangle.on.rectangle")
        make.tintColor = .white
        make.contentMode = .scaleAspectFit
    }
    // 하단 선분
    lazy var bottomLine = UIView().then { make in
        make.backgroundColor = .gray
    }
    
    // 컬렉션 뷰
    lazy var RecommendCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    
    
    
    // 제목 레이블
    private lazy var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "당신을 위한 앨범 추천"
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textColor = .white
        return label
    }()
    
    // 탭 바 (UISegmentedControl)
    lazy var tabBar: UISegmentedControl = {
        let items = ["다음 트랙", "가사", "추천 콘텐츠"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0 // "다음 트랙" 기본 선택
        
        // 배경 색상 및 선택된 색상 설정
        segmentedControl.backgroundColor = .black
        segmentedControl.selectedSegmentTintColor = .clear // 투명 배경
        
        // 선택된 텍스트 스타일
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white, // 선택된 텍스트 흰색
            .font: UIFont.boldSystemFont(ofSize: 16) // 굵은 텍스트
        ], for: .selected)
        
        // 선택되지 않은 텍스트 스타일
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.gray, // 선택되지 않은 텍스트 회색
            .font: UIFont.systemFont(ofSize: 16) // 기본 텍스트
        ], for: .normal)
        
        // 경계선 제거
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        return segmentedControl
    }()
    
    
    
    // 오른쪽 화살표 버튼
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(">", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    lazy var albumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // 세로 스크롤
        layout.minimumLineSpacing = 10 // 셀 간 간격
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 60) // 셀 크기
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black // 배경색 설정
        collectionView.showsVerticalScrollIndicator = false // 세로 스크롤바 숨김
        return collectionView
    }()

    // 앨범 컬렉션 뷰 2 여기 아직 수정 바람
    lazy var albumRecommendCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal // 수평 스크롤
                layout.itemSize = CGSize(width: 120, height: 160) // 카드 크기
                layout.minimumLineSpacing = 10 // 카드 간 간격
                layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // 컬렉션 뷰 여백
                
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                collectionView.backgroundColor = .clear
                collectionView.showsHorizontalScrollIndicator = false
                return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let scrollView = UIScrollView()
    let contentView = UIView()
    private func setupViews() {
        backgroundColor = .black

        // ScrollView와 ContentView 추가
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // ContentView에 뷰 추가
        contentView.addSubview(albumInfoView)
        contentView.addSubview(bottomLine)
        contentView.addSubview(tabBar)
        contentView.addSubview(albumCollectionView)
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(seeMoreButton)
        contentView.addSubview(albumRecommendCollectionView)
    }

    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
           }
           contentView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
               make.width.equalToSuperview()
           }

           // ContentView에 추가된 뷰들의 제약 조건 설정
           albumInfoView.snp.makeConstraints { make in
               make.top.equalTo(contentView).offset(20)
               make.leading.trailing.equalToSuperview().inset(16)
               make.height.equalTo(70)
           }
        bottomLine.snp.makeConstraints{make in
            make.top.equalTo(albumInfoView.snp.bottom).offset(10)
            make.height.equalTo(1) // 선의 두께
            make.leading.trailing.equalToSuperview()
        }
        tabBar.snp.makeConstraints{make in
            make.top.equalTo(albumInfoView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        albumCollectionView.snp.makeConstraints{make in
            make.top.equalTo(tabBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        // 여기까지는 보임
        sectionTitleLabel.snp.makeConstraints{make in
            make.top.equalTo(albumCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            
        }
        seeMoreButton.snp.makeConstraints{make in
            make.top.equalTo(albumCollectionView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        albumRecommendCollectionView.snp.makeConstraints{make in
            make.top.equalTo(sectionTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(sectionTitleLabel)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(250)
        }
        
        
    }
    
    func configure(
        albumImage: UIImage?,
        songTitle: String,
        artistName: String
    ) {
        // AlbumInfoView를 업데이트
        albumInfoView.configure(
            albumImage: albumImage,
            songTitle: songTitle,
            artistName: artistName
        )
    }
}

