//
//  KeychainServiceType.swift
//  Blism
//
//  Created by 이수현 on 12/20/24.
//

import Foundation

public enum KeychainServiceType : String {
    // Account: userInfo
    case userId = "userId"
    case nickname = "nickname"
    case profileImage = "profileImage"
    case cipherCode = "cipherCode" // 이메일 인증 코드 저장용
    case timeHistory = "timeHistory"
    case year = "year"
    case month = "month"
    case week = "week"
    
    // Account: token
    case serverAccessToken = "serverAccessToken"
    
    // Account: musicInfo
    case musicId = "musicId"
    case musicImageURL = "musicImageURL"
    case musicTitle = "musicTitle"
    case artist = "artist"
}
