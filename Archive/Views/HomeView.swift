//
//  HomeView.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class HomeView: UIView {
    // 상단 뷰
    public let topView = TopView(type: .home)
    
    // 모던 컬렉션뷰
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then { view in
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        
        // 헤더 등록
        view.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        
        // 셀 등록
        view.register(BigBannerCell.self, forCellWithReuseIdentifier: BigBannerCell.id)
        view.register(PointOfViewCell.self, forCellWithReuseIdentifier: PointOfViewCell.id)
        view.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
        view.register(VerticalCell.self, forCellWithReuseIdentifier: VerticalCell.id)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            topView,
            collectionView
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        // TopView
        topView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(33)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // 컬렉션뷰
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.bottom.trailing.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40  // 섹션 간 간격
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0: // 당신을 위한 아카이브
                return self?.createBigBannerSection()
            case 1: // 탐색했던 시점
                return self?.createPointOfViewSection()
            case 2, 4: // 빠른 선곡, 최근 들은 노래
                return self?.createBannerSection()
            case 3, 5 : // 추천 곡, 최근 추가 노래
                return self?.createVerticalSection()
            default:
                return self?.createBigBannerSection()
            }
        }, configuration: config)
    }
    
    // 당신을 위한 아카이브
    private func createBigBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(264))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let header = createHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 탐색했던 시점
    private func createPointOfViewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let header = createHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 빠른 선곡 / 최근 들은 노래
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
    
    // 추천곡 / 최근 추가 노래
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(317), heightDimension: .absolute(275))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 4)
        
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
        
        return header
    }
}
