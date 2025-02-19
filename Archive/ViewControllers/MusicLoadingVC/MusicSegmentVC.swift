import UIKit
import Kingfisher

class MusicSegmentVC: UIViewController {

    private let segmentView = MusicSegmentView()
    private let musicService = MusicService()
    private let libraryService = LibraryService()
    private let albumService = AlbumService()
    public var segmentIndexNum: Int

    private var lyrics: [String]?
    private var nextTracks: [SelectionResponseDTO]?
    public var recommendAlbums: [AlbumRecommendAlbumResponseDTO] = [AlbumRecommendAlbumResponseDTO(album: AlbumRecommendAlbum.loadingData(), artist: Constant.LoadString)]
    private var recommendMusic: [RecommendMusicResponseDTO] = [
        RecommendMusicResponseDTO(music: RecommendMusic.loadingData(), album: RecommendAlbum.loadingData(), artist: Constant.LoadString)
    ]

    var musicTitle: String?
       var artistName: String?
    
    init(segmentIndexNum: Int, lyrics: [String]?, nextTracks: [SelectionResponseDTO]) {
        self.segmentIndexNum = segmentIndexNum
        self.lyrics = lyrics
        self.nextTracks = nextTracks.isEmpty ? Constant.NextTrackLoadingData : nextTracks
        super.init(nibName: nil, bundle: nil)
        
        fetchRecommendAlbums()
        fetchRecommendMusic()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMusicChange(_:)), name: .didChangeMusic, object: nil)
        setupSegmentActions()
        setupCollectionView()
        setGesture()

        // 초기 언더바
        // 언더바 초기 위치 설정 로직도 segmentChanged()와 똑같이
        
        
//        fetchNextTracks()
        
//        if segmentIndexNum == 1 {
//               fetchLyrics()
//           }
        
        print(segmentIndexNum)
        //   preferArtistView.nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        segmentView.rightButton.addTarget(self,action : #selector(rightButtonTapped), for: .touchUpInside)
        segmentView.albumInfoView.playButton.addTarget(self, action: #selector(touchUpInsidePlayButton), for: .touchUpInside)
        segmentView.albumInfoView.overlappingSquaresButton.addTarget(self, action: #selector(touchUpInsideLibraryButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    init(segmentIndexNum: Int, musicTitle: String? = nil, artistName: String? = nil) {
//        self.segmentIndexNum = segmentIndexNum
//        self.musicTitle = musicTitle
//        self.artistName = artistName
//        super.init(nibName: nil, bundle: nil)
//    }
//    

   
    override func loadView() {
        self.view = segmentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

        segmentView.tabBar.selectedSegmentIndex = segmentIndexNum
        setupInitialView(index: segmentIndexNum)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }



    // 오른쪽 버튼 눌렀을 때 앨범 추천으로 가게
    @objc func rightButtonTapped() {

        if recommendAlbums.count == 1 { return }
        let secondVC = ForYouAlbumRecommendVC(recommendMusic: recommendAlbums)
        navigationController?.pushViewController(secondVC, animated: true)

    }
       private var isInitialLayoutSet = false

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 초기 위치 설정은 한 번만 하도록
        if !isInitialLayoutSet {
            let underbarWidth = segmentView.tabBar.frame.width / 3
            let newLeading = CGFloat(segmentIndexNum) * underbarWidth

            segmentView.selectedUnderbar.snp.updateConstraints {
                $0.leading.equalTo(segmentView.tabBar.snp.leading).offset(newLeading)
                $0.width.equalTo(underbarWidth)
            }

            isInitialLayoutSet = true // 다시 안 들어오게 설정
        }
    }
    
    private func setupSegmentActions() {
        segmentView.tabBar.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    @objc private func segmentChanged() {
        let index = segmentView.tabBar.selectedSegmentIndex

        let underbarWidth = segmentView.tabBar.frame.width / 3
        let newLeading = CGFloat(index) * underbarWidth
        
        
        // 언더바 이동 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.segmentView.selectedUnderbar.snp.updateConstraints {
                $0.leading.equalTo(self.segmentView.tabBar.snp.leading).offset(newLeading)
                $0.width.equalTo(underbarWidth)
            }
            print(self.segmentIndexNum)
            self.segmentView.layoutIfNeeded()
        })
        setupInitialView(index: index)

    }

