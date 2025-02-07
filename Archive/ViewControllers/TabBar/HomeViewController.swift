//
//  HomeViewController.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class HomeViewController: UIViewController {
    private let musicService = MusicService() // 예시
    private let userService = UserService()
    
    private let homeView = HomeView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let musicData = MusicDummyModel.dummy()
    private let pointData = PointOfViewDummyModel.dummy()
    private var overflowView: OverflowView?
//    private var recommendMusic: [(RecommendMusic, String)]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = homeView
        setDataSource()
        setSnapShot()
        
        
        // 음악 정보 가져오기 API
//        postMusicInfo(artist: "IU", music: "Love poem") // 예시

        setAction()
        setGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("homeView has disappeared")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setGesture() {
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        tapGesture.cancelsTouchesInView = false
        homeView.addGestureRecognizer(tapGesture)
    }
    
    private func setAction(){
        homeView.topView.exploreIconButton.addTarget(self, action: #selector(exploreIconTapped), for: .touchUpInside)
    }
    @objc func exploreIconTapped(){
        let viewController = DatePickerViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
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
                guard let bannerCell = cell as? BannerCell else {return cell}
                
                bannerCell.configMusic(data: item)
                    
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.TapAlbumImageGesture(_:)))
                tapAlbumGesture.artist = item.artist
                tapAlbumGesture.album = item.albumTitle
                bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.TapArtistLabelGesture(_:)))
                tapArtistGesture.artist = item.artist
                tapArtistGesture.album = item.albumTitle
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
            case .RecommendMusic(let data): // 추천곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                verticalCell.config(data: data)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.TapAlbumImageGesture(_:)))
                tapAlbumGesture.artist = data.artist
                tapAlbumGesture.album = data.albumTitle
                verticalCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.TapArtistLabelGesture(_:)))
                tapArtistGesture.artist = data.artist
                tapArtistGesture.album = data.albumTitle
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                // overflow 버튼 로직 선택
                verticalCell.overflowButton.addTarget(self, action: #selector(self?.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
        
                return cell
            case .RecentlyAddMusicItem(let item): //  최근 추가 노래
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
               verticalCell.config(data: item)
               
               // 앨범 탭 제스처
               let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.TapAlbumImageGesture(_:)))
               tapAlbumGesture.artist = item.artist
               tapAlbumGesture.album = item.albumTitle
               verticalCell.imageView.addGestureRecognizer(tapAlbumGesture)
               
               // 아티스트 탭 제스처
               let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.TapArtistLabelGesture(_:)))
               tapArtistGesture.artist = item.artist
                tapArtistGesture.album = item.albumTitle
               verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
               return cell
            default:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self,
                    let section = self.dataSource?.sectionIdentifier(for: indexPath.section),
                    let item = dataSource?.snapshot(for: section)
            else {
                return UICollectionReusableView()
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            
            // 버튼에 UIAction 추가, 탐색 시점 섹션 제외
            if section != .PointOfView(.PointOfView) {
                (headerView as? HeaderView)?.detailButton.addAction(UIAction(handler: { [weak self] _ in
                    guard let self = self else {return}
                    self.handleDetailButtonTap(for: section, item: item)
                }), for: .touchUpInside)
            }

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
    
    // overflow 버튼 클릭 시 실행될 메서드
    @objc private func touchUpInsideOverflowButton(_ sender: UIButton) {
        // 버튼의 superview를 통해 셀 찾기
        guard let cell = sender.superview as? VerticalCell ?? sender.superview?.superview as? VerticalCell,
              let indexPath = homeView.collectionView.indexPath(for: cell) else {
            return
        }
        
        print("didTapOverflowButton: \(indexPath)")
        
        // isHidden 토글
        cell.overflowView.isHidden = false
        
        // 데이터 전달
        let itemData = dataSource?.itemIdentifier(for: indexPath)
        print("선택한 아이템 데이터:", itemData ?? "없음")
    }
    
    // overflow 버튼 영역 외부 터치 실행될 메서드
    @objc private func dismissOverflowView(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: homeView.collectionView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in homeView.collectionView.visibleCells {
            if let verticalCell = cell as? VerticalCell {
                if !verticalCell.overflowView.frame.contains(touchLocation) {
                    verticalCell.overflowView.isHidden = true
                }
            }
        }
    }
    
    
    // 앨범 버튼
    @objc private func TapAlbumImageGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        let nextVC = AlbumViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 아티스트 버튼
    @objc private func TapArtistLabelGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 자세히 보기 버튼
    private func handleDetailButtonTap(for section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>) {
        let nextVC = DetailViewController(section: section, item: item)
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

        // 추천곡
        let recommendMusicItem = musicData.map{Item.RecommendMusic($0)}
        snapshot.appendItems(recommendMusicItem, toSection: recommendSection)
        
        let RecentlyListendMusicItem = musicData.map{Item.RecentlyListendMusicItem($0)}
        snapshot.appendItems(RecentlyListendMusicItem, toSection: RecentlyListendMusicSection)
        
        let RecentlyAddMusicItem = musicData.map{Item.RecentlyAddMusicItem($0)}
        snapshot.appendItems(RecentlyAddMusicItem, toSection: RecentlyAddMusicSection)
        
        dataSource?.apply(snapshot)
    }
    
    
    // 음악 정보 가져오기 API
    func postMusicInfo(artist: String, music: String) {
        musicService.musicInfo(artist: artist, music: music){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("postMusicInfo() 성공")
                print(response?.musicUrl)
                Task{
//                    LoginViewController.keychain.set(response.token, forKey: "serverAccessToken")
//                    LoginViewController.keychain.set(response.nickname, forKey: "userNickname")
//                    self.goToNextView()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
}
