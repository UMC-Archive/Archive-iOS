//
//  HomeViewController.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let dummyData = MusicDummyModel.dummy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = homeView
        setDataSource()
        setSnapShot()
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: homeView.collectionView, cellProvider: {collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .musicItem(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.config(album: item)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            switch section {
            case .Banner(let headerTitle):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
                return headerView
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let bannerSection = Section.Banner(.Banner)
        snapshot.appendSections([bannerSection])
        
        let bannerItem = dummyData.map{Item.musicItem($0)}
        snapshot.appendItems(bannerItem, toSection: bannerSection)
        
        dataSource?.apply(snapshot)
    }
}
