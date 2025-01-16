//
//  SceneDelegate.swift
//  Archive
//
//  Created by 이수현 on 1/7/25.
//
import SpotifyiOS
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        // StartPageView를 루트 뷰 컨트롤러로 설정
        let startPageView = StartPageVC()
        window?.rootViewController = startPageView
   
        window?.makeKeyAndVisible()
    }
    
    // Spotify 인증 콜백 처리
       func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
           guard let url = URLContexts.first?.url else { return }

           let parameters = SpotifyAuthManager.shared.appRemote.authorizationParameters(from: url)
           if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
               SpotifyAuthManager.shared.accessToken = accessToken
               SpotifyAuthManager.shared.appRemote.connectionParameters.accessToken = accessToken
           } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
               print("Spotify authorization error: \(errorDescription)")
           }
       }

       // 앱 활성화 시 Spotify 연결
       func sceneDidBecomeActive(_ scene: UIScene) {
           if let _ = SpotifyAuthManager.shared.accessToken {
               SpotifyAuthManager.shared.connect()
           }
       }

       // 앱 비활성화 시 Spotify 연결 해제
       func sceneWillResignActive(_ scene: UIScene) {
           SpotifyAuthManager.shared.disconnect()
       }
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
      print("connected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      print("disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
      print("failed")
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
      print("player state changed")
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

