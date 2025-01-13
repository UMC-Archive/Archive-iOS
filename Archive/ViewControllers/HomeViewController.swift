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
    private let archiveData = MusicDummyModel.dummy()
    private let pointData = PointOfViewDummyModel.dummy()
    private let fastSelectionData = MusicDummyModel.dummy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = homeView
        setDataSource()
        setSnapShot()
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: homeView.collectionView, cellProvider: {collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .ArchiveItem(let item): // 아카이브
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigBannerCell.id, for: indexPath)
                (cell as? BigBannerCell)?.config(album: item)
                return cell
            case .PointItem(let item): // 탐색했던 시점
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PointOfViewCell.id, for: indexPath)
                (cell as? PointOfViewCell)?.config(data: item)
                return cell
            case .FastSelectionItem(let item): // 빠른 선곡 / 최근 들은 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.config(data: item)
                return cell
            case .RecommendMusicItem(let item): // 추천곡 / 최근 추가 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.config(data: item)
                return cell
            default:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            switch section {
            case .BigBanner(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .PointOfView(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .Banner(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .Vertical(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        }
    }
    
    private func setSnapShot() {
        // 스냅샷 생성
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // 섹션 정의
        let archiveSection = Section.BigBanner(.Archive) // 당신을 위한 아카이브 섹션
        let pointOfViewSection = Section.PointOfView(.PointOfView) // 탐색했던 시점
        let fastSelectionSection = Section.Banner(.FastSelection) // 빠른 선곡
        let recommendSection = Section.Vertical(.RecommendMusic) // 당신을 위한 추천곡
        
        
        // 섹션 추가
        snapshot.appendSections([archiveSection, pointOfViewSection, fastSelectionSection,
                                 recommendSection])
        
        let archiveItem = archiveData.map{Item.ArchiveItem($0)}
        snapshot.appendItems(archiveItem, toSection: archiveSection)
        
        let pointItem = pointData.map{Item.PointItem($0)}
        snapshot.appendItems(pointItem, toSection: pointOfViewSection)
        
        let fastSelectionItem = fastSelectionData.map{Item.FastSelectionItem($0)}
        snapshot.appendItems(fastSelectionItem, toSection: fastSelectionSection)

        let recommendItem = archiveData.map{Item.RecommendMusicItem($0)}
        snapshot.appendItems(recommendItem, toSection: recommendSection)
        
        dataSource?.apply(snapshot)
    }
}
