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
    case artistInfo(artist: String, album: String) // 아티스트 정보 가져오기
    case artistCuration(artistId: String)   // 아티스트 큐레이션
    case musicHidden // 숨겨진 명곡
    case chooseGenreInfo // 선택 장르 정보 가져오기
    case chooseArtistInfo // 선택 아티스트 정보 가져오기
    case ExploreRecommendMusic // 당신을 위한 추천곡(탐색뷰)
    case recommendMusic // 홈 - 당신을 위한 추천곡
    case similarArtist(artistId: String) // 비슷한 아티스트 가져오기
    case anotherAlbum(artistId: String, albumId: String) // 이 아티스트의 다른 앨범
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
        case .chooseGenreInfo:
            return "genre/info"
        case .chooseArtistInfo:
            return "artist/info"
        case .albumCuration(albumId: let albumId):
            return "album/\(albumId)/curation"
        case .artistCuration(artistId: let artistId):
            return "artist/\(artistId)/curation"
        case .ExploreRecommendMusic:
            return "year/nomination"
        case .recommendMusic:
            return "nomination"
        case .similarArtist(let artistId):
            return "artist/\(artistId)/similar"
        case .anotherAlbum(artistId: let artistId, albumId: let albumId):
            return "artist/\(artistId)/album/\(albumId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .musicInfo, .albumInfo, .artistInfo, .albumCuration, .artistCuration:
            return .post
        case .musicHidden, .chooseGenreInfo, .chooseArtistInfo, .ExploreRecommendMusic, .recommendMusic, .similarArtist, .anotherAlbum:
            return .get
        }
    }
    
    var task: Moya.Task {		
        switch self {
        case .musicInfo(let artist, let music):
            return .requestParameters(parameters: ["artist_name" : artist, "music_name" : music], encoding: URLEncoding.queryString)
        case .albumInfo(let artist, let album):
            return .requestParameters(parameters: ["artist_name" : artist, "album_name" : album], encoding: URLEncoding.queryString)
        case .artistInfo(let artist, let album):
            return .requestParameters(parameters: ["artist_name" : artist, "album_name" : album], encoding: URLEncoding.queryString)
        case .musicHidden, .chooseGenreInfo, .chooseArtistInfo, .albumCuration, .artistCuration, .ExploreRecommendMusic, .recommendMusic, .similarArtist, .anotherAlbum:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
					

