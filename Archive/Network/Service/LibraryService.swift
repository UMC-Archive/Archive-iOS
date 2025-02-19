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
    
    
    //보관함 노래 정보 가져오기
    public func libraryMusicInfo(completion: @escaping(Result<[LibraryMusicResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .libraryMusicInfo, decodingType: [LibraryMusicResponseDTO].self, completion: completion)
    }
    //보관함 아티스트 정보 가져오기
    public func libraryArtistInfo(completion: @escaping(Result<[LibraryArtistResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .libraryArtistInfo, decodingType: [LibraryArtistResponseDTO].self, completion: completion)
    }
    //보관함 앨범 정보 가져오기
    public func libraryAlbumInfo(completion: @escaping(Result<[LibraryAlbumResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .libraryAlbumInfo, decodingType: [LibraryAlbumResponseDTO].self, completion: completion)
    }
    // 보관함에 노래 추가
    public func musicPost(musicId: String, completion: @escaping(Result<LibraryMusicPostResponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .musicPost(musicId: musicId), decodingType: LibraryMusicPostResponseDTO.self, completion: completion)
    }
    // 보관함에 앨범 추가
    public func albumPost(albumId: String, completion: @escaping(Result<LibraryAlbumPostResponseDTO?, NetworkError>) -> Void){
        requestOptional(target: .albumPost(albumId: albumId), decodingType: LibraryAlbumPostResponseDTO.self, completion: completion)
    }
    // 보관함에 아티스트 추가
    public func artistPost(artistId: String, completion: @escaping(Result<LibraryArtistPostResponseDTO?, NetworkError>) -> Void){
        requestOptional(target: .artistPost(artistId: artistId), decodingType: LibraryArtistPostResponseDTO.self, completion: completion)
    }
    // 보관함에 노래 삭제
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
    // 보관함에 앨범 삭제
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
    // 보관함에 아티스트 삭제
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
