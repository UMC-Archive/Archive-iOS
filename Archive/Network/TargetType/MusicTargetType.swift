//
//  MusicTargetType.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation
import Moya

enum MusicTargetType {
    case musicInfo(artist: String, music: String)           // 노래 정보 가져오기
//    case musicPlay // 음악 재생시 기록
//    case musicAlbum // 앨범 정보 가져오기
//    case musicArtist // 아티스트 정보 가져오기
//    case musicHidden // 숨겨진 명곡
}


extension MusicTargetType: TargetType {
    var baseURL: URL {
        var domain = ""
        switch self {
        case .musicInfo:
            domain = Domain.musicURL
        }
        
        guard let url = URL(string: domain) else {
            fatalError("Error: Invalid URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .musicInfo:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .musicInfo:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .musicInfo(let artist, let music):
            return .requestParameters(parameters: ["artist_name" : artist, "music_name" : music], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
