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
    
    private let musicService = MusicService()
    private let albumService = AlbumService()
    private let libraryService = LibraryService()
    
    private var mainCDData: [MainCDResponseDTO] = Constant.MainCDLoadingData// 메인 CD 데이터
    private var hiddenMusic: [(HiddenMusicResponse, ExploreRecommendAlbum, String)] = Constant.HiddenMusicLoadingData // 숨겨진 명곡 데이터
    private var recommendMusic: [(ExploreRecommendMusic, ExploreRecommendAlbum, String)] = Constant.ExploreRecommnedMusicLoadingData // 추천 음악 데이터
    private var recommendAlbumData: [(ExploreRecommendAlbum, String)] = Constant.RecommendAlbumLoadingData // 추천 앨범 데이터
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
        setProfileImage() // 프로필 설정
        setTime() // 년도 설정
    }
    
    // 프로필 이미지 설정 함수
    private func setProfileImage() {
        if let profileImage = KeychainService.shared.load(account: .userInfo, service: .profileImage) {
            exploreView.topView.config(profileImage: profileImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        setDataSource()
        setSnapShot()
        setDelegate()
        setGesture()
        setTarget()

        view = exploreView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let contentHeight = calculateScrollViewHeight()
        exploreView.contentView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }
        
        exploreView.layoutIfNeeded()
    }
    
    // 타겟 설정
    private func setTarget() {
        exploreView.resetButton.addTarget(self, action: #selector(touchUpInsideResetButton), for: .touchUpInside)
    }
    
    // 년도 설정 버튼 액션
    @objc private func touchUpInsideResetButton() {
        let nextVC = DatePickerViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 선택 년도 가져오기
    private func setTime() {
        
        // 년도 탐색을 하지 않은 경우 - 년도 설정으로 이동
        guard let time = KeychainService.shared.load(account: .userInfo, service: .timeHistory) else {
            let alert = UIAlertController(title: "시대 별 음악 탐색하기", message: "탐색년도를 설정해주세요!", preferredStyle: .alert)
            
            // 취소 액션 - 홈뷰로 이동
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                self.tabBarController?.selectedIndex = 0
            }
            
            // 년도 설정으로 이동
            let alertAction = UIAlertAction(title: "탐색하기", style: .default, handler: { _ in
                self.touchUpInsideResetButton()
            })
            
            alert.addAction(cancelAction)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
                                
            return
        }
        
        mainCDData = Constant.MainCDLoadingData// 메인 CD 데이터 초기화
        hiddenMusic = Constant.HiddenMusicLoadingData // 숨겨진 명곡 데이터 초기화
        recommendMusic = Constant.ExploreRecommnedMusicLoadingData // 추천 음악 데이터 초기화
        recommendAlbumData = Constant.RecommendAlbumLoadingData // 추천 앨범 데이터 초기화
        exploreView.recapCollectionView.reloadData()
        setDataSource()
        setSnapShot()
        
        exploreView.config(time: time)
        getHiddenMusic()    // 숨겨진 명곡 조회 API
        getRecommendMusic() // 추천 음악 API
        getRecommendAlbum() // 당신을 위한 앨범 추천 API
        getMainCD()         // 메인 CD API
        
    }
    
    // 컬렉션 뷰 높이 구하는 함수
    private func calculateCollectionViewHeight() -> CGFloat {
        // 각 섹션의 높이 정의
        let verticalSectionHeight: CGFloat = 275 + (10 * 3) + 45 // 그룹 높이 + 간격 + 헤더
        let bannerSectionHeight: CGFloat = 186 + 45 // 그룹 높이 + 헤더
        let interSectionSpacing: CGFloat = 40 // 섹션 간 간격

        // 섹션 높이 합계
        let totalCollectionViewHeight = (verticalSectionHeight * 2) + bannerSectionHeight + (interSectionSpacing * 2)
        return totalCollectionViewHeight
    }
    
    // 스크롤 뷰의 높이 구하는 함수
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
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: exploreView.collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .ExploreRecommendMusic(music, album, artist): // 당신을 위한 추천곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                verticalCell.configExploreRecommendMusic(music: music, artist: artist)
                
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
            case let .HiddenMusic(music, album, artist): // 숨겨진 명곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                verticalCell.configHiddenMusic(music: music, artist: artist)
                
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
            case let .ExploreRecommendAlbum(album, artist): // 당신을 위한 추천 앨범
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                guard let bannerCell = cell as? BannerCell else {return cell}
                bannerCell.configExploreRecommendAlbum(album: album, artist: artist)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.tapGoToAlbumGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.tapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self,
                  let section = self.dataSource?.sectionIdentifier(for: indexPath.section),
                  let item = self.dataSource?.snapshot(for: section)
            else {
                return UICollectionReusableView()
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            // 버튼에 UIAction 추가
            (headerView as? HeaderView)?.detailButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.tapDetailButton(for: section, item: item)
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
    
    private func setSnapShot() {

        // 스냅샷 생성
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // 섹션 정의
        let recommendMusicSection = Section.Vertical(.RecommendMusic) // 당신을 위한 추천곡
        let recommendAlbumSection = Section.Banner(.RecommendAlbum) // 당신을 위한 앨범 추천
        let hiddenMusicSection = Section.Vertical(.HiddenMusic) // 숨겨진 명곡
        
        
        // 섹션 추가
        snapshot.appendSections([recommendMusicSection, recommendAlbumSection, hiddenMusicSection])

        // 추천곡
        
            let recommendMusicItem = recommendMusic.map{Item.ExploreRecommendMusic($0.0, $0.1, $0.2)}// 추천곡
            snapshot.appendItems(recommendMusicItem, toSection: recommendMusicSection)
        
       
        // 숨겨진 명곡
        
            let hiddenMusicItem = hiddenMusic.map{Item.HiddenMusic($0.0, $0.1, $0.2)}
            snapshot.appendItems(hiddenMusicItem, toSection: hiddenMusicSection)
        
        
        // 당신을 위한 추천 앨범
        
            let recommendAlbumItem = recommendAlbumData.map{Item.ExploreRecommendAlbum($0.0, $0.1)}
            snapshot.appendItems(recommendAlbumItem, toSection: recommendAlbumSection)
        
        
        dataSource?.apply(snapshot)
    }
    
    // 당신을 위한 추천곡 API
    private func getRecommendMusic() {
        musicService.exploreRecommendMusic(){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let response = response else {return}
                self.recommendMusic = response.map{($0.music, $0.album, $0.artist)}
                self.setDataSource()
                self.setSnapShot()
                
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getRetryAlertController(title: "당신을 위한 추천곡" , description: error.description, retryAction: getRecommendMusic)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 당신을 위한 앨범 추천 API
    private func getRecommendAlbum() {
        albumService.exploreRecommendAlbum(){ [weak self] result in // 반환값 result의 타입은 Result<[RecommendAlbumResponseDTO]?, NetworkError>
            guard let self = self else { return }
            switch result {
            case .success(let response): // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
                guard let response = response else {return}

                self.recommendAlbumData = response.map{($0.album, $0.artist)}
                setDataSource()
                setSnapShot()
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getRetryAlertController(title: "당신을 위한 앨범 추천" , description: error.description, retryAction: getRecommendAlbum)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 숨겨진 명곡 조회 API
    private func getHiddenMusic() {
        musicService.hiddenMusic(){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else {return}

    
                self.hiddenMusic = response.map{($0.music, $0.album, $0.artist)}
                self.setDataSource()
                self.setSnapShot()
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getRetryAlertController(title: "숨겨진 명곡" , description: error.description, retryAction: getHiddenMusic)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 메인 CD API
    private func getMainCD() {
        musicService.mainCD { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else {return}
                self.mainCDData = response
                self.exploreView.recapCollectionView.reloadData()
                self.setRecapIndex()
            case .failure(let error):
                let alert = NetworkAlert.shared.getRetryAlertController(title: "메인 CD" , description: error.description, retryAction: getMainCD)
                self.present(alert, animated: true)
            }
        }
    }
}

// 제스처 함수 - Extension
extension ExploreViewController: UIGestureRecognizerDelegate  {
    
    // 제스처 설정 (overflowView - hidden 처리)
    private func setGesture() {
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        exploreView.addGestureRecognizer(tapGesture)
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
        let touchLocation = gesture.location(in: exploreView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in exploreView.collectionView.visibleCells {
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

// UICollectionViewDataSource - Extension
extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case exploreView.recapCollectionView:
            return self.mainCDData.count == 1 ? 1 : 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case exploreView.recapCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecapCollectionViewCell.recapCollectionViewIdentifier, for: indexPath)
           
            (cell as? RecapCollectionViewCell)?.configMainCD(data: mainCDData[indexPath.row])
            
            // 노래 재생 제스처
            let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
            musicGesture.musicTitle = mainCDData[indexPath.row].music.title
            musicGesture.musicId = mainCDData[indexPath.row].music.id
            musicGesture.musicImageURL = mainCDData[indexPath.row].music.image
            musicGesture.artist = mainCDData[indexPath.row].artist
            (cell as? RecapCollectionViewCell)?.cdView.addGestureRecognizer(musicGesture)
            
            // 아티스트 탭 제스처
            let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
            tapArtistGesture.artist = mainCDData[indexPath.row].artist
            tapArtistGesture.album = mainCDData[indexPath.row].album.title
            (cell as? RecapCollectionViewCell)?.artist.addGestureRecognizer(tapArtistGesture)
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
