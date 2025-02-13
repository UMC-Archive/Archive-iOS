//
//  HomeViewController.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class HomeViewController: UIViewController {
    private let musicService = MusicService()
    private let userService = UserService()

    private let libraryService = LibraryService()
    private let albumService = AlbumService()

    
    private let homeView = HomeView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let musicData = MusicDummyModel.dummy()
    private let pointData = PointOfViewDummyModel.dummy()
    private var overflowView: OverflowView?
    
    private var archiveData: [(AlbumRecommendAlbum, String)]? // 당신을 위한 아카이브
    private var fastSelectionData: [(MusicInfoResponseDTO, AlbumInfoReponseDTO, String)]? // 빠른 선곡
    private var recommendMusic: [(RecommendMusic, RecommendAlbum, String)]? // 당신을 위한 추천곡
    private var pointOfViewData: [GetHistoryResponseDTO]? // 탐색했던 시점

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = homeView
        setDataSource()
        setSnapShot()
        setAction()
        setGesture()
        
        
        getArchive() // 당신을 위한 아카이브
        getSelection() // 빠른 선곡
        getRecommendMusic() // 당신을 위한 추천곡
        getHistory() // 최근 탐색 연도 불러오기
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        setProfileImage()
    }
    
    // 프로필 이미지 설정 함수
    private func setProfileImage() {
        if let profileImage = KeychainService.shared.load(account: .userInfo, service: .profileImage) {
            homeView.topView.config(profileImage: profileImage)
        }
    }
    
    private func setGesture() {
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
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
            case let .ArchiveItem(album, artist): // 아카이브
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigBannerCell.id, for: indexPath)
                (cell as? BigBannerCell)?.config(album: album, artist: artist)
                // 앨범 제스처
                let albumGesture = CustomTapGesture(target: self, action: #selector(self?.TapAlbumImageGesture(_:)))
                albumGesture.album = album.title
                albumGesture.artist = artist
                (cell as? BigBannerCell)?.CDImageView.addGestureRecognizer(albumGesture)
                
                // 아티스트 제스처
                let artistGesture = CustomTapGesture(target: self, action: #selector(self?.TapArtistLabelGesture(_:)))
                artistGesture.album = album.title
                artistGesture.artist = artist
                (cell as? BigBannerCell)?.artistLabel.addGestureRecognizer(artistGesture)
                
                return cell
            case .PointItem(let item): // 탐색했던 시점
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PointOfViewCell.id, for: indexPath)
                (cell as? PointOfViewCell)?.config(data: item)
                return cell
            case let .FastSelectionItem(music, album, artist): // 빠른 선곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                guard let bannerCell = cell as? BannerCell else {return cell}
                
                bannerCell.configFastSelection(music: music, artist: artist)
                    
                // 이미지 탭 제스처 -> 노래 재생
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.TapAlbumImageGesture(_:)))
                bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.TapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
                
            case let .RecommendMusic(music, album, artist): // 추천곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                verticalCell.configHomeRecommendMusic(music: music, artist: artist)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.TapAlbumImageGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                verticalCell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.TapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                // overflow 버튼 로직 선택
                verticalCell.overflowButton.addTarget(self, action: #selector(self?.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
                verticalCell.setOverflowView(type: .other)
                
                // 노래 보관함으로 이동 탭 제스처
                let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self?.goToLibrary(_:)))
                tapGoToLibraryGesture.musicId = music.albumId
                verticalCell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
                
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
            case .RecentlyListendMusicItem(let item): // 최근 들은 노래
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
        guard let cell = sender.superview as? VerticalCell ?? sender.superview?.superview as? VerticalCell else { return }

        // isHidden 토글
        cell.overflowView.isHidden.toggle()
    }
    
    // overflow 버튼 영역 외부 터치 실행될 메서드
    @objc private func dismissOverflowView(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: homeView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in homeView.collectionView.visibleCells {
            if let verticalCell = cell as? VerticalCell {
                if !verticalCell.overflowView.frame.contains(touchLocation) {
                    verticalCell.overflowView.isHidden = true
                }
            }
        }
    }
    @objc private func goToLibrary(_ sender: CustomTapGesture) {
        guard let musicId = sender.musicId else {
            print("nil")
            return }
        print("-------musicId\(musicId)")
        
        libraryService.musicPost(musicId: musicId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("postMusicInfo() 성공")
                print(response)
                Task{
                    print("-----------------musicPost 성공")
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                print("-----------fail")
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 앨범 버튼
    @objc private func TapAlbumImageGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        print("TapAlbumImageGesture: \(album), \(artist)")
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
        
        // 당신을 위한 아카이브
        if let archiveData = archiveData {
            let archiveItem = archiveData.map{Item.ArchiveItem($0.0, $0.1)}
            snapshot.appendItems(archiveItem, toSection: archiveSection)
        }
        
        // 최근 탐색 시점
        if let pointOfViewData = pointOfViewData {
            let pointItem = pointOfViewData.map{Item.PointItem($0)}
            snapshot.appendItems(pointItem, toSection: pointOfViewSection)
        }
        
        // 빠른 선곡
        if let fastSelectionData = fastSelectionData {
            let fastSelectionItem = fastSelectionData.map{Item.FastSelectionItem($0.0, $0.1, $0.2)}
            snapshot.appendItems(fastSelectionItem, toSection: fastSelectionSection)
        }
        
        // 당신을 위한 추천곡
        if let recommendMusic = recommendMusic {
            let recommendMusicItem = recommendMusic.map{Item.RecommendMusic($0.0, $0.1, $0.2)}
            snapshot.appendItems(recommendMusicItem, toSection: recommendSection)
        }
        
        
        let RecentlyListendMusicItem = musicData.map{Item.RecentlyListendMusicItem($0)}
        snapshot.appendItems(RecentlyListendMusicItem, toSection: RecentlyListendMusicSection)
        
        let RecentlyAddMusicItem = musicData.map{Item.RecentlyAddMusicItem($0)}
        snapshot.appendItems(RecentlyAddMusicItem, toSection: RecentlyAddMusicSection)
        
        dataSource?.apply(snapshot)
    }
    
    // 당신을 위한 아카이브 API
    private func getArchive() {
        albumService.albumRecommendAlbum { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else {return}
                self.archiveData = response.map{($0.album, $0.artist)}
                self.setDataSource()
                self.setSnapShot()
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    
    private func postMusicInfo(artist: String, music: String) {
        musicService.musicInfo(artist: artist, music: music){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("postMusicInfo() 성공")
                print(response?.music)
                Task{
//                    LoginViewController.keychain.set(response.token, forKey: "serverAccessToken")
//                    LoginViewController.keychain.set(response.nickname, forKey: "userNickname")
//                    self.goToNextView()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 당신을 위한 추천곡 API
    private func getRecommendMusic(){
        musicService.homeRecommendMusic { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                print("getRecommendMusic() 성공")
                guard let response = response else { return }
                self.recommendMusic = response.map{($0.music, $0.album, $0.artist)}
                setDataSource()
                setSnapShot()
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 최근 탐색 연도 불러오기 API
    private func getHistory() {
        userService.getHistroy { [weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let response):
                self.pointOfViewData = response
                setDataSource()
                setSnapShot()
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 빠른 선곡 불러오기 API
    private func getSelection() {
        musicService.selection { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                print("getSelection() 성공")
                guard let response = response else {return}
                self.fastSelectionData = response.map{($0.music, $0.album, $0.artist)}
                self.setDataSource()
                self.setSnapShot()
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    // 👉 UITapGestureRecognizer가 실행될 때, 특정 조건에서만 실행되도록 설정
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // ✅ 터치한 뷰가 OverflowView이면 제스처 실행하지 않음
        return !(touch.view is OverflowView)
    }
}
