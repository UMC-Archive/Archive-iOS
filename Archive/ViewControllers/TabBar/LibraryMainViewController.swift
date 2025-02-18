//
//  LibraryMainViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/9/25.
//

import UIKit

class LibraryMainViewController: UIViewController, UIGestureRecognizerDelegate {
    let rootView = LibraryMainView()
    
    private var segmentIndexNum: Int = 0
    private let libraryService = LibraryService()
    private var musicResponse: [LibraryMusicResponseDTO]?
    private var artistResponse : [LibraryArtistResponseDTO]?
    private var albumResponse : [LibraryAlbumResponseDTO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = rootView
        rootView.backgroundColor = UIColor.black_100
        self.navigationController?.navigationBar.isHidden = true
        datasourceSetting()
        hideAllCollectionViews()
        setupActions()
        showCollectionView(for: segmentIndexNum)
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        navigationController?.navigationBar.isHidden = false
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        getArtistInfo()
        getAlbumInfo()
        getMusicInfo()
        setProfileImage()
    }
    
    // 프로필 이미지 설정 함수
    private func setProfileImage() {
        if let profileImage = KeychainService.shared.load(account: .userInfo, service: .profileImage) {
            rootView.topView.profileImageView.kf.setImage(with: URL(string: profileImage))
        }
    }

    private func datasourceSetting() {
        rootView.playlistCollectionView.dataSource = self
        rootView.songCollectionView.dataSource = self
        rootView.albumCollectionView.dataSource = self
        rootView.artistCollectionView.dataSource = self
    }
    
