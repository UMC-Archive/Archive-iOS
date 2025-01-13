//
//  HomeView.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class HomeView: UIView {
    // 상단 뷰
    private let topView = TopView(type: .home)
    
    // 모던 컬렉션뷰
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then { view in
        view.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
        view.backgroundColor = .gray
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
            case 0:
                return self?.createBannerSection()
            default:
                return self?.createBannerSection()
            }
        }, configuration: config)
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(230), heightDimension: .absolute(278))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
        
        return section
    }
}
