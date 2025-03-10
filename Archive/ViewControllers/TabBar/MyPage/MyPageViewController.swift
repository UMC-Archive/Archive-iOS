//
//  MyPageViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/14/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    let rootView = MyPageView()
    let gradient = CAGradientLayer()
    let userService = UserService()
    let musicService = MusicService()
    public var genreResponseDate: [GenrePreferenceResponseDTO]?
    var musicInfo: MusicInfoResponseDTO? = nil
    var recentlyData: [RecentMusicResponseDTO]?
    var recentlyPlayData: [RecentPlayMusicResponseDTO]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileImage() // 프로필 설정 함수
        getGenre()
        getRecentMusic()
        getRecentlyPlayedMusic()
        setData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.view = rootView
        
        self.navigationController?.navigationBar.isHidden = true
        
        buildGradient()
        controlTapped()
        setDataSource()
        
        
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // rootView의 크기가 업데이트된 후 gradient의 프레임을 설정
        gradient.frame = rootView.CDView.bounds
    }
    private func getGenre(){
        userService.getGenrePreference(){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                Task{
                    
                    self.genreResponseDate = response
                    self.buildGradient()
                    
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func setDataSource(){
        rootView.recordCollectionView.dataSource = self
        rootView.recentCollectionView.dataSource = self
    }
    private func setData(){
        rootView.profileLabel.text = KeychainService.shared.load(account: .userInfo, service: .nickname)
    }
    private func controlTapped(){
        rootView.goRecapButton.addTarget(self, action: #selector(recapButtonTapped), for: .touchUpInside)
        // headerButton에 UITapGestureRecognizer 추가
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerButtonTapped))
        rootView.headerButton.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.headerButton.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(headerButtonTapped2))
        rootView.headerButton2.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.headerButton2.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(arrowButtonTapped))
        rootView.arrowButton.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.arrowButton.addGestureRecognizer(tapGesture3)
        
        rootView.topView.exploreIconButton.addTarget(self, action: #selector(exploreIconTapped), for: .touchUpInside)
    }
    @objc func exploreIconTapped(){
        let viewController = DatePickerViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func recapButtonTapped(){
        if genreResponseDate?.count ?? 2 <= 2 { //장르가 두개 이하면 아직 데이트를 수집중이라는 메시지 띄움
            let alert = RecapAlert.shared.getAlertController(type: .recap)
            self.present(alert, animated: true)
            return
        }
        let viewController = RecapViewController(data: genreResponseDate ?? [])
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    // 제스처에 대응하는 함수
    @objc private func headerButtonTapped() {
        
        let viewController = ListenRecordViewController()
        viewController.responseData = self.recentlyPlayData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    // 제스처에 대응하는 함수
    @objc private func headerButtonTapped2() {
        let viewController = RecentMusicViewController()
        viewController.responseData = self.recentlyData
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    @objc private func arrowButtonTapped() {
        let viewController = ProfileChangeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func buildGradient() { //많이 들은 장르의 색깔에 따라 cd 생성
        let genreColors: [String: UIColor] = [ // 받아온 장르 데이터를 1대1로 대응시켜 색깔 적용
            "Pop": UIColor.Pop ?? .black,
            "HipHop": UIColor.HipHop ?? .black,
            "Afrobeats": UIColor.Afrobeats ?? .black,
            "Ballad": UIColor.Ballad ?? .black,
            "Disco": UIColor.Disco ?? .black,
            "Electronic": UIColor.Electronic ?? .black,
            "Funk": UIColor.Funk ?? .black,
            "Indie": UIColor.Indie ?? .black,
            "Jazz": UIColor.Jazz ?? .black,
            "Latin": UIColor.Latin ?? .black,
            "Phonk": UIColor.Phonk ?? .black,
            "Punk": UIColor.Punk ?? .black,
            "Rock": UIColor.Rock ?? .black,
            "Trot": UIColor.Trot ?? .black,
            "Other": UIColor.Other ?? .black
        ]
        
        gradient.type = .conic
        guard let data = genreResponseDate else {return}
        // genreResponseDate가 nil이 아니고 count가 5일 때
        if data.count == 5 , data[3].name == "Others" && data[4].name == "Others"{
            gradient.colors = [
                genreColors[data[0].name]?.cgColor ?? UIColor.white,
                genreColors[data[1].name]?.cgColor ?? UIColor.white,
                genreColors[data[2].name]?.cgColor ?? UIColor.white,
                genreColors[data[0].name]?.cgColor ?? UIColor.white,
            ]
            gradient.locations = [0.0, 0.16, 0.5, 0.84, 1.0]
           
        } else if data.count == 5 , data[4].name == "Others"{
            gradient.colors = [
                genreColors[data[0].name]?.cgColor ?? UIColor.white,
                genreColors[data[1].name]?.cgColor ?? UIColor.white,
                genreColors[data[2].name]?.cgColor ?? UIColor.white,
                genreColors[data[3].name]?.cgColor ?? UIColor.white,
                genreColors[data[0].name]?.cgColor ?? UIColor.white
            ]
            gradient.locations = [0.0, 0.125, 0.375, 0.625, 0.875, 1.0]
            
        }else if data.count == 5 {
            gradient.colors = [
                genreColors[data[0].name]?.cgColor ?? UIColor.white,
                genreColors[data[1].name]?.cgColor ?? UIColor.white,
                genreColors[data[2].name]?.cgColor ?? UIColor.white,
                genreColors[data[3].name]?.cgColor ?? UIColor.white,
                genreColors[data[4].name]?.cgColor ?? UIColor.white,
                genreColors[data[0].name]?.cgColor ?? UIColor.white
            ]
            gradient.locations = [0.0, 0.08, 0.25, 0.42, 0.59, 0.76, 0.92, 1.0] // 5개가 아니라 6개의 색으로 구성한 이유는 마지막 색이 끊겨보여서 한 색의 비율을 반으로 나눠 처음과 끝에 둬서 자연스럽게 만듬
        }
        else {
            gradient.colors = [
                UIColor.dance_100?.cgColor ?? UIColor.red,
                UIColor.dance_100?.cgColor ?? UIColor.red,
                UIColor.dance_100?.cgColor ?? UIColor.red,
                UIColor.dance_100?.cgColor ?? UIColor.red,
                UIColor.dance_100?.cgColor ?? UIColor.red,
                UIColor.dance_100?.cgColor ?? UIColor.red
            ]
            gradient.locations = [0.0, 0.08, 0.25, 0.42, 0.59, 0.76, 0.92, 1.0]

        }
        
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5) // 중심점
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)   // conic 그라데이션은 중심을 공유
        
        rootView.CDView.layer.addSublayer(gradient)
    }

    private func getRecentMusic(){
        userService.RecentlyMusic(){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                Task{
                    
                    
                    self.recentlyData = response
                    self.rootView.recentCollectionView.reloadData()
                    
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    private func getRecentlyPlayedMusic(){
        userService.RecentlyPlayedMusic(){[weak self] result in
            guard let self else {return}
            switch result {
            case .success(let response):
                Task{
                    
                    self.recentlyPlayData = response
                    self.rootView.recordCollectionView.reloadData()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
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
        let nextVC = AlbumViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
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
    
}
    
    extension MyPageViewController : UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch collectionView{
            case rootView.recordCollectionView :
                return recentlyPlayData?.count ?? 0
            case rootView.recentCollectionView :
                return recentlyData?.count ?? 3
            default :
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch collectionView{
            case rootView.recordCollectionView :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listenRecordCollectionViewIdentifier", for: indexPath)as? ListenRecordCollectionViewCell else {
                    fatalError("Failed to dequeue ListenRecordCollectionViewCell")
                }
                if let data = recentlyPlayData{
                    cell.configData(image: data[indexPath.row].music.image, albumName: data[indexPath.row].music.title, artist: data[indexPath.row].artist.name)
                    
                    // 노래 재생 제스처
                    let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
                    musicGesture.musicTitle = data[indexPath.row].music.title
                    musicGesture.musicId = data[indexPath.row].music.id
                    musicGesture.musicImageURL = data[indexPath.row].music.image
                    musicGesture.artist = data[indexPath.row].artist.name
                    cell.touchView.isUserInteractionEnabled = true
                    cell.touchView.addGestureRecognizer(musicGesture)
                    
                    // 아티스트 탭 제스처
                    let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                    tapArtistGesture.artist = data[indexPath.row].artist.name
                    tapArtistGesture.album = data[indexPath.row].album.title
                    cell.artistLabel.isUserInteractionEnabled = true
                    cell.artistLabel.addGestureRecognizer(tapArtistGesture)
                }else{
                    let dummy = ListenRecordModel.dummy()
                    
                    cell.config(image: dummy[indexPath.row].albumImage, albumName: dummy[indexPath.row].albumName)
                }
                
                return cell
                
            case rootView.recentCollectionView :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listenRecordCollectionViewIdentifier", for: indexPath)as? ListenRecordCollectionViewCell else {
                    fatalError("Failed to dequeue ListenRecordCollectionViewCell")
                }
                if let data = recentlyData{
                    cell.configData(image: data[indexPath.row].music.image, albumName: data[indexPath.row].music.title, artist: data[indexPath.row].artist.name)
                    // 노래 재생 제스처
                    let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
                    musicGesture.musicTitle = data[indexPath.row].music.title
                    musicGesture.musicId = data[indexPath.row].music.id
                    musicGesture.musicImageURL = data[indexPath.row].music.image
                    musicGesture.artist = data[indexPath.row].artist.name
                    cell.touchView.isUserInteractionEnabled = true
                    cell.touchView.addGestureRecognizer(musicGesture)
                    
                    // 아티스트 탭 제스처
                    let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
                    tapArtistGesture.artist = data[indexPath.row].artist.name
                    tapArtistGesture.album = data[indexPath.row].album.title
                    cell.artistLabel.isUserInteractionEnabled = true
                    cell.artistLabel.addGestureRecognizer(tapArtistGesture)
                }else{
                    let dummy = ListenRecordModel.dummy()
                    
                    cell.config(image: dummy[indexPath.row].albumImage, albumName: dummy[indexPath.row].albumName)
                }
                return cell
            default :
                fatalError("Unknown collection view")
                
            }
            
        }
        
        
        
        // 프로필 이미지 설정 함수
        private func setProfileImage() {
            if let profileImage = KeychainService.shared.load(account: .userInfo, service: .profileImage) {
                rootView.topView.config(profileImage: profileImage)
                self.rootView.profileView.kf.setImage(with: URL(string: profileImage))
            }
            
            if let nickname = KeychainService.shared.load(account: .userInfo, service: .nickname) {
                rootView.profileLabel.text = nickname
            }
        }
        
    }

