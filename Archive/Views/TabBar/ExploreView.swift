//
//  ExploreView.swift
//  Archive
//
//  Created by 이수현 on 1/17/25.
//

import UIKit

class ExploreView: UIView {
    public let topView = TopView(type: .explore)
    
    // 탐색 시기
    private let timeLabel = UILabel().then { lbl in
        lbl.text = "9999년 99월 1st"
        lbl.font = .customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.sizeToFit()
    }
    
    // 탐색 설정 버튼 (재로드 버튼)
    public let resetButton = UIButton().then { btn in
        btn.setImage(.init(systemName: "gobackward"), for: .normal)
        btn.tintColor = .white_70
        btn.isUserInteractionEnabled = true
    }
    
    public let scrollView = UIScrollView().then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.scrollIndicatorInsets = .zero
    }
    
    public let contentView = UIView()
    
    // CD Recap CollectionView
    public let recapCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CarouselLayout().then {
        $0.itemSize = CGSize(width: 258, height: 333)
        $0.scrollDirection = .horizontal
    }).then {
        $0.backgroundColor = UIColor.black_100
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(RecapCollectionViewCell.self, forCellWithReuseIdentifier: RecapCollectionViewCell.recapCollectionViewIdentifier)
    }
    
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then { view in
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        // 헤더 등록
        view.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
                      
        view.register(VerticalCell.self, forCellWithReuseIdentifier: VerticalCell.id)
        view.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black_100
        
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            recapCollectionView,
            collectionView
        ].forEach{contentView.addSubview($0)}
        
        scrollView.addSubview(contentView)
        
        [
            topView,
            timeLabel,
            resetButton,
            scrollView
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        
        // topView
        topView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(33)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // timeLabel
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        // resetButton
        resetButton.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.leading.equalTo(timeLabel.snp.trailing).offset(12)
            make.width.height.equalTo(14)
        }
        
        // scrollView
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(25)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        // contentView
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0) //ExploreViewController에서 updateConstraints를 위함
        }
        
        // recap
        recapCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(537)
            make.height.equalTo(333)
            make.centerX.equalToSuperview()
        }
        
        // collectionView
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(recapCollectionView.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(FloatingViewHeight)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0, 2: // 당신을 위한 추천곡
                self?.createVerticalSection()
            case 1: // 당신을 위한 앨범 추천
                self?.createBannerSection()
            default:
                self?.createVerticalSection()
            }
        }, configuration: config)
    }
    
    
    // 당신을 위한 추천곡, 숨겨진 명곡
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(317), heightDimension: .absolute(275))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let header = createHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 당신을 위한 앨범 추천
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 14)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(186))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let header = createHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }


    // 헤더 생성
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        return header
    }
    
    // 년도 설정
    public func config(time: String) {
        self.timeLabel.text = time
    }
}
