//
//  KeychainServiceType.swift
//  Blism
//
//  Created by 이수현 on 12/20/24.
//

import Foundation

public enum KeychainServiceType : String {
    case userId = "userId"
    case nickname = "nickname"
    case profileImage = "profileImage"
    case cipherCode = "cipherCode" // 이메일 인증 코드 저장용
    case year = "year"
    case month = "month"
    case week = "week"
    case serverAccessToken = "serverAccessToken"
}
