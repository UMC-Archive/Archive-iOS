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
        setDelegate()
        setRecapIndex()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let contentHeight = calculateScrollViewHeight()
        print("contentHeight: \(contentHeight)")
        exploreView.contentView.snp.updateConstraints { make in
//            make.height.equalTo(contentHeight + 97)
            make.height.equalTo(1300)
        }
        
        exploreView.layoutIfNeeded()
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        // 각 섹션의 높이 정의
        let verticalSectionHeight: CGFloat = 275 + (10 * 3) + 45 // 그룹 높이 + 간격 + 헤더
        let bannerSectionHeight: CGFloat = 186 + 45 // 그룹 높이 + 헤더
        let interSectionSpacing: CGFloat = 40 // 섹션 간 간격

        // 섹션 높이 합계
        let totalCollectionViewHeight = (verticalSectionHeight * 2) + bannerSectionHeight + (interSectionSpacing * 2)
        return totalCollectionViewHeight
    }
    
    private func calculateScrollViewHeight() -> CGFloat {
        // collectionView 전체 높이 계산
        let collectionViewHeight = calculateCollectionViewHeight()

        // recapCollectionView 높이
        let recapCollectionViewHeight: CGFloat = 333

        // recapCollectionView와 collectionView 사이 간격
        let gapBetweenRecapAndCollectionView: CGFloat = 17

        // scrollView 전체 높이
        let totalHeight = recapCollectionViewHeight + gapBetweenRecapAndCollectionView + collectionViewHeight
        return totalHeight
    }


    
    private func setRecapIndex(){
        // 뷰가 로드된 직후 1번 인덱스로 이동
        DispatchQueue.main.async {
            let recapIndexPath = IndexPath(item: 1, section: 0)
            self.exploreView.recapCollectionView.scrollToItem(at: recapIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func setDelegate() {
        exploreView.recapCollectionView.dataSource = self
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


extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case exploreView.recapCollectionView:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case exploreView.recapCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecapCollectionViewCell.recapCollectionViewIdentifier, for: indexPath)
            (cell as? RecapCollectionViewCell)?.config(data: musicData[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
