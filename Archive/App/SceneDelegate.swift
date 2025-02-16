//
//  SceneDelegate.swift
//  Archive
//
//  Created by 이수현 on 1/7/25.
//

import UIKit
import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.backgroundColor = UIColor.black_100

        let musicLoadVC = OnBoarding2VC()
        let navigationController = UINavigationController(rootViewController: musicLoadVC)
        window?.rootViewController = navigationController
//        let musicLoadVC = MusicLoadVC()
  //      let navigationController = UINavigationController(rootViewController: musicLoadVC)
    //    window?.rootViewController = navigationController

//        let navigationController = UINavigationController(rootViewController: LoginVC())
//        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
      
    }
}

