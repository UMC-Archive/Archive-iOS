//
//  DetailViewController.swift
//  Archive
//
//  Created by 이수현 on 1/14/25.
//

import UIKit

class DetailViewController: UIViewController {
    private let section: Section
    private let item: NSDiffableDataSourceSectionSnapshot<Item>
    
    private lazy var detailView = DetailView(section: section)
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let musicData = MusicDummyModel.dummy()
    
    
    init(section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>){
        self.section = section
        self.item = item
        super.init(nibName: nil, bundle: nil)
        
        self.view = detailView
        setDataSource()
        setSnapshot()
        setAction()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setAction() {
        detailView.navigationBarView.popButton.addTarget(self, action: #selector(touchUpInsidePopButton), for: .touchUpInside)
    }
    
    @objc private func touchUpInsidePopButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: detailView.collectionView, cellProvider: {collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
                // 홈 뷰
            case let .FastSelectionItem(music, album, artist): // 빠른 탐색
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configFastSelection(music: music, artist: artist)
                return cell
            case .RecentlyListendMusicItem(let data): // 최근 들은 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configMusic(data: data)
                return cell
            case let .RecommendMusic(music, album, artist): // 당신을 위한 추천곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.configHomeRecommendMusic(music: music, artist: artist)
                return cell
            case  .RecentlyAddMusicItem(let data): // 최근 추가한 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.config(data: data)
                return cell
                // 앨범 뷰
            case let .AnotherAlbum(album, artist): // 이 아티스트의 다른 앨범
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configAnotherAlbum(album: album, artist: artist)
                return cell
            case let .RecommendAlbum(album, artist): // 당신을 위한 추천 앨범 (앨범 뷰)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configAlbumRecommendAlbum(album: album, artist: artist)
                return cell
                // 탐색 뷰
            case let .ExploreRecommendMusic(music, _, artist): // 당신을 위한 추천곡 (탐색뷰)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.configExploreRecommendMusic(music: music, artist: artist)
                return cell
            case let .ExploreRecommendAlbum(album, artist): // 당신을 위한 앨범 추천 (탐색뷰)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configExploreRecommendAlbum(album: album, artist: artist)
                return cell
            case let .HiddenMusic(music, _, artist): // 숨겨진 명곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.configHiddenMusic(music: music, artist: artist)
                return cell
                // 아티스트 뷰
            case let .ArtistPopularMusic(music, album, artist): // 아티스트 인기곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.configPopularMusic(music: music, artist: artist)
                return cell
            case let .SameArtistAnotherAlbum(album, artist): // 앨범 둘러보기
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configSameArtistAlbum(album: album, artist: artist)
                return cell
            default:
                return UICollectionViewCell()
            }
        })
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([section])
//        var sectionData : [Item]?
//        
//        switch section {
//        case .Banner:
//            sectionData = musicData.map{Item.FastSelectionItem($0)}
//            
//        case .Vertical:
//            let recommendData = data as? RecommendMusicResponseDTO
//            sectionData = data.map{Item.RecommendMusicItem($0)}
//        default:
//            return
//        }
//        guard let sectionData = sectionData else {return}
        snapshot.appendItems(item.items, toSection: section)
        self.dataSource?.apply(snapshot)
    }
}
