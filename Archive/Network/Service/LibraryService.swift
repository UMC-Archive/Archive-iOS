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
    
    struct EmptyResponse: Decodable {}
    
    let provider: Moya.MoyaProvider<LibraryTargetType>
    
    init(provider: MoyaProvider<LibraryTargetType>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            BearerTokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
//         provider 초기화
        self.provider = provider ?? MoyaProvider<LibraryTargetType>(plugins: plugins)
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
    public func musicPost(musicId: String, completion: @escaping(Result<LibraryMusicPostResponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .musicPost(musicId: musicId), decodingType: LibraryMusicPostResponseDTO.self, completion: completion)
    }
    public func albumPost(albumId: String, completion: @escaping(Result<LibraryAlbumPostResponseDTO?, NetworkError>) -> Void){
        requestOptional(target: .albumPost(albumId: albumId), decodingType: LibraryAlbumPostResponseDTO.self, completion: completion)
    }
    public func artistPost(artistId: String, completion: @escaping(Result<LibraryArtistPostResponseDTO?, NetworkError>) -> Void){
        requestOptional(target: .artistPost(artistId: artistId), decodingType: LibraryArtistPostResponseDTO.self, completion: completion)
    }
    public func musicDelete(musicId: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestOptional(target: .musicDelete(musicId: musicId), decodingType: EmptyResponse.self) {
            result in
            switch result {
            case .success:
                completion(.success(())) // Void 반환
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    public func albumDelete(albumId: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestOptional(target: .albumDelete(albumId: albumId), decodingType: EmptyResponse.self) {
            result in
            switch result {
            case .success:
                completion(.success(())) // Void 반환
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    public func artistDelete(artistId: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestOptional(target: .artistDelete(artistId: artistId), decodingType: EmptyResponse.self) {
            result in
            switch result {
            case .success:
                completion(.success(())) // Void 반환
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
