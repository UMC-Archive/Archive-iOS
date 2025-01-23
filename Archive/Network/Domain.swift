//
//  Domain.swift
//  Archive
//
//  Created by 이수현 on 1/20/25.
//

import UIKit

public struct Domain {
    public static let baseURL = "http://umc.musicarchive.kro.kr/"   // 기본 주소
    public static let usersURL = "\(baseURL)/users"                 // 유저
    public static let libraryURL = "\(baseURL)/library"             // 라이브러리
    public static let musicURL = "\(baseURL)/music"                 // 음악
    public static let albumURL = "\(baseURL)/album"                 // 앨범
}
