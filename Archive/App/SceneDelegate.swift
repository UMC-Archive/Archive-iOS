//
//  SceneDelegate.swift
//  Archive
//
//  Created by 이수현 on 1/7/25.
//

import UIKit
import Foundation
import Security

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        KeychainService.shared.deleteAllKeychainData()
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.backgroundColor = UIColor.black_100
        window?.rootViewController = OnBoarding1VC()
        window?.makeKeyAndVisible()
      
    }
}

