//
//  AlbumTargetType.swift
//  Archive
//
//  Created by 이수현 on 2/1/25.
//

import UIKit
import Moya

public enum AlbumTargetType {
    case ExploreRecommendAlbum // 당신을 위한 앨범 추천 조회(탐색뷰)
}

extension AlbumTargetType: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: Domain.albumURL) else {
            fatalError("Error: Invalid URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .ExploreRecommendAlbum:
            return "year/nomination"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .ExploreRecommendAlbum:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .ExploreRecommendAlbum:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    
}
