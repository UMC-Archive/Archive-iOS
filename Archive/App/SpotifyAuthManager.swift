//
//  SPTConfiguration.swift
//  Archive
//
//  Created by 손현빈 on 1/16/25.
//

import Foundation
import SpotifyiOS

// Spotify api와 연결하기 위해 Redirect URL과 Client ID 가 필요
public class SpotifyAuthManager {
    
    static let shared = SpotifyAuthManager()

    private let SpotifyClientID = "144daba7660949d3b980b8185063ce81" // Spotify Developer Dashboard에서 확인
    private let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")! // Redirect URI

    lazy var configuration: SPTConfiguration = {
        let config = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURL)
        return config
    }()

    var appRemote: SPTAppRemote?

    init() {
        appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote?.delegate = self
    }

    func connect() {
        guard let appRemote = appRemote else { return }
        appRemote.connect()
    }

    func disconnect() {
        guard let appRemote = appRemote else { return }
        appRemote.disconnect()
    }
}

// MARK: - SPTAppRemoteDelegate
extension SpotifyAuthManager: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("Spotify App Remote connected!")
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Spotify App Remote disconnected with error: \(String(describing: error))")
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Spotify App Remote failed to connect: \(String(describing: error))")
    }
}
