//
//  TabBarViewController.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

class TabBarViewController: UITabBarController {
    private let homeVC = UINavigationController(rootViewController: HomeViewController())
    private let exploreVC = UINavigationController(rootViewController: ExploreViewController())
    private let libraryVC = UINavigationController(rootViewController: LibraryMainViewController())
    private let myPageVC = UINavigationController(rootViewController: MyPageViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance

    }
}
