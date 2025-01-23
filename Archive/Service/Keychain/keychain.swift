//
//  dummy.swift
//  Archive
//
//  Created by 이수현 on 1/8/25.
//

import Foundation
import Security

class KeychainHelper {
    static func saveAccessToken(_ token: String) {
        let tokenData = token.data(using: .utf8)!
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "SpotifyAccessToken",
            kSecValueData: tokenData
        ] as CFDictionary

        SecItemDelete(query) // 기존 토큰 삭제
        let status = SecItemAdd(query, nil)
        if status == errSecSuccess {
            print("Access Token saved to Keychain.")
        } else {
            print("Failed to save Access Token: \(status)")
        }
    }

    static func loadAccessToken() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "SpotifyAccessToken",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        if status == errSecSuccess {
            if let tokenData = result as? Data {
                return String(data: tokenData, encoding: .utf8)
            }
        }
        return nil
    }
}
