//
//  LibraryTargetType.swift
//  Archive
//
//  Created by 송재곤 on 2/1/25.
//


import Foundation
import Moya

enum LibraryTargetType {
    case libraryMusicInfo
    case libraryArtistInfo
    case libraryAlbumInfo
    case musicPost(musicId: String)
    case albumPost(albumId: String)
    case artistPost(artistId: String)
    case musicDelete(musicId: String)
    case albumDelete(albumId: String)
    case artistDelete(artistId: String)
}


extension LibraryTargetType: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Domain.libraryURL) else {
            fatalError("Error: Invalid URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .libraryMusicInfo:
            return "/music"
        case .libraryArtistInfo:
            return "/artist"
        case .libraryAlbumInfo:
            return "/album"
        case .musicPost(let musicId):
            return "/music/\(musicId)"
        case .albumPost(albumId: let albumId):
            return "/album/\(albumId)"
        case .artistPost(artistId: let artistId):
            return "/artist/\(artistId)"
        case .musicDelete(musicId: let musicId):
            return "/music/\(musicId)"
        case .albumDelete(albumId: let albumId):
            return "/album/\(albumId)"
        case .artistDelete(artistId: let artistId):
            return "/artist/\(artistId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .libraryMusicInfo:
            return .get
        case .libraryArtistInfo:
            return .get
        case .libraryAlbumInfo:
            return .get
        case .musicPost:
            return .post
        case .albumPost:
            return .post
        case .artistPost:
            return .post
        case .musicDelete:
            return .delete
        case .albumDelete:
            return .delete
        case .artistDelete:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .libraryMusicInfo:
            return .requestPlain
        case .libraryArtistInfo:
            return .requestPlain
        case .libraryAlbumInfo:
            return .requestPlain
        case .musicPost:
            return .requestPlain
        case .albumPost:
            return .requestPlain
        case .artistPost:
            return .requestPlain
        case .musicDelete:
            return .requestPlain
        case .albumDelete:
            return .requestPlain
        case .artistDelete:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
}
