//
//  UserService.swift
//  Archive
//
//  Created by 손현빈 on 1/31/25.
//

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
                    NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
                ]
        
       
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
    public func login(parameter: LoginRequestDTO, completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void) {
         request(target: .login(parameter: parameter), decodingType: LoginResponseDTO.self, completion: completion)
     }
}