// 어떤 컬렉션 뷰 보여줄지
    private func setupInitialView(index: Int) {
        self.segmentView.layoutIfNeeded()
        let index = index
        switch index {
        case 0:
            segmentView.nextTrackCollectionView.isHidden = false
            segmentView.lyricsCollectionView.isHidden = true
            segmentView.recommendContentView.isHidden = true
        case 1:
            segmentView.nextTrackCollectionView.isHidden = true
            segmentView.lyricsCollectionView.isHidden = false
            segmentView.recommendContentView.isHidden = true
        case 2:
            segmentView.nextTrackCollectionView.isHidden = true
            segmentView.lyricsCollectionView.isHidden = true
            segmentView.recommendContentView.isHidden = false
        default:
            break
        }
    }
// 컬렉션 뷰 연결 내부 셀들
    private func setupCollectionView() {
        segmentView.nextTrackCollectionView.delegate = self
        segmentView.nextTrackCollectionView.dataSource = self
        segmentView.nextTrackCollectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)

        segmentView.lyricsCollectionView.delegate = self
        segmentView.lyricsCollectionView.dataSource = self
        segmentView.lyricsCollectionView.register(LyricsCell.self, forCellWithReuseIdentifier: LyricsCell.identifier)

        segmentView.albumCollectionView.delegate = self
        segmentView.albumCollectionView.dataSource = self
        segmentView.albumCollectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)

        segmentView.albumRecommendCollectionView.delegate = self
        segmentView.albumRecommendCollectionView.dataSource = self
        segmentView.albumRecommendCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.identifier)
    }
// 가사 가져오는 함수
    private func fetchLyrics() {
        guard let musicTitle = musicTitle, let artistName = artistName else {
            print("곡 정보 없음")
            return
        }

        // musicService.musicInfo()를 또 호출해도 되고, 필요한 데이터만 넘겨받았다면 바로 사용해도 됨
        musicService.musicInfo(artist: artistName, music: musicTitle) { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                let rawLyrics = data.music.lyrics
                self?.lyrics = rawLyrics.components(separatedBy: "\n").map { $0.replacingOccurrences(of: "\\[.*?\\]", with: "", options: .regularExpression) }

            case .failure(_):
                self?.lyrics = ["가사를 불러오지 못했습니다."]
            }

            self?.segmentView.lyricsCollectionView.reloadData()
        }
    }
    @objc private func handleMusicChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let title = userInfo["title"] as? String,
              let artist = userInfo["artist"] as? String,
              let lyrics = userInfo["lyrics"] as? String,
              let image = userInfo["image"] as? String,
              let isPlaying = userInfo["isPlaying"] as? Bool
        else {
            print("Notification 데이터 부족")
            return
        }
        
        self.segmentView.configFloatingView(title: title, artist: artist, image: image, isPlaying: isPlaying)

        // 현재 음악 제목, 아티스트 업데이트
        self.musicTitle = title
        self.artistName = artist

        // 가사 파싱해서 업데이트
        self.lyrics = lyrics.components(separatedBy: "\n").map { $0.replacingOccurrences(of: "\\[.*?\\]", with: "", options: .regularExpression) }

        self.segmentView.lyricsCollectionView.reloadData()
        
        // 만약 가사 탭이 열려있는 상태(segmentIndexNum == 1)이면 바로 갱신
//        if segmentIndexNum == 1 || segmentView.tabBar.selectedSegmentIndex == 1 {
//            DispatchQueue.main.async {
//                self.segmentView.lyricsCollectionView.reloadData()
//            }
//        }
    }


// 트랙 가져오는 api
//    private func fetchNextTracks() {
//        musicService.selection { [weak self] result in
//            switch result {
//            case .success(let response):
//                guard let data = response else { return }
//                self?.nextTracks = data
//                DispatchQueue.main.async {
//                    self?.segmentView.nextTrackCollectionView.reloadData()
//                }
//            case .failure(let error):
//                print("다음 트랙 에러: \(error)")
//            }
//        }
//    }
// 앨범 추천 
    private func fetchRecommendAlbums() {
        albumService.albumRecommendAlbum { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                self?.recommendAlbums = data
                self?.segmentView.albumRecommendCollectionView.reloadData()
            case .failure(let error):
                print("추천 앨범 에러: \(error)")
            }
        }
    }
