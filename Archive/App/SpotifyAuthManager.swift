//
//  SPTConfiguration.swift
//  Archive
//
//  Created by 손현빈 on 1/16/25.
//

import Foundation
import SpotifyiOS

// Spotify api와 연결하기 위해 Redirect URL과 Client ID 가 필요
public class SpotifyAuthManager : NSObject {
    
    static let shared = SpotifyAuthManager()
    
    // 액세스 토큰 저장 
    var accessToken: String? {
        get {
            return KeychainHelper.loadAccessToken()
        }
        set {
            if let token = newValue {
                KeychainHelper.saveAccessToken(token)
            }
        }
    }

    
    private let SpotifyClientID = "144daba7660949d3b980b8185063ce81" // Spotify Developer Dashboard에서 확인
    private let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")! // Redirect URI

    lazy var configuration: SPTConfiguration = {
        let config = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURL)
               config.tokenSwapURL = nil
               config.tokenRefreshURL = nil
               return config
    }()
    
    lazy var sessionManager: SPTSessionManager = {
           let manager = SPTSessionManager(configuration: configuration, delegate: self)
           return manager
       }()
    
    public func startAuthentication(from viewController: UIViewController) {
            if sessionManager.isSpotifyAppInstalled {
                sessionManager.initiateSession(with: [.appRemoteControl], options: .default)
            } else {
                sessionManager.initiateSession(with: [.appRemoteControl], options: .default, presenting: viewController)
            }
        }
    
    lazy var appRemote: SPTAppRemote? = {
         let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
         appRemote.delegate = self
         return appRemote
     }()
    
  

    public func connect() {
        guard let appRemote = appRemote else { return }
        appRemote.connect()
    }

    public func disconnect() {
        guard let appRemote = appRemote else { return }
        appRemote.disconnect()
    }
}

extension SpotifyAuthManager: SPTSessionManagerDelegate {
    public func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("Successfully authenticated with Spotify!")
        accessToken = session.accessToken // Access Token 저장
    }

    public func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Failed to authenticate with Spotify: \(error.localizedDescription)")
    }
}

// MARK: - SPTAppRemoteDelegate
extension SpotifyAuthManager: SPTAppRemoteDelegate {
   public func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("Spotify App Remote connected!")
    }

    public func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Spotify App Remote disconnected with error: \(String(describing: error))")
    }

    public func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Spotify App Remote failed to connect: \(String(describing: error))")
    }
}
