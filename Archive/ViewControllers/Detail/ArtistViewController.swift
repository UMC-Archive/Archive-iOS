//
//  ArtistViewController.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import UIKit

class ArtistViewController: UIViewController {
    private let musicService = MusicService()
    private var libraryService = LibraryService()
    
    private let artistView = ArtistView()
    private let artistData = ArtistDummyModel.dummy()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let gradientLayer = CAGradientLayer()
    private let artist: String
    private let album: String
    private var artistInfo: ArtistInfoReponseDTO?
    private var similarArtist: [(ArtistInfoReponseDTO, AlbumInfoReponseDTO)] = Constant.SimilarArtistLoadinData // 비슷한 아티스트
    private var popularMusic: [(MusicInfoResponseDTO, AlbumInfoReponseDTO, String)] = Constant.PopularMusicLoadingData // 아티스트 인기곡
    private var sameArtistAnoterAlbum: [(SameArtistAnotherAlbumResponseDTO, String)] = Constant.SameArtistAnotherAlbumLoadingData // 앨범 둘러보기

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
        
        view = artistView
        setNavigationBar()
        setAction()
        setDataSource()
        setSnapshot()
        setGesture()
        
        // 아티스트 정보 조회
        postArtistInfo(artist: artist, album: album)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    // 라이브러리 추가 버튼
    @objc private func tapAddLibrayButton() {
        guard let artist = artistInfo else { return }
        
        libraryService.artistPost(artistId: artist.id ){[weak self] result in
            guard let self = self else{return}
            switch result {
            case .success:
                let alert = LibraryAlert.shared.getAlertController(type: .artist)
                self.present(alert, animated: true)
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: artistView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .ArtistPopularMusic(music, album, artist):     // 아티스트 인기곡
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
                tapAlbumGesture.artist = self.artist
                tapAlbumGesture.album = album.title
                bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)

                return cell
            case .MusicVideo(let item):  // 아티스트 뮤직 비디오
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicVideoCell.id, for: indexPath)
                (cell as? MusicVideoCell)?.config(data: item)
                return cell
            case let .SimilarArtist(artist, album):  // 비슷한 아티스트
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCell.id, for: indexPath)
                
