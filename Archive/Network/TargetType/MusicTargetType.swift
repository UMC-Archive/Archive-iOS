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
    case albumInfo(artist: String, album: String) // 앨범 정보 가져오기
    case albumCuration(albumId: String)     // 앨범 큐레이션
    case artistInfo(artist: String) // 아티스트 정보 가져오기
    case musicHidden // 숨겨진 명곡
    case genreInfo // 장르 정보 가져오기
}


extension MusicTargetType: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Domain.musicURL) else {
            fatalError("Error: Invalid URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .musicInfo:
            return ""
        case .albumInfo:
            return "album"
        case .artistInfo:
            return "artist"
        case .musicHidden:
            return "hidden"
        case .genreInfo:
            return "/genre/info"
        case .albumCuration(albumId: let albumId):
            return "album/\(albumId)/curation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .musicInfo, .albumInfo, .artistInfo, .albumCuration:
            return .post
        case .musicHidden, .genreInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .musicInfo(let artist, let music):
            return .requestParameters(parameters: ["artist_name" : artist, "music_name" : music], encoding: URLEncoding.queryString)
        case .albumInfo(artist: let artist, album: let album):
            return .requestParameters(parameters: ["artist_name" : artist, "album_name" : album], encoding: URLEncoding.queryString)
        case .artistInfo(artist: let artist):
            return .requestParameters(parameters: ["artist_name" : artist], encoding: URLEncoding.queryString)
        case .musicHidden:
            return .requestPlain
        case .genreInfo:
            return .requestPlain
        case .albumCuration(albumId: let albumId):
            return .requestPlain
//            return .requestParameters(parameters: ["album_id" : albumId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
