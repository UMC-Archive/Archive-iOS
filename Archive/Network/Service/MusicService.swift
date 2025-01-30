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
        let plugins: [PluginType] = [
            BearerTokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<MusicTargetType>(plugins: plugins)
    }
    
    
    // 노래 정보 가져오기
    public func musicInfo(artist: String, music: String, completion: @escaping (Result<MusicInfoResponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .musicInfo(artist: artist, music: music), decodingType: MusicInfoResponseDTO.self, completion: completion)
    }
    
    // 앨범 정보 가져오기
    public func album(artist: String, album: String, completion: @escaping (Result<AlbumInfoReponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .albumInfo(artist: artist, album: album), decodingType: AlbumInfoReponseDTO.self, completion: completion)
    }
    
    // 아티스트 정보 가져오기
    public func artist(artist: String, completion: @escaping (Result<ArtistInfoReponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .artistInfo(artist: artist), decodingType: ArtistInfoReponseDTO.self, completion: completion)
    }
    
    // 숨겨진 명곡 조회
    public func hiddenMusic(completion: @escaping(Result<[HiddenMusicResponseDTO]?, NetworkError>) -> Void){
        requestOptional(target: .musicHidden, decodingType: [HiddenMusicResponseDTO].self, completion: completion)
    }
    
    // 장르 정보 조회
    public func genreInfo(completion: @escaping(Result<[GenreInfoResponseDTO], NetworkError>) -> Void) {
        request(target: .genreInfo, decodingType: [GenreInfoResponseDTO].self, completion: completion)
    }
}
