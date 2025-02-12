//
//  AlbumService.swift
//  Archive
//
//  Created by 이수현 on 2/1/25.
//

import UIKit
import Moya

public final class AlbumService: NetworkManager {
    typealias Endpoint = AlbumTargetType
    
    let provider: Moya.MoyaProvider<AlbumTargetType>
    
    init(provider: MoyaProvider<AlbumTargetType>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            BearerTokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<AlbumTargetType>(plugins: plugins)
    }
    
    // 당신을 위한 앨범 추천 조회 (탐색 뷰)
    public func exploreRecommendAlbum(completion: @escaping (Result<[ExploreRecommendAlbumResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .ExploreRecommendAlbum, decodingType: [ExploreRecommendAlbumResponseDTO].self, completion: completion)
    }
    
    // 당신을 위한 앨범 추천(앨범 뷰)
    public func albumRecommendAlbum(completion: @escaping (Result<[AlbumRecommendAlbumResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .ExploreRecommendAlbum, decodingType: [AlbumRecommendAlbumResponseDTO].self, completion: completion)
    }
    
    // 트랙 리스트 (수록곡 소개)
    public func trackList(albumId: String, completion: @escaping (Result<AlbumTrackListResponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .TrackList(albumId: albumId), decodingType: AlbumTrackListResponseDTO.self, completion: completion)
    }
}
