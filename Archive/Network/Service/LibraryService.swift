//
//  LibraryService.swift
//  Archive
//
//  Created by 송재곤 on 2/1/25.
//

import Foundation
import Moya

public final class LibraryService: NetworkManager {
    typealias Endpoint = LibraryTargetType
    
    let provider: Moya.MoyaProvider<LibraryTargetType>
    
    init(provider: MoyaProvider<LibraryTargetType>? = nil) {
        // 플러그인 추가
//        let plugins: [PluginType] = [
//            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
//        ]
        
        // provider 초기화
//        self.provider = provider ?? MoyaProvider<MusicTargetType>(plugins: plugins)
        
        self.provider = MoyaProvider<LibraryTargetType>()
    }
    
    
    
    public func libraryMusicInfo(completion: @escaping(Result<[LibraryMusicResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .libraryMusicInfo, decodingType: [LibraryMusicResponseDTO].self, completion: completion)
    }
    public func libraryArtistInfo(completion: @escaping(Result<[LibraryArtistResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .libraryArtistInfo, decodingType: [LibraryArtistResponseDTO].self, completion: completion)
    }
    public func libraryAlbumInfo(completion: @escaping(Result<[LibraryAlbumResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .libraryAlbumInfo, decodingType: [LibraryAlbumResponseDTO].self, completion: completion)
    }
}
