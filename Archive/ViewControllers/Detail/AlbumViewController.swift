//
//  AlbumViewController.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

class AlbumViewController: UIViewController {
    private let musicService = MusicService()
    private let albumService = AlbumService()
    
    private let artist: String
    private let album: String
    
    private let albumView = AlbumView()
    private var albumData: AlbumInfoReponseDTO = Constant.AlbumInfoLoadingData // 앨범 데이터
    private var trackListData: [TrackListResponse] = Constant.TrackListLoadingData// 트랙 리스트 데이터
    private var recommendAlbumData: [(AlbumRecommendAlbum, String)] = Constant.ArchiveLoadingData // 추천 앨범
    private var anotherAlbum: [(AnotherAlbumResponseDTO, String)] = Constant.AnotherAlbumLoadingData // 이 아티스트의 다른 앨범
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    private var libraryService = LibraryService()
    private var responseData: LibraryAlbumPostResponseDTO?
    
    init(artist: String, album: String) {
        self.artist = artist
        self.album = album
        
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = albumView
        setNavigationBar()
        setDataSource()
        setSnapshot()
        setProtocol()
        setGesture()
        
        // 앨범 정보 API
        postAlbumInfo(artist: artist, album: album)
        
        // 앨범 추천 API
        getRecommendAlbum()
        
        // 모든 아이디 조회
        getAllId(artist: artist, album: album)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    private func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        // 뒤로 가기
        let popButton = UIBarButtonItem(image: .init(systemName: "chevron.left"), style: .plain, target: self, action: #selector(tapPopButton))
        self.navigationItem.leftBarButtonItem = popButton
        
        // 저장 버튼
        let addLibrayButton = UIBarButtonItem(image: .addLibrary, style: .done, target: self, action: #selector(tapAddLibrayButton))
        self.navigationItem.rightBarButtonItem = addLibrayButton
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    // 뒤로 가기 버튼
    @objc private func tapPopButton() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    // 라이브러리 추가 버튼
    @objc private func tapAddLibrayButton() {
        libraryService.albumPost(albumId: albumData.id ){[weak self] result in
            guard let self = self else{return}
            switch result {
            case .success:
                let alert = LibraryAlert.shared.getAlertController(type: .album)
                self.present(alert, animated: true)
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    private func updateTrackViewHeight(){
        // 앨범 리스트가 4개 이하일 경우
        let musicCount = self.trackListData.count
        if musicCount <= 4 {
            albumView.trackView.pageControl.isHidden = true
            
            let baseHeight: CGFloat = 120 + 17 * 2 + 20
            let trackHeight: CGFloat = CGFloat(musicCount) * 50.0 + (CGFloat(musicCount - 1) * 10.0)
            let totalHeight = baseHeight + trackHeight
            
            albumView.trackView.snp.updateConstraints { make in
                make.height.equalTo(totalHeight)
            }
            
            albumView.trackView.trackCollectionView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(17)
            }
        } else { // 4개 이상일 경우
            albumView.trackView.pageControl.isHidden = false
            albumView.trackView.snp.updateConstraints { make in
                make.height.equalTo(420)
            }
        }
        
        albumView.layoutIfNeeded()
    }
    
    private func setProtocol() {
        albumView.trackView.trackCollectionView.dataSource = self
        albumView.trackView.trackCollectionView.delegate = self
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: albumView.collectionView){ collectionView, indexPath, ItemIdentifier in
            switch ItemIdentifier {
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
            case let .RecommendAlbum(album, artist): // 당신을 위한 추천 앨범
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
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self, let section = self.dataSource?.sectionIdentifier(for: indexPath.section), let item = dataSource?.snapshot(for: section) else {return UICollectionReusableView() }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            // 버튼에 UIAction 추가
            (headerView as? HeaderView)?.detailButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.tapDetailButton(for: section, item: item)
            }), for: .touchUpInside)

            switch section {
            case .Banner(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        }
        
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        let anotherAlbumSection = Section.Banner(.AnotherAlbum) // 이 아티스트의 다른 앨범
        let recommendAlbumSection = Section.Banner(.RecommendAlbum) // 당신을 위한 추천 핼범
        
        snapshot.appendSections([anotherAlbumSection, recommendAlbumSection])
        
        // 이 아티스트의 다른 앨범
            let anotherAlbumItem = anotherAlbum.map{Item.AnotherAlbum($0.0, $0.1)}
            snapshot.appendItems(anotherAlbumItem, toSection: anotherAlbumSection)
        
        
        // 당신을 위한 추천 앨범
        
            let recommendAlbumItem = recommendAlbumData.map{Item.RecommendAlbum($0.0, $0.1)}
            snapshot.appendItems(recommendAlbumItem, toSection: recommendAlbumSection)
        

        dataSource?.apply(snapshot)
    }
    
    // 앨범 정보 가져오기 API
    func postAlbumInfo(artist: String, album: String) { // musicService의 album 함수의 파라미터로 artist, album이 필요하기 때문에 받아옴
        // musicService의 album 함수 사용
        musicService.album(artist: artist, album: album){ [weak self] result in // 반환값 result의 타입은 Result<AlbumInfoReponseDTO?, NetworkError>
            guard let self = self else { return }
            
            switch result {
            case .success(let response): // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
                guard let data = response else { return }
                albumData = data
                
                postAlbumCuration(albumId: data.id) // 앨범 큐레이션
                getTrackList(albumId: data.id)      // 앨범 트랙 리스트
                
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getRetryAlertController(title: "앨범 정보" , description: error.description, retryAction: { [weak self] in
                    self?.postAlbumInfo(artist: artist, album: album) // 🔄 재시도 버튼을 누르면 다시 API 호출
                })
                self.present(alert, animated: true)
            }
        }
    }
    
    // 앨범 큐레이션 API
    func postAlbumCuration(albumId: String) {
        musicService.albumCuration(albumId: albumId){ [weak self] result in // 반환값 result의 타입은 Result<String?, NetworkError>
            guard let self = self else { return }
            
            switch result {
            case .success(let response): // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
                guard let response = response else { return }
                albumView.config(data: albumData, artist: artist, description: response.description)
                
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getRetryAlertController(title: "앨범 큐레이션" , description: error.description, retryAction: { [weak self] in
                    self?.postAlbumCuration(albumId: albumId) // 🔄 재시도 버튼을 누르면 다시 API 호출
                })
                self.present(alert, animated: true)
            }
        }
    }
    
    // 당신을 위한 앨범 추천
    func getRecommendAlbum() {
        albumService.albumRecommendAlbum { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else { return }
                self.recommendAlbumData = response.map{($0.album, $0.artist)}
                self.setDataSource()
                self.setSnapshot()
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getRetryAlertController(title: "당신을 위한 앨범 추천" , description: error.description, retryAction: getRecommendAlbum)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 모든 아이디 조회
    private func getAllId(artist: String, album: String){
        musicService.allInfo(album: album, artist: artist) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                guard let artistId = response.artist.info.id, let albumId = response.album.info.id else {
                    let alert = NetworkAlert.shared.getAlertController(title: "아티스트: \(String(describing: response.artist.info.id))\n 앨범: \(String(describing: response.album.info.id))")
                    self.present(alert, animated: true)
                    return
                }
                self.getAnotherAlbum(artistId: artistId, albumId: albumId) //  이 아티스트의 다른 앨범 조회 함수 호출
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 이 아티스트의 다른 앨범 조회
    private func getAnotherAlbum(artistId: String, albumId: String) {
        musicService.anotherAlbum(artistId: artistId, albumId: albumId) { [weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let response):
                guard let response = response else { return }
                self.anotherAlbum = response.map{($0, self.artist)}
                self.setDataSource()
                self.setSnapshot()
            case .failure(let error):
                let alert = NetworkAlert.shared.getRetryAlertController(title: "이 아티스트의 다른 앨범" , description: error.description, retryAction: { [weak self] in
                    self?.getAnotherAlbum(artistId: artistId, albumId: albumId) // 🔄 재시도 버튼을 누르면 다시 API 호출
                })
                self.present(alert, animated: true)
            }
        }
    }
    
    // 트랙 리스트 (수록곡 소개)
    private func getTrackList(albumId: String) {
        albumService.trackList(albumId: albumId) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                guard let response = response else {return}
                self.trackListData = response.tracks
                self.albumView.trackView.trackCollectionView.reloadData()
                
                albumView.configTrack(data: response)
                updateTrackViewHeight()
                
            case .failure(let error):
                let alert = NetworkAlert.shared.getRetryAlertController(title: "수록곡 소개" , description: error.description, retryAction: { [weak self] in
                    self?.getTrackList(albumId: albumId) // 🔄 재시도 버튼을 누르면 다시 API 호출
                })
                self.present(alert, animated: true)
            }
        }
    }
}

// 제스처 함수 - Extension
extension AlbumViewController: UIGestureRecognizerDelegate  {
    
    // 제스처 설정 (overflowView - hidden 처리)
    private func setGesture() {
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        albumView.addGestureRecognizer(tapGesture)
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
        let touchLocation = gesture.location(in: albumView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in albumView.trackView.trackCollectionView.visibleCells {
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


extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.trackListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath) as? VerticalCell else {return UICollectionViewCell()
        }
        cell.configTrackList(music: trackListData[indexPath.row])
        
        // 노래 재생 제스처
        let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
        musicGesture.musicTitle = trackListData[indexPath.row].title
        musicGesture.musicId = trackListData[indexPath.row].id
        musicGesture.musicImageURL = trackListData[indexPath.row].image
        musicGesture.artist = artist
        cell.playMusicView.addGestureRecognizer(musicGesture)
        
        // 아티스트 탭 제스처
        let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
        tapArtistGesture.artist = artist
        tapArtistGesture.album = album
        cell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
        
        // overflow 버튼 로직 선택
        cell.overflowButton.addTarget(self, action: #selector(self.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
        cell.setOverflowView(type: .inAlbum)
        
        // 노래 보관함으로 이동 탭 제스처
        let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self.goToLibrary(_:)))
        tapGoToLibraryGesture.musicId = trackListData[indexPath.row].id
        cell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
             
        return cell
    }
}

extension AlbumViewController: UICollectionViewDelegate {
    // 페이지 컨트롤 설정
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        albumView.trackView.pageControl.currentPage = Int(pageIndex)
    }
}