// 추천 2
    private func fetchRecommendMusic(retryCount : Int = 0) {
        musicService.homeRecommendMusic { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                self?.recommendMusic = data
                self?.segmentView.albumCollectionView.reloadData()
            case .failure(let error):
                print("추천 음악 에러: \(error)")
                if retryCount < 3 {
                                print("재시도 \(retryCount + 1)회")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1초 뒤 재시도
                                    self?.fetchRecommendMusic(retryCount: retryCount + 1)
                                }
                            } else {
                                print("최대 재시도 횟수 초과")
                            }
                        }
            }
        }
    
    // 다음트랙 받아오기
    public func setInfo(segmentIndex: Int, lyrics: [String]?, nextTracks: [SelectionResponseDTO]) {
        self.segmentIndexNum = segmentIndex
        self.lyrics = lyrics
        self.nextTracks = nextTracks.isEmpty ? Constant.NextTrackLoadingData : nextTracks
        
        self.segmentView.nextTrackCollectionView.reloadData()
        self.segmentView.lyricsCollectionView.reloadData()
        segmentChanged()
    }
    
    // 뮤직 아이디 받아오기
    private func fetchMusicId() {
        guard let music = musicTitle else { return }
        musicService.allInfo(music: music) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let musicId = response.music.info.id else { return }
                self.postAddMusicInLibary(musicId: musicId)
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 노래 재생 / 정지 버튼
    @objc private func touchUpInsidePlayButton() {
        (self.presentingViewController as? MusicLoadVC)?.playPauseMusic()
    }
    
    // 라이브러리 저장 버튼
    @objc private func touchUpInsideLibraryButton() {
        fetchMusicId()
    }
}


extension MusicSegmentVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == segmentView.nextTrackCollectionView {
            return nextTracks?.count ?? 0
        } else if collectionView == segmentView.lyricsCollectionView {
            return lyrics?.count ?? 0
        } else if collectionView == segmentView.albumCollectionView {
            return recommendMusic.count
        } else if collectionView == segmentView.albumRecommendCollectionView {
            return recommendAlbums.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case segmentView.nextTrackCollectionView: // 다음 트랙
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.identifier, for: indexPath) as? TrackCell else {
                return UICollectionViewCell()
            }
            guard let trackData = nextTracks?[indexPath.row] else { return cell }
            cell.configure(dto: trackData)

            // 노래 재생 제스처
            let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
            musicGesture.musicTitle = trackData.music.title
            musicGesture.musicId = trackData.music.id
            musicGesture.musicImageURL = trackData.music.image
            musicGesture.artist = trackData.artist
            cell.touchView.addGestureRecognizer(musicGesture)
            cell.touchView.isUserInteractionEnabled = true

            // 아티스트 탭 제스처
            let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
            tapArtistGesture.artist = trackData.artist
            tapArtistGesture.album = trackData.album.title
            cell.detailLabel.addGestureRecognizer(tapArtistGesture)
            cell.detailLabel.isUserInteractionEnabled = true

            // 앨범 으로 이동 제스처
            let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
            tapAlbumGesture.artist = trackData.artist
            tapAlbumGesture.album = trackData.album.title
            cell.overflowView.goToAlbumButton.isUserInteractionEnabled = true
            cell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)

            // etc 버튼 눌렀을 때의 제스처
            cell.moreButton.addTarget(self, action: #selector(self.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
            cell.setOverflowView(type: .other)
            
            // 노래 보관함으로 이동 탭 제스처
            let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self.goToLibrary(_:)))
            tapGoToLibraryGesture.musicId = trackData.music.id
            cell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
            
            
            return cell
        case segmentView.lyricsCollectionView: // 가사
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LyricsCell.identifier, for: indexPath) as? LyricsCell else {
                fatalError("LyricsCell 에러")
            }
            let isHighlighted = indexPath.row == (lyrics?.count ?? 0) / 2
            cell.configure(text: lyrics?[indexPath.row] ?? "", isHighlighted: isHighlighted)
            return cell
        case segmentView.albumCollectionView: // 추천 앨범
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.identifier, for: indexPath) as? TrackCell else {
                return UICollectionViewCell()
            }
            let trackData = recommendMusic[indexPath.row]
            cell.configure(dto: trackData)

            // 노래 재생 제스처
            let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
            musicGesture.musicTitle = trackData.album.title
            musicGesture.musicId = trackData.music.id
            musicGesture.musicImageURL = trackData.music.image
            musicGesture.artist = trackData.artist
            cell.titleLabel.addGestureRecognizer(musicGesture)
            cell.albumImageView.addGestureRecognizer(musicGesture)

            // 아티스트 탭 제스처
            let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
            tapArtistGesture.artist = trackData.artist
            tapArtistGesture.album = trackData.album.title
            cell.detailLabel.addGestureRecognizer(tapArtistGesture)
            cell.detailLabel.isUserInteractionEnabled = true

            // 앨범 으로 이동 제스처
            let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
            tapAlbumGesture.artist = trackData.artist
            tapAlbumGesture.album = trackData.music.albumId
            cell.overflowView.goToAlbumButton.isUserInteractionEnabled = true
            cell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)

            // etc 버튼 눌렀을 때의 제스처
            let songEtcTapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpInsideOverflowButton(_:)))
            cell.moreButton.addGestureRecognizer(songEtcTapGesture)
            songEtcTapGesture.delegate = self
            cell.moreButton.isUserInteractionEnabled = true
            cell.setOverflowView(type: .inLibrary)

            
            return cell
        case segmentView.albumRecommendCollectionView: // 엘범 추천
            // 앨범 추천 - 가로 스크롤
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else {
                fatalError("AlbumCell 에러")
            }
            let recommendAlbums = recommendAlbums[indexPath.row]
            cell.configure(dto: recommendAlbums)
            
            // 앨범 선택 제스처
            let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
            tapAlbumGesture.artist = recommendAlbums.artist
            tapAlbumGesture.album = recommendAlbums.album.title
            cell.albumImageView.addGestureRecognizer(tapAlbumGesture)
            cell.albumImageView.isUserInteractionEnabled = true
            
            // 아티스트 선택 제스처
            let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
            tapArtistGesture.artist = recommendAlbums.artist
            tapArtistGesture.album = recommendAlbums.album.title
            cell.artistLabel.addGestureRecognizer(tapArtistGesture)
            cell.artistLabel.isUserInteractionEnabled = true
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// 제스처 함수 - Extension
extension MusicSegmentVC: UIGestureRecognizerDelegate  {
    