    private func setupActions() {
        rootView.librarySegmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exploreIconTapped))
        rootView.topView.exploreIconButton.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.topView.exploreIconButton.addGestureRecognizer(tapGesture)
        
        
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let overflowElseTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        overflowElseTapGesture.cancelsTouchesInView = false
        overflowElseTapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        rootView.addGestureRecognizer(overflowElseTapGesture)
        
    }
    
    @objc private func touchUpInsideOverflowButton(_ gesture: UITapGestureRecognizer) {
        print("---")
        
        switch gesture.view?.superview {
        case let cell as LibrarySongCollectionViewCell:
            // 첫 번째 superview로 셀 찾기
            cell.overflowView.isHidden.toggle()
        case let cell as ArtistCollectionViewCell?:
            // 두 번째 superview로 셀 찾기
            cell?.overflowView.isHidden.toggle()
        default:
            break
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




           
    @objc func exploreIconTapped(){
        let viewController = DatePickerViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @objc private func segmentChanged() {
        segmentIndexNum = rootView.librarySegmentControl.selectedSegmentIndex
        let underbarWidth = rootView.librarySegmentControl.frame.width / 4
        let newLeading = CGFloat(segmentIndexNum) * underbarWidth
        
        
        // 언더바 이동 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.rootView.selectedUnderbar.snp.updateConstraints {
                $0.leading.equalTo(self.rootView.librarySegmentControl.snp.leading).offset(newLeading)
                $0.width.equalTo(underbarWidth)
            }
            print(self.segmentIndexNum)
            self.rootView.layoutIfNeeded()
        })
        hideAllCollectionViews()
        showCollectionView(for: segmentIndexNum)
    }
    
    private func hideAllCollectionViews() {
        rootView.playlistCollectionView.isHidden = true
        rootView.songCollectionView.isHidden = true
        rootView.albumCollectionView.isHidden = true
        rootView.artistCollectionView.isHidden = true
    }
    
    private func showCollectionView(for index: Int) {
           switch index {
           case 0:
               rootView.playlistCollectionView.isHidden = false
           case 1:
               rootView.songCollectionView.isHidden = false
           case 2:
               rootView.albumCollectionView.isHidden = false
           case 3:
               rootView.artistCollectionView.isHidden = false
           default:
               break
           }
           rootView.layoutIfNeeded()
       }
    func getMusicInfo(){
        libraryService.libraryMusicInfo(){[weak self] result in
            guard let self = self else { return }
            
            switch result {
                        // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
            case .success(let response): // response는 AlbumInfoReponseDTO 타입
                print("libraryMusic 성공 ")
                Task{
                    self.musicResponse = response
                    self.rootView.songCollectionView.reloadData()
                }
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description) // 얼럿 생성
                self.present(alert, animated: true) // 얼럿 띄우기
                print("실패: \(error.description)")
            }
        }
    }
    func getArtistInfo(){
        libraryService.libraryArtistInfo(){[weak self] result in
            guard let self = self else { return }
            
            switch result {
                        // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
            case .success(let response): // response는 AlbumInfoReponseDTO 타입
                print("libraryAtrist성공 ")
                Task{
                    self.artistResponse = response
                    self.rootView.artistCollectionView.reloadData()
                }
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description) // 얼럿 생성
                self.present(alert, animated: true) // 얼럿 띄우기
                print("실패: \(error.description)")
            }
        }
    }
    func getAlbumInfo(){
        libraryService.libraryAlbumInfo(){[weak self] result in
            guard let self = self else { return }
            
            switch result {
                        // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
            case .success(let response): // response는 AlbumInfoReponseDTO 타입
                print("libraryAlbum성공 ")
                           
                Task{
                    self.albumResponse = response
                    self.rootView.albumCollectionView.reloadData()
                }
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description) // 얼럿 생성
                self.present(alert, animated: true) // 얼럿 띄우기
                print("실패: \(error.description)")
            }
        }
    }
   
    
    // overflow 버튼 영역 외부 터치 실행될 메서드
    @objc private func dismissOverflowView(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: rootView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in rootView.songCollectionView.visibleCells {
            if let verticalCell = cell as? LibrarySongCollectionViewCell {
                if !verticalCell.overflowView.frame.contains(touchLocation) {
                    verticalCell.overflowView.isHidden = true
                }
            }
        }
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in rootView.artistCollectionView.visibleCells {
            if let verticalCell = cell as? ArtistCollectionViewCell {
                if !verticalCell.overflowView.frame.contains(touchLocation) {
                    verticalCell.overflowView.isHidden = true
                }
            }
        }

    }
    @objc private func songDelete(_ sender: CustomTapGesture) {
        guard let musicId = sender.musicId else {
            print("nil")
            return }
        print("-------musicId\(musicId)")
        
        libraryService.musicDelete(musicId: musicId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print(response)
                Task{
                    
                    print("-----------------musicdelete 성공")
                    self.getMusicInfo()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                print("-----------fail")
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    @objc private func artistDelete(_ sender: CustomTapGesture) {
        guard let artistId = sender.artistId else {
            print("nil")
            return }
        print("-------musicId\(artistId)")
        
        libraryService.artistDelete(artistId: artistId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print(response)
                Task{
                    
                    print("-----------------artistdelete 성공")
                    self.getArtistInfo()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                print("-----------fail")
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    @objc private func albumDelete(_ sender: CustomTapGesture) {
        guard let albumId = sender.albumId else {
            print("nil")
            return }
        print("-------musicId\(albumId)")
        
        libraryService.albumDelete(albumId: albumId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print(response)
                Task{
                    
                    print("-----------------artistdelete 성공")
                    self.getAlbumInfo()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                print("-----------fail")
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    // 아티스트 버튼
    @objc private func tapArtistLabelGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else {return }
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    // 앨범 버튼
    @objc private func tapGoToAlbumGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        print("TapAlbumImageGesture: \(album), \(artist)")
        let nextVC = AlbumViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension LibraryMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case rootView.playlistCollectionView:
            return PlayListDummy.dummy().count
            
        case rootView.songCollectionView:
            //            getMusicInfo()
            return musicResponse?.count ?? 0
            
        case rootView.albumCollectionView:
            //            getAlbumInfo()
            return albumResponse?.count ?? 0
            
            
        case rootView.artistCollectionView:
            //            getArtistInfo()
            return artistResponse?.count ?? 0
            
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case rootView.playlistCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlayListCollectionViewCell.playListCollectionViewIdentifier,
                for: indexPath
            ) as? PlayListCollectionViewCell else {
                fatalError("Failed to dequeue PlayListCollectionViewCell")
            }
            let dummy = PlayListDummy.dummy()
            cell.config(image: dummy[indexPath.row].albumImage)
            return cell

        case rootView.songCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LibrarySongCollectionViewCell.librarySongCollectionViewIdentifier,
                for: indexPath
            ) as? LibrarySongCollectionViewCell else {
                fatalError("Failed to dequeue LibrarySongCollectionViewCell")
            }
//            let dummy = SongCollectionViewModel.dummy()
//            cell.config(
//                image: dummy[indexPath.row].albumImage,
//                songName: dummy[indexPath.row].songName,
//                artist: dummy[indexPath.row].artist,
//                year: dummy[indexPath.row].year
//            )
            cell.config(
                imageUrl: musicResponse?[indexPath.row].music.image ?? "",
                songName: musicResponse?[indexPath.row].music.title ?? "",
                artist: musicResponse?[indexPath.row].artist ?? "",
                year: String(musicResponse?[indexPath.row].music.releaseTime ?? 0 ) ?? ""
            )
            
            
            let songEtcTapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpInsideOverflowButton(_:)))
            cell.etcImage.addGestureRecognizer(songEtcTapGesture)
            songEtcTapGesture.delegate = self
            cell.etcImage.isUserInteractionEnabled = true
            cell.setOverflowView(type: .inLibrary)
            
            let songDeleteGesture = CustomTapGesture(target: self, action: #selector(songDelete))
            songDeleteGesture.musicId = musicResponse?[indexPath.row].music.id ?? "0"
            cell.overflowView.libraryButton.addGestureRecognizer(songDeleteGesture)
            
            // 앨범 으로 이동 제스처
            let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
            tapAlbumGesture.artist = musicResponse?[indexPath.row].artist
            tapAlbumGesture.album = musicResponse?[indexPath.row].album.title
            cell.overflowView.goToAlbumButton.isUserInteractionEnabled = true
            cell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
            
            // 노래 재생 제스처
            let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
            musicGesture.musicTitle = musicResponse?[indexPath.row].music.title
            musicGesture.musicId = musicResponse?[indexPath.row].music.id
            musicGesture.musicImageURL = musicResponse?[indexPath.row].music.image
            musicGesture.artist = musicResponse?[indexPath.row].artist
            cell.touchView.isUserInteractionEnabled = true
            cell.touchView.addGestureRecognizer(musicGesture)


            // 아티스트 탭 제스처
            let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
            tapArtistGesture.artist = musicResponse?[indexPath.row].artist
            tapArtistGesture.album = musicResponse?[indexPath.row].album.title
            cell.artistYearLabel.isUserInteractionEnabled = true
            cell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
            return cell
            
        case rootView.albumCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AlbumCollectionViewCell.albumCollectionViewIdentifier,
                for: indexPath
            ) as? AlbumCollectionViewCell else {
                fatalError("Failed to dequeue albumCollectionViewCell")
            }
//            let dummy = AlbumModel.dummy()
//            cell.config(
//                image: dummy[indexPath.row].albumImage,
//                albumName: dummy[indexPath.row].albumName
//            )
            cell.config(
                image: albumResponse?[indexPath.row].image ?? "",
                albumName: albumResponse?[indexPath.row].title ?? "",
                artist: albumResponse?[indexPath.row].artist ?? ""
                
            )

            
            // 앨범 탭 제스처
            let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
            tapAlbumGesture.artist = albumResponse?[indexPath.row].artist
            tapAlbumGesture.album = albumResponse?[indexPath.row].title
            cell.touchView.isUserInteractionEnabled = true
            cell.touchView.addGestureRecognizer(tapAlbumGesture)
            
            // 아티스트 탭 제스처
            let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
            tapArtistGesture.artist = albumResponse?[indexPath.row].artist
            tapArtistGesture.album = albumResponse?[indexPath.row].title
            cell.artistLabel.isUserInteractionEnabled = true
            cell.artistLabel.addGestureRecognizer(tapArtistGesture)
            
            return cell
            
        case rootView.artistCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArtistCollectionViewCell.artistCollectionViewIdentifier,
                for: indexPath
            ) as? ArtistCollectionViewCell else {
                fatalError("Failed to dequeue genreCollectionViewCell")
            }
            let dummy = GenreModel.dummy()
//            cell.config(
//                image: dummy[indexPath.row].albumImage,
//                artistName: dummy[indexPath.row].artist
//            )
            cell.config(
                image: artistResponse?[indexPath.row].artist.image ?? "",
                artistName: artistResponse?[indexPath.row].artist.name ?? ""
            )
            let artistEtcTapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpInsideOverflowButton(_:)))
            cell.etcImage.addGestureRecognizer(artistEtcTapGesture)
            artistEtcTapGesture.delegate = self
            cell.etcImage.isUserInteractionEnabled = true
            cell.setOverflowView(type: .inLibrary)
            
            let artistDeleteGesture = CustomTapGesture(target: self, action: #selector(artistDelete))
            artistDeleteGesture.artistId = artistResponse?[indexPath.row].artist.id ?? "0"
            cell.overflowView.libraryButton.addGestureRecognizer(artistDeleteGesture)
            
            // 아티스트 탭 제스처
            let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
            tapArtistGesture.artist = artistResponse?[indexPath.row].artist.name
            tapArtistGesture.album = artistResponse?[indexPath.row].album[0].title
            cell.touchView.isUserInteractionEnabled = true
            cell.touchView.addGestureRecognizer(tapArtistGesture)
            
            // 앨범 으로 이동 제스처
            let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
            tapAlbumGesture.artist = artistResponse?[indexPath.row].artist.name
            tapAlbumGesture.album = artistResponse?[indexPath.row].album[0].title
            cell.overflowView.goToAlbumButton.isUserInteractionEnabled = true
            cell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
            
            
            return cell
        default:
            fatalError("Unknown UICollectionView")
        }
    }
}


