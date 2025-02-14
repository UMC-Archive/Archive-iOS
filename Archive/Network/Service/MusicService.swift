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
    
    // 앨범 큐레이션
    public func albumCuration(albumId: String, completion: @escaping (Result<AlbumCurationReponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .albumCuration(albumId: albumId), decodingType: AlbumCurationReponseDTO.self, completion: completion)
    }
    
    // 아티스트 정보 가져오기
    public func artist(artist: String, album: String, completion: @escaping (Result<ArtistInfoReponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .artistInfo(artist: artist, album: album), decodingType: ArtistInfoReponseDTO.self, completion: completion)
    }
    
    // 아티스트 큐레이션
    public func artistCuration(artistId: String, completion: @escaping (Result<ArtistCurationResponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .artistCuration(artistId: artistId), decodingType: ArtistCurationResponseDTO.self, completion: completion)
    }
    
    // 숨겨진 명곡 조회
    public func hiddenMusic(completion: @escaping(Result<[HiddenMusicResponseDTO]?, NetworkError>) -> Void){
        requestOptional(target: .musicHidden, decodingType: [HiddenMusicResponseDTO].self, completion: completion)
    }
    
    // 선택 장르 정보 조회
    public func chooseGenreInfo(completion: @escaping(Result<[ChooseGenreResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .chooseGenreInfo, decodingType: [ChooseGenreResponseDTO].self, completion: completion)
    }
    
    // 선택 아티스트 정보 조회
    public func chooseArtistInfo(completion: @escaping(Result<ChooseArtistResponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .chooseArtistInfo, decodingType: ChooseArtistResponseDTO.self, completion: completion)
    }
    
    // 당신을 위한 추천곡(탐색 뷰)
    public func exploreRecommendMusic(completion: @escaping(Result<[ExploreRecommendMusicResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .ExploreRecommendMusic, decodingType: [ExploreRecommendMusicResponseDTO].self, completion: completion)
    }
    
    // 당신을 위한 추천곡 (홈 뷰)
    public func homeRecommendMusic(completion: @escaping(Result<[RecommendMusicResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .recommendMusic, decodingType: [RecommendMusicResponseDTO].self, completion: completion)
    }
    
    // 비슷한 아티스트 조회
    public func similarArtist(aristId: String, completion: @escaping(Result<[SimilarArtistResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .similarArtist(artistId: aristId), decodingType: [SimilarArtistResponseDTO].self, completion: completion)
    }
    
    // 이 아티스트의 다른 앨범 조회
    public func anotherAlbum(artistId: String, albumId: String, completion: @escaping(Result<[AnotherAlbumResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .anotherAlbum(artistId: artistId, albumId: albumId), decodingType: [AnotherAlbumResponseDTO].self, completion: completion)
    }
    
    // 아티스트 인기곡
    public func artistPopularMusic(artistId: String, completion: @escaping(Result<[ArtistPopularMusicResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .artistPopularMusic(artistId: artistId), decodingType: [ArtistPopularMusicResponseDTO].self, completion: completion)
    }

    // 모든 정보 조회
    public func allInfo(music: String? = nil, album: String? = nil, artist: String? = nil, completion: @escaping(Result<AllInfoResponseDTO, NetworkError>) -> Void) {
        request(target: .allInfo(music: music, artist: artist, album: album), decodingType: AllInfoResponseDTO.self, completion: completion)
    }
    
    // 빠른 선곡 - 다음 트랙
    public func selection(completion: @escaping (Result<[SelectionResponseDTO]?, NetworkError>) -> Void){
        requestOptional(target: .selection, decodingType: [SelectionResponseDTO].self, completion: completion)
    }
}
