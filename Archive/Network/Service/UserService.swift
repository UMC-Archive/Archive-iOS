//
//  UserService.swift
//  Archive
//
//  Created by 이수현 on 1/25/25.
//

import UIKit
import Moya

public final class UserService: NetworkManager {
    typealias Endpoint = UserTargetType
    
    let provider: Moya.MoyaProvider<UserTargetType>
    
    init(provider: MoyaProvider<UserTargetType>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            BearerTokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<UserTargetType>(plugins: plugins)
    }
    
    // 이메일 인증 번호 전송 API
    public func sendVerificationCode(email: String, completion: @escaping (Result<String?, NetworkError>) -> Void) {
        requestOptional(target: .sendVerificationCode(email: email), decodingType: String.self, completion: completion)
    }
    
    // 이메일 인증 번호 확인 API
    public func checkVerificationCode(parameter: CheckVerificationCodeRequestDTO, completion: @escaping (Result<Bool?, NetworkError>) -> Void) {
        requestOptional(target: .checkVerificationCode(parameter: parameter), decodingType: Bool.self, completion: completion)
    }
    
    // 회원가입 API
    public func signUp(image: UIImage, parameter: SignUpRequestDTO, completion: @escaping (Result<SignUpResponseDTO, NetworkError>) -> Void) {
        request(target: .signUp(image: image, parameter: parameter), decodingType: SignUpResponseDTO.self, completion: completion)
    }
    
    // 로그인 API
    public func login(parameter: LoginRequestDTO, completion: @escaping (Result<String?, NetworkError>) -> Void) {
        request(target: .login(parameter: parameter), decodingType: String?.self, completion: completion)
    }
    
    // 음악 재생 기록 API
    public func playingRecord(parameter: UserPlayingRecordRequestDTO, completion: @escaping (Result<UserPlayingRecordResponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .userPlayingRecord(parameter: parameter), decodingType: UserPlayingRecordResponseDTO.self, completion: completion)
    }
    
    // 최근 탐색 연도 불러오기 API
    public func getHistroy(completion: @escaping (Result<[GetHistoryResponseDTO]?, NetworkError>) -> Void){
        requestOptional(target: .getHistory, decodingType: [GetHistoryResponseDTO].self, completion: completion)
    }
    
    // 탐색 연도 저장 API
    public func postHistory(parameter: PostHistoryRequestDTO, completion: @escaping (Result<PostHistoryResponseDTO, NetworkError>) -> Void) {
        request(target: .postHistory(date: parameter), decodingType: PostHistoryResponseDTO.self, completion: completion)
    }
    
    // 사용자 정보 불러오기
    public func userInfo(completion: @escaping (Result<UserInfoResponseDTO?, NetworkError>) -> Void) {
        requestOptional(target: .info, decodingType: UserInfoResponseDTO.self, completion: completion)
    }
    
    // recap 가져오기 API
    public func getRecap(completion: @escaping (Result<[RecapResponseDTO]?, NetworkError>) -> Void){
        requestOptional(target: .getRecap, decodingType: [RecapResponseDTO].self, completion: completion)
    }
    
    // 선호 장르 가져오기 API
    public func getGenrePreference(completion: @escaping (Result<[GenrePreferenceResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .preference, decodingType: [GenrePreferenceResponseDTO].self, completion: completion)
    }
    
    // 프로필 변경 API
    public func profileChange(image: UIImage, parameter: ProfileChangePostRequestDTO, completion: @escaping (Result<ProfileChangeResponseDTO, NetworkError>) -> Void) {
        request(target: .profileChange(image: image, parameter: parameter), decodingType: ProfileChangeResponseDTO.self, completion: completion)
    }
    
    // 최근 추가한 노래
    public func RecentlyMusic(completion: @escaping(Result<[RecentMusicResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .getRecentMusic, decodingType: [RecentMusicResponseDTO].self, completion: completion)
    }
    
    // 최근 들은 노래, 청취 기록 
    public func RecentlyPlayedMusic(completion: @escaping(Result<[RecentPlayMusicResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .getRecentlyPlayedMusic, decodingType: [RecentPlayMusicResponseDTO].self, completion: completion)
    }
}
