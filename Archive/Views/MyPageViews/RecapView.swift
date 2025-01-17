//
//  RecapView.swift
//  Archive
//
//  Created by 송재곤 on 1/14/25.
//

import UIKit

class RecapView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ScrollView 정의
    public var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = UIColor.black_100
    }
    
    // ScrollView의 ContentView 정의
    public var contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public let genreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CarouselLayout().then{
        $0.itemSize = CGSize(width: 120, height: 120)
        $0.scrollDirection = .horizontal
    }).then{
        $0.backgroundColor = UIColor.black_100
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(GenreRecommendedCollectionViewCell.self, forCellWithReuseIdentifier: "genreRecommendedCollectionViewIdentifier")
    }
    
    // CollectionView
    public let recapCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CarouselLayout().then {
        $0.itemSize = CGSize(width: 258, height: 258)
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
    
    public var CDHoleView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.black_70
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // View 구성
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            genreCollectionView,
            recapCollectionView,
            CDView,
            CDHoleView
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    // 제약 조건 설정
    private func setConstraint() {
        // scrollView 제약 조건
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // contentView 제약 조건
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() // 가로 스크롤 방지
            $0.bottom.equalTo(recapCollectionView.snp.bottom).offset(50) // 마지막 요소의 아래로 확장
        }
        
        // CDView 제약 조건
        CDView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(71)
            $0.height.width.equalTo(258)
            $0.centerX.equalToSuperview()
        }
        
        // CDHoleView 제약 조건
        CDHoleView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(CDView)
            $0.height.width.equalTo(40)
        }
        
        // genreCollectionView 제약 조건
        genreCollectionView.snp.makeConstraints {
            $0.top.equalTo(CDView.snp.bottom).offset(20)
            $0.width.equalTo(537)
            $0.height.equalTo(364)
            $0.centerX.equalToSuperview()
        }
        
        // recapCollectionView 제약 조건
        recapCollectionView.snp.makeConstraints {
            $0.top.equalTo(genreCollectionView.snp.bottom).offset(50)
            $0.width.equalTo(537)
            $0.height.equalTo(333)
            $0.centerX.equalToSuperview()
        }
        
    }
}
