//
//  DetailView.swift
//  Archive
//
//  Created by 이수현 on 1/14/25.
//

import UIKit

class DetailView: UIView {
    private let header : HeaderTitle
    private let section : Section
    public lazy var navigationBarView = NavigationBar(title: header)
    init(section: Section) {
        self.section = section
        switch section {
        case .BigBanner(let headerTitle):
            self.header = headerTitle
        case .PointOfView(let headerTitle):
            self.header = headerTitle
        case .Banner(let headerTitle):
            self.header = headerTitle
        case .Vertical(let headerTitle):
            self.header = headerTitle
        case .MusicVideoCell(let headerTitle):
            self.header = headerTitle
        case .Circle(let headerTitle):
            self.header = headerTitle
        }
        super.init(frame: .zero)
        
        self.backgroundColor = .black
        setSubView()
        setUI()
    }
    
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then { view in
        view.backgroundColor = .black
        
        view.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
        view.register(VerticalCell.self, forCellWithReuseIdentifier: VerticalCell.id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            navigationBarView,
            collectionView
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(19)
            make.height.equalTo(25)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(19)
            make.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {[weak self] _, _ in
            switch self?.section {
            case .Banner:  // 빠른 선곡, 최근 들은 노래
                self?.createBannerSection()
            case .Vertical: // 당신을 위한 추천곡, 최근 추가한 노래
                self?.createVerticalSection()
            default:
                self?.createBannerSection()
            }
        }
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(225))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    // 추천곡 / 최근 추가 노래
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(275))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
