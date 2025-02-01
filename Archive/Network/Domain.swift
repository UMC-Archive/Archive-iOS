//
//  Domain.swift
//  Archive
//
//  Created by 손현빈 on 2/1/25.
//
//
//  Domain.swift
//  Archive
//
//  Created by 이수현 on 1/20/25.
//

import UIKit

public struct Domain {
    public static let baseURL = "http://umc.musicarchive.kro.kr:3000"   // 기본 주소
    public static let usersURL = "\(baseURL)/users"                 // 유저
    public static let libraryURL = "\(baseURL)/library"             // 라이브러리
    public static let musicURL = "\(baseURL)/music"                 // 음악
    public static let albumURL = "\(baseURL)/album"                 // 앨범
    public static let signupURL = "\(baseURL)/signup"               // 회원가입
}
