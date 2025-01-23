//
//  MusicService.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation
import Moya

public final class MusicService: NetworkManager {
    typealias Endpoint = MusicTargetType
    
    let provider: Moya.MoyaProvider<MusicTargetType>
    
    init(provider: MoyaProvider<MusicTargetType>? = nil) {
        // 플러그인 추가
//        let plugins: [PluginType] = [
//            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
//        ]
        
        // provider 초기화
//        self.provider = provider ?? MoyaProvider<MusicTargetType>(plugins: plugins)
        
        self.provider = MoyaProvider<MusicTargetType>()
    }
    
    
    // 노래 정보 가져오기
    public func musicInfo(artist: String, music: String, completion: @escaping (Result<MusicInfoResponseDTO, NetworkError>) -> Void) {
        request(target: .musicInfo(artist: artist, music: music), decodingType: MusicInfoResponseDTO.self, completion: completion)
    }
    
    // 앨범 정보 가져오기
    public func album(artist: String, album: String, completion: @escaping (Result<MusicAlbumReponseDTO, NetworkError>) -> Void) {
        request(target: .musicAlbum(artist: artist, album: album), decodingType: MusicAlbumReponseDTO.self, completion: completion)
    }
}
