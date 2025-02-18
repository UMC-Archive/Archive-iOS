//
//  RecapView.swift
//  Archive
//
//  Created by 송재곤 on 1/14/25.
//

import UIKit

class RecapView: UIView {
    
    public let navigationView = NavigationBar(title: .recap)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        self.backgroundColor = .black_100
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupView()
        setConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ScrollView 정의
    public var scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    // ScrollView의 ContentView 정의
    public var contentView = UIView()
    
    public var genreInfoLabel = UILabel().then{
        $0.text = "2025 상반기 유저 닉네임님이 가장 즐겨들은 장르\n 상위 5가지로 CD를 제작했어요. "
        $0.textAlignment = .center
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 14, rawValue: 400)
        $0.textColor = .white
        $0.numberOfLines = 2
    }
    
    public let genreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CarouselLayout2().then{
        $0.itemSize = CGSize(width: 120, height: 120)
        $0.scrollDirection = .horizontal
        
    }).then{
        $0.backgroundColor = .clear /*UIColor.black_100*/
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(GenreRecommendedCollectionViewCell.self, forCellWithReuseIdentifier: "genreRecommendedCollectionViewIdentifier")
        $0.backgroundColor = .clear /*UIColor.black_100*/
        $0.showsHorizontalScrollIndicator = false
    }
    private let genreCollectionViewBackgound = UIImageView().then {
        $0.image = UIImage(named: "GenreCollectionViewBackground")
    }
    
    public var genreTasteLabel = UILabel().then{
        $0.text = "유저닉네임 님의 장르 취향은..."
        $0.textAlignment = .center
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 14, rawValue: 400)
        $0.textColor = .white
        $0.numberOfLines = 2
    }
    public var genreTasteLabel2 = UILabel().then{
        $0.text = "Dance Pop"
        $0.textAlignment = .center
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        $0.textColor = .white.withAlphaComponent(0.75)
        $0.numberOfLines = 2
    }
    
    // CollectionView
    public let recapCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CarouselLayout().then {
        $0.itemSize = CGSize(width: 258, height: 333)
        $0.scrollDirection = .horizontal
    }).then {
        $0.backgroundColor = UIColor.black_100
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(RecapCollectionViewCell.self, forCellWithReuseIdentifier: "recapCollectionViewIdentifier")
    }
    
    // CDView 및 CDHoleView
    public var CDView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 129
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // CDView 및 CDHoleView
    public var CDBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.black_70
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 45
    }
    
    public var CDHoleView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.black_70
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    public var CDInfoLabel  = UILabel().then{
        $0.text = "지수님이 올해 상반기 가장 많이 들은 음악이에요"
        $0.textAlignment = .center
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 14, rawValue: 400)
        $0.textColor = .white
        $0.numberOfLines = 2
    }
    private let headerView = UILabel().then{
        $0.text = "Recap 결산"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        $0.textColor = .white
    }
    public let headerButton = UIButton().then{
        $0.setImage(UIImage(named: "rightArrow"), for: .normal)
    }
    
    public let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.itemSize = CGSize(width: 317, height: 50)
        $0.minimumLineSpacing = 10
        $0.scrollDirection = .horizontal
    }).then{
        $0.register(MusicVerticalCell.self, forCellWithReuseIdentifier: "MusicVerticalCell")
        $0.backgroundColor = UIColor.black_100
        $0.isScrollEnabled = true
    }
    
    // View 구성
    private func setupView() {


        [
            
            genreInfoLabel,
            CDBackgroundView,
            genreCollectionViewBackgound,
            genreCollectionView,
            genreTasteLabel,
            genreTasteLabel2,
            CDView,
            CDHoleView,
            CDInfoLabel,
            recapCollectionView,
            headerView,
            headerButton,
            collectionView,
        ].forEach {
            contentView.addSubview($0)
        }

        
        [
            navigationView,
            scrollView,
            
            
        ].forEach {
           addSubview($0)
        }
        
        scrollView.addSubview(contentView)

    }
    
    // 제약 조건 설정
    private func setConstraint() {
        
        navigationView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(46)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
                
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom) // scrollView는 navigationView 아래에 위치
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(FloatingViewHeight)
        }
                
                
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView) // 가로 스크롤 방지
            $0.bottom.equalTo(collectionView.snp.bottom)
        }
        
        
        // CDView 제약 조건
        CDView.snp.makeConstraints {
            $0.height.width.equalTo(258)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(CDBackgroundView)
        }
        
        // CDHoleView 제약 조건
        CDHoleView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(CDView)
            $0.height.width.equalTo(40)
        }
        CDBackgroundView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(26)
            $0.centerX.equalTo(CDView)
            $0.width.height.equalTo(312)
        }
        
        genreInfoLabel.snp.makeConstraints{
            $0.top.equalTo(CDBackgroundView.snp.bottom).offset(46)
            $0.centerX.equalToSuperview()
        }
//        genreCollectionViewBackgound.snp.makeConstraints{
//            $0.centerX.centerY.equalTo(genreCollectionView)
//            $0.width.equalTo(423)
//            $0.height.equalTo(58)
//        }
        
        // genreCollectionView 제약 조건
        genreCollectionView.snp.makeConstraints {
            $0.top.equalTo(genreInfoLabel.snp.bottom).offset(40)
            $0.width.equalTo(300)
            $0.height.equalTo(120)
            $0.centerX.equalToSuperview()
        }
       
        genreTasteLabel.snp.makeConstraints{
            $0.top.equalTo(genreCollectionView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        genreTasteLabel2.snp.makeConstraints{
            $0.top.equalTo(genreTasteLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        CDInfoLabel.snp.makeConstraints{
            $0.top.equalTo(genreTasteLabel2.snp.bottom).offset(51)
            $0.centerX.equalToSuperview()
        }
        // recapCollectionView 제약 조건
        recapCollectionView.snp.makeConstraints {
            $0.top.equalTo(CDInfoLabel.snp.bottom).offset(40)
            $0.width.equalTo(537)
            $0.height.equalTo(333)
            $0.centerX.equalToSuperview()
//            $0.bottom.equalToSuperview()
        }
        headerView.snp.makeConstraints{
            $0.top.equalTo( recapCollectionView.snp.bottom).offset(42)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(25)
        }
        headerButton.snp.makeConstraints{
            $0.centerY.equalTo(headerView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 12, height: 20))
        }
        collectionView.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.leading.equalTo(headerView)
//            $0.width.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(317)
        }
    }
}
