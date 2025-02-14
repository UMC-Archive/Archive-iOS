//
//  TabBarViewController.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

class TabBarViewController: UITabBarController {
    private let userService = UserService()
    private let floatingView = AlbumInfoView()
    public var isPlay = false
    public var artist: String?
    public var music: String?
    
    private let homeVC = UINavigationController(rootViewController: HomeViewController())
    private let exploreVC = UINavigationController(rootViewController: ExploreViewController())
    private let libraryVC = UINavigationController(rootViewController: LibraryMainViewController())
    private let myPageVC = UINavigationController(rootViewController: MyPageViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(floatingView)
        
        floatingView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top) // 탭 바 위에 배치
            make.height.equalTo(FloatingViewHeight)
         }

        setTabBarItem()
        setFloatingView()
        setAction()
    }
    
    private func setAction() {
        
        // 재생 버튼
        floatingView.playButton.addTarget(self, action: #selector(touchUpInsidePlayButton), for: .touchUpInside)
        
        // 플레이 리스트 버튼
        floatingView.overlappingSquaresButton.addTarget(self, action: #selector(touchUpInsidePlaylist), for: .touchUpInside)
        
        // 음악 정보 뷰 터치
        let musicInfoGeture = UITapGestureRecognizer(target: self, action: #selector(musicInfoTapGesture(_:)))
        floatingView.musicInfoGroupView.addGestureRecognizer(musicInfoGeture)
    }
    
    // 음악 정보 뷰 탭 제스처
    @objc private func musicInfoTapGesture(_ sender: UITapGestureRecognizer) {
     
        let nextVC = MusicLoadVC()
    }
    
    
    // 재생 목록 버튼을 눌렀을 때
    @objc private func touchUpInsidePlaylist() {
        // songList로 화면 이동
        print("touchUpInsidePlaylist()")
    }
    
    // 노래 재생 버튼을 눌렀을 때
    @objc private func touchUpInsidePlayButton() {
        // 노래 재생 중일 때 -> 노래 멈춤, 버튼 이미지 변경
        // 노래 재생 중이지 않을 때,
        isPlay.toggle()
        floatingView.playingMusic(isPlay: isPlay)
        
        // 노래 멈추기 / 재생 로직 구현
    }
    
    // 노래 재생 (musicInfoResponseDTO를 파라미터로 받아도 됨)
    public func playingMusic(musicId: String, imageURL: String, musicTitle: String, artist: String) {
        floatingView.configure(albumImage: imageURL, songTitle: musicTitle, artistName: artist)
        
        let nextVC = MusicLoadVC(artist: artist, music: musicTitle)
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
    // 플로팅 뷰 (음악 재생뷰) 설정
    public func setFloatingView() {
        // 키체인에 저장된 음악 정보 가져오기
        guard let musicId = KeychainService.shared.load(account: .musicInfo, service: .musicId),
              let musicTitle = KeychainService.shared.load(account: .musicInfo, service: .musicTitle),
              let musicImageURL = KeychainService.shared.load(account: .musicInfo, service: .musicImageURL),
              let artist = KeychainService.shared.load(account: .musicInfo, service: .artist)
        else { // 재생 중인 곡이 없으면 emptyView 보이기
            hiddenView(isNullData: true)
            return
        }
        
        hiddenView(isNullData: false)
        self.playingMusic(musicId: musicId, imageURL: musicImageURL, musicTitle: musicTitle, artist: artist)
    }
    
    // 음악 재생 정보에 따른 히든 처리
    private func hiddenView(isNullData: Bool) {
        floatingView.emptyLabel.isHidden = !isNullData
        floatingView.playButton.isHidden = isNullData
        floatingView.overlappingSquaresButton.isHidden = isNullData
    }
    
    // 탭 바 설정
    private func setTabBarItem() {
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: .homeOn, tag: 0)
        exploreVC.tabBarItem = UITabBarItem(title: "탐색", image: .exploreOn, tag: 1)
        libraryVC.tabBarItem = UITabBarItem(title: "보관함", image: .libraryOn, tag: 2)
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: .myPageOn, tag: 3)
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        self.viewControllers = [homeVC, exploreVC, libraryVC, myPageVC]
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .white_35 // 선택되지 않은 아이템의 색상
        self.tabBar.isTranslucent = false   // 탭 바의 배경 불투명으로 설정
        self.tabBar.backgroundColor = UIColor.black_100
        self.view.backgroundColor = UIColor.black_100
    }
    
    // 사용자 정보 불러오기
    private func getUserInfo() {
        userService.userInfo { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                guard let response = response else { return }
                // 키체인 저장
                KeychainService.shared.save(account: .userInfo, service: .profileImage, value: response.profileImage)
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
}