    // 제스처 설정 (overflowView - hidden 처리)
    private func setGesture() {
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        segmentView.addGestureRecognizer(tapGesture)
    }
    
    // overflow 버튼 클릭 시 실행될 메서드
    @objc private func touchUpInsideOverflowButton(_ sender: UIButton) {
        // 버튼의 superview를 통해 셀 찾기
        guard let cell = sender.superview as? TrackCell ?? sender.superview?.superview as? TrackCell else { return }

        // isHidden 토글
        cell.overflowView.isHidden.toggle()
    }
    
    // overflow 버튼 영역 외부 터치 실행될 메서드
    @objc private func dismissOverflowView(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: segmentView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in segmentView.nextTrackCollectionView.visibleCells {
            if let verticalCell = cell as? TrackCell {
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
//        (self.tabBarController as? TabBarViewController)?.setFloatingView()
        
        (self.presentingViewController as? MusicLoadVC)?.musicLoad(playMusic: true, artist: artist, music: musicTitle)
        
        print("musicPlayingGesture")
    }
    
    // 앨범 버튼
    @objc private func tapGoToAlbumGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        print("TapAlbumImageGesture: \(album), \(artist)")
        let nextVC = AlbumViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    @objc private func tapArtistLabelGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        
        // 최상위 모달을 dismiss 후
//        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
//            // dismiss가 완료된 후 presentingViewController에서 navigationController를 참조
//            let nextVC = ArtistViewController(artist: artist, album: album)
//            if let navigationController = self.presentingViewController?.navigationController {
//                navigationController.pushViewController(nextVC, animated: true)
//            }
//        })
        
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
//
        print("tapArtistLabelGesture")
    }

    
    // 자세히 보기 버튼
    private func tapDetailButton(for section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>) {
        let nextVC = DetailViewController(section: section, item: item)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
extension UIView {
    func findCollectionViewCell() -> UICollectionViewCell? {
        var superview = self.superview
        while let view = superview {
            if let cell = view as? UICollectionViewCell {
                return cell
            }
            superview = view.superview
        }
        return nil
    }
}
