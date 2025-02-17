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
    private let libraryService = LibraryService()
    
    
    init(section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>){
        self.section = section
        self.item = item
        super.init(nibName: nil, bundle: nil)
        
        self.view = detailView
        setDataSource()
        setSnapshot()
        setAction()
        setGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            case let .FastSelectionItem(music, album, artist): // 빠른 선곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                
                guard let bannerCell = cell as? BannerCell else {return cell}
                bannerCell.configFastSelection(music: music, artist: artist)
                
                // 음악 재생 탭 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
                musicGesture.musicTitle = music.title
                musicGesture.musicId = music.id
                musicGesture.musicImageURL = music.image
                musicGesture.artist = artist
                bannerCell.imageView.addGestureRecognizer(musicGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                return cell
            case .RecentlyPlayedMusicItem(let data): // 최근 들은 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                guard let bannerCell = cell as? BannerCell else {return cell}
                
                bannerCell.configRecentlyPlayedMusic(music: data.music, artist: data.artist.name)
                
                // 음악 재생 탭 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
                musicGesture.musicTitle = data.music.title
                musicGesture.musicId = data.music.id
                musicGesture.musicImageURL = data.music.image
                musicGesture.artist = data.artist.name
                bannerCell.imageView.addGestureRecognizer(musicGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = data.artist.name
                tapArtistGesture.album = data.album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
            case let .RecommendMusic(music, album, artist): // 당신을 위한 추천곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                verticalCell.configHomeRecommendMusic(music: music, artist: artist)
                
                // 노래 재생 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
                musicGesture.musicTitle = music.title
                musicGesture.musicId = music.id
                musicGesture.musicImageURL = album.image
                musicGesture.artist = artist
                verticalCell.playMusicView.addGestureRecognizer(musicGesture)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                verticalCell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                // overflow 버튼 로직 선택
                verticalCell.overflowButton.addTarget(self, action: #selector(self.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
                verticalCell.setOverflowView(type: .other)
                
                // 노래 보관함으로 이동 탭 제스처
                let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self.goToLibrary(_:)))
                tapGoToLibraryGesture.musicId = music.id
                verticalCell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
                
                return cell
            case  .RecentlyAddMusicItem(let data): // 최근 추가한 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                 guard let verticalCell = cell as? VerticalCell else {return cell}
                verticalCell.configRecentlyAddMusic(music: data.music, artist: data.artist.name)
                 
                 // 노래 재생 제스처
                 let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
                 musicGesture.musicTitle = data.music.title
                 musicGesture.musicId = data.music.id
                 musicGesture.musicImageURL = data.music.image
                 musicGesture.artist = data.artist.name
                 verticalCell.playMusicView.addGestureRecognizer(musicGesture)
                 
                 // 앨범 탭 제스처
                 let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
                 tapAlbumGesture.artist = data.artist.name
                 tapAlbumGesture.album = data.album.title
                 verticalCell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
                 
                 // 아티스트 탭 제스처
                 let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                 tapArtistGesture.artist = data.artist.name
                 tapArtistGesture.album = data.album.title
                 verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                 
                 // overflow 버튼 로직 선택
                 verticalCell.overflowButton.addTarget(self, action: #selector(self.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
                 verticalCell.setOverflowView(type: .other)
                 
                 // 노래 보관함으로 이동 탭 제스처
                 let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self.goToLibrary(_:)))
                 tapGoToLibraryGesture.musicId = data.music.id
                 verticalCell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
                return cell
                
                // 앨범 뷰
            case let .AnotherAlbum(album, artist): // 이 아티스트의 다른 앨범
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                guard let bannerCell = cell as? BannerCell else {return cell}
                
                bannerCell.configAnotherAlbum(album: album, artist: artist)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
            case let .RecommendAlbum(album, artist): // 당신을 위한 추천 앨범 (앨범 뷰)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                guard let bannerCell = cell as? BannerCell else {return cell}
                
                bannerCell.configAlbumRecommendAlbum(album: album, artist: artist)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                return cell
                
                // 탐색 뷰
            case let .ExploreRecommendMusic(music, album, artist): // 당신을 위한 추천곡 (탐색뷰)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                
                verticalCell.configExploreRecommendMusic(music: music, artist: artist)
                
                // 노래 재생 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
                musicGesture.musicTitle = music.title
                musicGesture.musicId = music.id
                musicGesture.musicImageURL = album.image
                musicGesture.artist = artist
                verticalCell.playMusicView.addGestureRecognizer(musicGesture)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                verticalCell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                // overflow 버튼 로직 선택
                verticalCell.overflowButton.addTarget(self, action: #selector(self.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
                verticalCell.setOverflowView(type: .other)
                
                // 노래 보관함으로 이동 탭 제스처
                let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self.goToLibrary(_:)))
                tapGoToLibraryGesture.musicId = music.id
                verticalCell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
                return cell
            case let .ExploreRecommendAlbum(album, artist): // 당신을 위한 앨범 추천 (탐색뷰)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                guard let bannerCell = cell as? BannerCell else {return cell}
                
                bannerCell.configExploreRecommendAlbum(album: album, artist: artist)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                return cell
            case let .HiddenMusic(music, album, artist): // 숨겨진 명곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                
                verticalCell.configHiddenMusic(music: music, artist: artist)
                
                // 노래 재생 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
                musicGesture.musicTitle = music.title
                musicGesture.musicId = music.id
                musicGesture.musicImageURL = album.image
                musicGesture.artist = artist
                verticalCell.playMusicView.addGestureRecognizer(musicGesture)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                verticalCell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                // overflow 버튼 로직 선택
                verticalCell.overflowButton.addTarget(self, action: #selector(self.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
                verticalCell.setOverflowView(type: .other)
                
                // 노래 보관함으로 이동 탭 제스처
                let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self.goToLibrary(_:)))
                tapGoToLibraryGesture.musicId = music.id
                verticalCell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
                
                return cell
                
                // 아티스트 뷰
            case let .ArtistPopularMusic(music, album, artist): // 아티스트 인기곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                
                verticalCell.configPopularMusic(music: music, artist: artist)
                
                // 노래 재생 제스처
                let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
                musicGesture.musicTitle = music.title
                musicGesture.musicId = music.id
                musicGesture.musicImageURL = album.image
                musicGesture.artist = artist
                verticalCell.playMusicView.addGestureRecognizer(musicGesture)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                verticalCell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                // overflow 버튼 로직 선택
                verticalCell.overflowButton.addTarget(self, action: #selector(self.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
                verticalCell.setOverflowView(type: .other)
                
                // 노래 보관함으로 이동 탭 제스처
                let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self.goToLibrary(_:)))
                tapGoToLibraryGesture.musicId = music.id
                verticalCell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
                return cell
            case let .SameArtistAnotherAlbum(album, artist): // 앨범 둘러보기
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                guard let bannerCell = cell as? BannerCell else {return cell}
                
                bannerCell.configSameArtistAlbum(album: album, artist: artist)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                return cell
            default:
                return UICollectionViewCell()
            }
        })
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([section])
        snapshot.appendItems(item.items, toSection: section)
        self.dataSource?.apply(snapshot)
    }
}


// 제스처 함수 - Extension
extension DetailViewController: UIGestureRecognizerDelegate  {
    
    // 제스처 설정 (overflowView - hidden 처리)
    private func setGesture() {
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        detailView.addGestureRecognizer(tapGesture)
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
        let touchLocation = gesture.location(in: detailView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in detailView.collectionView.visibleCells {
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
