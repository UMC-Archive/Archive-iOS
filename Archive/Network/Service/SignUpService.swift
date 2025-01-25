//
//  SignUpService.swift
//  Archive
//
//  Created by 이수현 on 1/25/25.
//

import Foundation
import Moya

public final class SignUpService: NetworkManager {
    typealias Endpoint = SignUpTargetType
    
    let provider: Moya.MoyaProvider<SignUpTargetType>
    
    init(provider: MoyaProvider<SignUpTargetType>? = nil) {
        // 플러그인 추가
        //        let plugins: [PluginType] = [
        //            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        //        ]
        
        // provider 초기화
        //        self.provider = provider ?? MoyaProvider<MusicTargetType>(plugins: plugins)
        
        self.provider = MoyaProvider<SignUpTargetType>()
    }
    
    // 이메일 인증 번호 전송 API
    public func sendVerificationCode(email: String, completion: @escaping (Result<String?, NetworkError>) -> Void) {
        requestOptional(target: .sendVerificationCode(email: email), decodingType: String.self, completion: completion)
    }
    
}
