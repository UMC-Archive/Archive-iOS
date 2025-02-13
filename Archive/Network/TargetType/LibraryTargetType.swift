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
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
}
