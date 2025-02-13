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
        case .musicPost(musicId: let parameter):
            return .requestPlain
        case .albumPost(albumId: let parameter):
            return .requestPlain
        case .artistPost(artistId: let parameter):
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
}
