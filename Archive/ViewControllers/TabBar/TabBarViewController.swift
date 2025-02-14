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
    
    private let homeVC = UINavigationController(rootViewController: HomeViewController())
    private let exploreVC = UINavigationController(rootViewController: ExploreViewController())
    private let libraryVC = UINavigationController(rootViewController: LibraryMainViewController())
    private let myPageVC = UINavigationController(rootViewController: MyPageViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarItem()
        setFloatingView()
        setAction()
    }
    
    private func setAction() {
        floatingView.playButton.addTarget(self, action: #selector(touchUpInsidePlayButton), for: .touchUpInside)
        floatingView.overlappingSquaresButton.addTarget(self, action: #selector(touchUpInsidePlaylist), for: .touchUpInside)
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
    public func playingMusic(musicId: String) {
        floatingView.configure(albumImage: .BTOB, songTitle: "POWER", artistName: "G-Dragon")
    }
    
    // 플로팅 뷰 (음악 재생뷰) 설정
    private func setFloatingView() {
        // 재생 중인 곡이 없으면 안 띄우기 (키체인 사용)
        
        view.addSubview(floatingView)
        
        floatingView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top) // 탭 바 위에 배치
            make.height.equalTo(FloatingViewHeight)
         }
        
        floatingView.configure(albumImage: .BTOB, songTitle: "POWER", artistName: "G-Dragon")
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
