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
    private let musicData = MusicDummyModel.dummy()
    private let pointData = PointOfViewDummyModel.dummy()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        view = homeView
        setDataSource()
        setSnapShot()
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: homeView.collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .ArchiveItem(let item): // 아카이브
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigBannerCell.id, for: indexPath)
                (cell as? BigBannerCell)?.config(album: item)
                return cell
            case .PointItem(let item): // 탐색했던 시점
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PointOfViewCell.id, for: indexPath)
                (cell as? PointOfViewCell)?.config(data: item)
                return cell
            case .FastSelectionItem(let item), .RecentlyListendMusicItem(let item):// 빠른 선곡 / 최근 들은 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                if let bannerCell = cell as? BannerCell {
                     bannerCell.configMusic(data: item)
                     let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.TapArtistLabelGesture))
                     bannerCell.artistLabel.addGestureRecognizer(tapGesture)
                 }
                return cell
            case .RecommendMusicItem(let item), .RecentlyAddMusicItem(let item): // 추천곡 / 최근 추가 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.config(data: item)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.TapArtistLabelGesture))
                (cell as? VerticalCell)?.artistYearLabel.addGestureRecognizer(tapGesture)
                return cell
            default:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self else {return UICollectionReusableView() }
            let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            // 버튼에 UIAction 추가
            (headerView as? HeaderView)?.detailButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self, let section = section else { return }
                self.handleDetailButtonTap(for: section)
            }), for: .touchUpInside)

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
    
    // 아티스트 버튼
    @objc private func TapArtistLabelGesture() {
        print("TapArtistLabelGesture")
        let nextVC = ArtistViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 자세히 보기 버튼
    private func handleDetailButtonTap(for section: Section) {
        let nextVC = DetailViewController(section: section)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setSnapShot() {
        // 스냅샷 생성
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // 섹션 정의
        let archiveSection = Section.BigBanner(.Archive) // 당신을 위한 아카이브 섹션
        let pointOfViewSection = Section.PointOfView(.PointOfView) // 탐색했던 시점
        let fastSelectionSection = Section.Banner(.FastSelection) // 빠른 선곡
        let recommendSection = Section.Vertical(.RecommendMusic) // 당신을 위한 추천곡
        let RecentlyListendMusicSection = Section.Banner(.RecentlyListendMusic) // 최근 들은 노래
        let RecentlyAddMusicSection = Section.Vertical(.RecentlyAddMusic) // 최근 추가한 노래
        
        
        // 섹션 추가
        snapshot.appendSections([archiveSection, pointOfViewSection, fastSelectionSection,
                                 recommendSection, RecentlyListendMusicSection,
                                 RecentlyAddMusicSection])
        
        let archiveItem = musicData.map{Item.ArchiveItem($0)}
        snapshot.appendItems(archiveItem, toSection: archiveSection)
        
        let pointItem = pointData.map{Item.PointItem($0)}
        snapshot.appendItems(pointItem, toSection: pointOfViewSection)
        
        let fastSelectionItem = musicData.map{Item.FastSelectionItem($0)}
        snapshot.appendItems(fastSelectionItem, toSection: fastSelectionSection)

        let recommendItem = musicData.map{Item.RecommendMusicItem($0)}
        snapshot.appendItems(recommendItem, toSection: recommendSection)
        
        let RecentlyListendMusicItem = musicData.map{Item.RecentlyListendMusicItem($0)}
        snapshot.appendItems(RecentlyListendMusicItem, toSection: RecentlyListendMusicSection)
        
        let RecentlyAddMusicItem = musicData.map{Item.RecentlyAddMusicItem($0)}
        snapshot.appendItems(RecentlyAddMusicItem, toSection: RecentlyAddMusicSection)
        
        dataSource?.apply(snapshot)
    }
}
