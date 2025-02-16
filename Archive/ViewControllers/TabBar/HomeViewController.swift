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
    private var pointOfViewData: [(UserHistoryResponseDTO, String)]? // 탐색했던 시점
    private var recentlyAddMusic: [RecentMusicDTO]? // 최근 추가한 노래
    private var recentlyPlayedMusic: [RecentPlayMusicResponseDTO]? // 최근 들은 노래

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        setProfileImage()
        getHistory() // 최근 탐색 연도 불러오기
        getRecentlyPlayingMusic() // 최근 들은 노래
        getRecentlyAddMusic() // 최근 추가한 노래
    }
    
    // 프로필 이미지 설정 함수
    private func setProfileImage() {
        if let profileImage = KeychainService.shared.load(account: .userInfo, service: .profileImage) {
            homeView.topView.config(profileImage: profileImage)
        }
    }

    // 액션 처리
    private func setAction(){
        homeView.topView.exploreIconButton.addTarget(self, action: #selector(touchUpInsideExploreIcon), for: .touchUpInside)
    }
    
    
    // 상단 탐색 버튼을 눌렀을 때 액션
    @objc func touchUpInsideExploreIcon(){
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
                let albumGesture = CustomTapGesture(target: self, action: #selector(self?.tapGoToAlbumGesture(_:)))
                albumGesture.album = album.title
                albumGesture.artist = artist
                (cell as? BigBannerCell)?.CDImageView.addGestureRecognizer(albumGesture)
                
                // 아티스트 제스처
                let artistGesture = CustomTapGesture(target: self, action: #selector(self?.tapArtistLabelGesture(_:)))
                artistGesture.album = album.title
                artistGesture.artist = artist
                (cell as? BigBannerCell)?.artistLabel.addGestureRecognizer(artistGesture)
                
                return cell
            case let .PointItem(userHistory, imageURL): // 탐색했던 시점
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PointOfViewCell.id, for: indexPath)
                (cell as? PointOfViewCell)?.config(userHistory: userHistory, imageURL: imageURL)
                
                // 셀 제스처 추가
                let tapGesture = CustomTapGesture(target: self, action: #selector(self?.historyTapGeustre(_:)))
                tapGesture.history = userHistory.history
                cell.addGestureRecognizer(tapGesture)
                
                return cell
            case let .FastSelectionItem(music, album, artist): // 빠른 선곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                
                guard let bannerCell = cell as? BannerCell else {return cell}
                bannerCell.configFastSelection(music: music, artist: artist)
                
                // 음악 재생 탭 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self?.musicPlayingGesture(_:)))
                musicGesture.musicTitle = music.title
                musicGesture.musicId = music.id
                musicGesture.musicImageURL = music.image
                musicGesture.artist = artist
                bannerCell.imageView.addGestureRecognizer(musicGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
                
            case let .RecommendMusic(music, album, artist): // 추천곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                verticalCell.configHomeRecommendMusic(music: music, artist: artist)
                
                // 노래 재생 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self?.musicPlayingGesture(_:)))
                musicGesture.musicTitle = music.title
                musicGesture.musicId = music.id
                musicGesture.musicImageURL = album.image
                musicGesture.artist = artist
                verticalCell.playMusicView.addGestureRecognizer(musicGesture)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                verticalCell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                // overflow 버튼 로직 선택
                verticalCell.overflowButton.addTarget(self, action: #selector(self?.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
                verticalCell.setOverflowView(type: .other)
                
                // 노래 보관함으로 이동 탭 제스처
                let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self?.goToLibrary(_:)))
                tapGoToLibraryGesture.musicId = music.id
                verticalCell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
                
                return cell
            case .RecentlyPlayedMusicItem(let music): // 최근 들은 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                guard let bannerCell = cell as? BannerCell else {return cell}
                
                bannerCell.configRecentlyPlayedMusic(music: music)
                
                // 음악 재생 탭 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self?.musicPlayingGesture(_:)))
                musicGesture.musicTitle = music.musicTitle
                musicGesture.musicId = music.musicId
                musicGesture.musicImageURL = music.musicImage
                musicGesture.artist = music.artists.first?.artistName
                bannerCell.imageView.addGestureRecognizer(musicGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = music.artists.first?.artistName
//                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
                
            case .RecentlyAddMusicItem(let music): //  최근 추가 노래
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
               verticalCell.configRecentlyAddMusic(music: music)
                
                // 노래 재생 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self?.musicPlayingGesture(_:)))
                musicGesture.musicTitle = music.title
                musicGesture.musicId = music.id
                musicGesture.musicImageURL = music.image
                musicGesture.artist = music.artist.name
                verticalCell.playMusicView.addGestureRecognizer(musicGesture)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = music.artist.name
//                tapAlbumGesture.album = album.title
                verticalCell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = music.artist.name
//                tapArtistGesture.album = album.title
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                // overflow 버튼 로직 선택
                verticalCell.overflowButton.addTarget(self, action: #selector(self?.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
                verticalCell.setOverflowView(type: .other)
                
                // 노래 보관함으로 이동 탭 제스처
                let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self!.goToLibrary(_:)))
                tapGoToLibraryGesture.musicId = music.id
                verticalCell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)

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
                    self.tapDetailButton(for: section, item: item)
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
    
    // 탐색했던 시점 탭 제스처
    @objc private func historyTapGeustre(_ sender: CustomTapGesture){
        // postHistory API 로직
        guard let history = sender.history else {return}
        postHistory(history: history) // 탐색 시점 저장
    }
    
    private func setSnapShot() {
        // 스냅샷 생성
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // 섹션 정의
        let archiveSection = Section.BigBanner(.Archive) // 당신을 위한 아카이브 섹션
        let pointOfViewSection = Section.PointOfView(.PointOfView) // 탐색했던 시점
        let fastSelectionSection = Section.Banner(.FastSelection) // 빠른 선곡
        let recommendSection = Section.Vertical(.RecommendMusic) // 당신을 위한 추천곡
        let RecentlyPlayedMusicSection = Section.Banner(.RecentlyPlayedMusic) // 최근 들은 노래
        let RecentlyAddMusicSection = Section.Vertical(.RecentlyAddMusic) // 최근 추가한 노래
        
        
        // 섹션 추가
        snapshot.appendSections([archiveSection, pointOfViewSection, fastSelectionSection,
                                 recommendSection, RecentlyPlayedMusicSection,
                                 RecentlyAddMusicSection])
        
        // 당신을 위한 아카이브
        if let archiveData = archiveData {
            let archiveItem = archiveData.map{Item.ArchiveItem($0.0, $0.1)}
            snapshot.appendItems(archiveItem, toSection: archiveSection)
        }
        
        // 최근 탐색 시점
        if let pointOfViewData = pointOfViewData {
            let pointItem = pointOfViewData.map{Item.PointItem($0.0, $0.1)}
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
        
        // 최근 들은 노래
        if let recentlyPlayedMusic = recentlyPlayedMusic {
            let RecentlyListendMusicItem = recentlyPlayedMusic.map{Item.RecentlyPlayedMusicItem($0)}
            snapshot.appendItems(RecentlyListendMusicItem, toSection: RecentlyPlayedMusicSection)
        }

        // 최근 추가한 노래
        if let recentlyAddMusic = recentlyAddMusic {
            let RecentlyAddMusicItem = recentlyAddMusic.map{Item.RecentlyAddMusicItem($0)}
            snapshot.appendItems(RecentlyAddMusicItem, toSection: RecentlyAddMusicSection)
        }
        
        dataSource?.apply(snapshot)
    }
    
    // 탐색년도 설정 API
    private func postHistory(history: String) {
        let param = PostHistoryRequestDTO(history: history)
        userService.postHistory(parameter: param) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let history = response.history.getWeekTuple() // 2025-02-14T06:51:33.841Z ->  (year: 2025, month: 02, week: 1st)
                /// 키 체인 저장
                KeychainService.shared.save(account: .userInfo, service: .timeHistory, value: "\(history.year)년 \(history.month)월 \(history.week)")
                
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 1 // 탐색 뷰로 이동
                }
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
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
                guard let response = response else { return } // 탐색했던 시점이 없을 때
                self.pointOfViewData = response.map{($0.userHistory, $0.historyImage ?? "")}
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
    
    // 최근 들은 노래 볼러 오기 API
    private func getRecentlyPlayingMusic() {
        userService.RecentlyPlayedMusic { [weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let response):
                self.recentlyPlayedMusic = response
                self.setDataSource()
                self.setSnapShot()
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 최근 추가한 노래 불러오기 API
    private func getRecentlyAddMusic() {
        userService.RecentlyMusic { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                guard let response = response else { return }
                self.recentlyAddMusic = response.map{$0.music}
                self.setDataSource()
                self.setSnapShot()
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
}

// 제스처 함수 - Extension
extension HomeViewController: UIGestureRecognizerDelegate  {
    
    // 제스처 설정 (overflowView - hidden 처리)
    private func setGesture() {
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        homeView.addGestureRecognizer(tapGesture)
    }
    
    // overflow 버튼 클릭 시 실행될 메서드
    @objc private func touchUpInsideOverflowButton(_ sender: UIButton) {
        // 버튼의 superview를 통해 셀 찾기
        guard let cell = sender.superview as? VerticalCell ?? sender.superview?.superview as? VerticalCell else { return
        }

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
    
    // 라이브러리로 이동 액션
    @objc private func goToLibrary(_ sender: CustomTapGesture) {
        guard let musicId = sender.musicId else { return }
        postAddMusicInLibary(musicId: musicId)

    }
    
    // 보관함 노래 추가 함수
    private func postAddMusicInLibary(musicId: String) {
        libraryService.musicPost(musicId: musicId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                // 성공 alert 띄우기
                let alert = LibraryAlert.shared.getAlertController(type: .music)
                self.present(alert, animated: true)
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 노래 재생 제스처
    @objc private func musicPlayingGesture(_ sender: CustomTapGesture) {
        guard let musicId = sender.musicId,
              let musicTitle = sender.musicTitle,
              let musicImageURL = sender.musicImageURL,
              let artist = sender.artist
        else { return }
        
        KeychainService.shared.save(account: .musicInfo, service: .musicId, value: musicId)
        KeychainService.shared.save(account: .musicInfo, service: .musicTitle, value: musicTitle)
        KeychainService.shared.save(account: .musicInfo, service: .musicImageURL, value: musicImageURL)
        KeychainService.shared.save(account: .musicInfo, service: .artist, value: artist)
        (self.tabBarController as? TabBarViewController)?.setFloatingView()
    }
    
    // 앨범 버튼
    @objc private func tapGoToAlbumGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        print("TapAlbumImageGesture: \(album), \(artist)")
        let nextVC = AlbumViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 아티스트 버튼
    @objc private func tapArtistLabelGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 자세히 보기 버튼
    private func tapDetailButton(for section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>) {
        let nextVC = DetailViewController(section: section, item: item)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
