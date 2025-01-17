//
//  ExploreViewController.swift
//  Archive
//
//  Created by 이수현 on 1/17/25.
//

import UIKit

class ExploreViewController: UIViewController {
    private let exploreView = ExploreView()
    private var dataSource : UICollectionViewDiffableDataSource<Section, Item>?
    private let musicData = MusicDummyModel.dummy()
    private let albumData = AlbumDummyModel.dummy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        view = exploreView
        
        setDataSource()
        setSnapShot()
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: exploreView.collectionView, cellProvider: {collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .RecommendMusicItem(let item), .HiddenMusic(let item): // 당신을 위한 추천곡, 숨겨진 명곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.config(data: item)
                return cell
            case .RecommendAlbum(let item): // 당신을 위한 앨범 추천
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configAlbum(data: item)
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
    
    private func handleDetailButtonTap(for section: Section) {
        let nextVC = DetailViewController(section: section)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setSnapShot() {
        // 스냅샷 생성
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // 섹션 정의
        let recommendMusicSection = Section.Vertical(.RecommendMusic) // 당신을 위한 추천곡
        let recommendAlbumSection = Section.Banner(.RecommendAlbum) // 당신을 위한 앨범 추천
        let hiddenMusicSection = Section.Vertical(.HiddenMusic) // 숨겨진 명곡
        
        
        // 섹션 추가
        snapshot.appendSections([recommendMusicSection, recommendAlbumSection, hiddenMusicSection])

        let recommendMusicItem = musicData.map{Item.RecommendMusicItem($0)} // 추천곡
        let recommendAlbumItem = albumData.map{Item.RecommendAlbum($0)} // 앨범 추천
        let hiddenMusicItem = musicData.map{Item.HiddenMusic($0)}   // 숨겨진 명곡
        
        snapshot.appendItems(recommendMusicItem, toSection: recommendMusicSection)
        snapshot.appendItems(recommendAlbumItem, toSection: recommendAlbumSection)
        snapshot.appendItems(hiddenMusicItem, toSection: hiddenMusicSection)
        
        dataSource?.apply(snapshot)
    }
}