                // 탭 제스처
                let tapGesture = CustomTapGesture(target: self, action: #selector(self.tapSimilarArtist(_:)))
                tapGesture.artist = artist.name
                tapGesture.album = album.title
                cell.addGestureRecognizer(tapGesture)
                
                (cell as? CircleCell)?.config(artist: artist)
                return cell
            default:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self,
                  let section = self.dataSource?.sectionIdentifier(for: indexPath.section),
                    let item = dataSource?.snapshot(for: section) else {return UICollectionReusableView() }
            
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
            case .MusicVideoCell(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .Circle(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        }
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let popularMusicSection = Section.Vertical(.ArtistPopularMusic) // 아티스트 인기곡
        let sameArtistAnotherAlbumSection = Section.Banner(.SameArtistAnotherAlbum) // 앨범 둘러보기
        let musicVideoSection = Section.MusicVideoCell(.MusicVideo) // 뮤직 비디오
        let similarArtistSection = Section.Circle(.SimilarArtist)   // 다른 비슷한 아티스트
        
        snapshot.appendSections([popularMusicSection, sameArtistAnotherAlbumSection, similarArtistSection, musicVideoSection])
        
        // 아티스트 인기곡
        let popularMusicItem = popularMusic.map{Item.ArtistPopularMusic($0.0, $0.1, $0.2)}
        snapshot.appendItems(popularMusicItem, toSection: popularMusicSection)
        
        
        // 앨범 둘러보기
        let anotherAlbumItem = sameArtistAnoterAlbum.map{Item.SameArtistAnotherAlbum($0.0, $0.1)}
        snapshot.appendItems(anotherAlbumItem, toSection: sameArtistAnotherAlbumSection)
        
        
        // 뮤직 비디오
        let musicVideoItem = artistData.musicVideoList.map{Item.MusicVideo($0)}
        snapshot.appendItems(musicVideoItem, toSection: musicVideoSection)
        
        // 다른 비슷한 아티스트
        let similarArtistItem = similarArtist.map{Item.SimilarArtist($0.0, $0.1)}
        snapshot.appendItems(similarArtistItem, toSection: similarArtistSection)
        
        
        dataSource?.apply(snapshot)
    }
    
    
    private func setAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLabelLines))
        artistView.descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleLabelLines() {
        // numberOfLines 토글
        let newNumberOfLines = artistView.descriptionLabel.numberOfLines == 0 ? 3 : 0

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.artistView.descriptionLabel.numberOfLines = newNumberOfLines
            self?.artistView.layoutIfNeeded() // 애니메이션 반영
        }
    }
    
    
    // 아티스트 정보 가져오기 API
    func postArtistInfo(artist: String, album: String){
        musicService.artist(artist: artist, album: album){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let response = response else {return}
                self.artistInfo = response
                
                // 아티스트 큐레이션
                postArtistCuration(artistId: response.id)
                
                // 비슷한 아티스트 조회
                getSimilarArtist(artistId: response.id)
                
                // 아티스트 인기곡
                getArtistPopularMusic(artistId: response.id)
                
                // 앨범 둘러보기
                getSameArtistAnotherAlbum(artistId: response.id)

            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getRetryAlertController(title: "아티스트 정보" , description: error.description, retryAction: { [weak self] in
                    self?.postArtistInfo(artist: artist, album: album) // 🔄 재시도 버튼을 누르면 다시 API 호출
                })
                self.present(alert, animated: true)
            }
        }
    }
    
    // 아티스트 큐레이션 API
    func postArtistCuration(artistId: String){
        musicService.artistCuration(artistId: artistId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let response = response, let artistData = artistInfo else {return}
                artistView.config(artistInfo: artistData, curation: response)

            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getRetryAlertController(title: "아티스트 큐레이션" , description: error.description, retryAction: { [weak self] in
                    self?.postArtistCuration(artistId: artistId) // 🔄 재시도 버튼을 누르면 다시 API 호출
                })
                self.present(alert, animated: true)
            }
        }
    }
    
    // 비슷한 아티스트 조회
    private func getSimilarArtist(artistId: String){
        musicService.similarArtist(aristId: artistId) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                guard let response = response else { return }
                self.similarArtist = response.map{($0.artist, $0.album)}
                self.setDataSource()
                self.setSnapshot()
            case .failure(let error):
                let alert = NetworkAlert.shared.getRetryAlertController(title: "비슷한 아티스트" , description: error.description, retryAction: { [weak self] in
                    self?.getSimilarArtist(artistId: artistId) // 🔄 재시도 버튼을 누르면 다시 API 호출
                })
                self.present(alert, animated: true)
            }
        }
    }
    
    // 아티스트 인기곡 API
    private func getArtistPopularMusic(artistId: String) {
        musicService.artistPopularMusic(artistId: artistId) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let response = response else { return }
                popularMusic = response.map{($0.music, $0.album, $0.artist)}
                self.setDataSource()
                self.setSnapshot()
                
                
                // 아티스트 이미지 옆 재생 버튼 탭 제스처
                let playTabGesture = CustomTapGesture(target: self, action: #selector(musicPlayingGesture(_:)))
                playTabGesture.musicTitle = response.first?.music.title
                playTabGesture.musicId = response.first?.music.id
                playTabGesture.musicImageURL = response.first?.music.image
                playTabGesture.artist = self.artist
                artistView.playButton.addGestureRecognizer(playTabGesture)
                
            case .failure(let error):
                let alert = NetworkAlert.shared.getRetryAlertController(title: "아티스트 인기곡" , description: error.description, retryAction: { [weak self] in
                    self?.getArtistPopularMusic(artistId: artistId) // 🔄 재시도 버튼을 누르면 다시 API 호출
                })
                self.present(alert, animated: true)
            }
        }
    }
    
    // 앨범 둘러보기 API
    private func getSameArtistAnotherAlbum(artistId: String) {
        musicService.sameArtistAnotherAlbum(artistId: artistId) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let response = response else { return }
                sameArtistAnoterAlbum = response.map{($0, self.artist)}
                self.setDataSource()
                self.setSnapshot()
                
            case .failure(let error):
                let alert = NetworkAlert.shared.getRetryAlertController(title: "앨범 둘러보기" , description: error.description, retryAction: { [weak self] in
                    self?.getSameArtistAnotherAlbum(artistId: artistId) // 🔄 재시도 버튼을 누르면 다시 API 호출
                })
                self.present(alert, animated: true)
            }
        }
    }
}

// 제스처 함수 - Extension
extension ArtistViewController: UIGestureRecognizerDelegate  {
    
    // 제스처 설정 (overflowView - hidden 처리)
    private func setGesture() {
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        artistView.addGestureRecognizer(tapGesture)
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
        let touchLocation = gesture.location(in: artistView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in artistView.collectionView.visibleCells {
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
    
    // 자세히 보기 버튼
    private func tapDetailButton(for section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>) {
        let nextVC = DetailViewController(section: section, item: item)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 비슷한 아티스트 탭 제스처
    @objc private func tapSimilarArtist(_ sender: CustomTapGesture) {
        guard let artist = sender.artist, let album = sender.album else {return}
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
