//
//  BearerTokenPlugin.swift
//  Archive
//
//  Created by 이수현 on 1/30/25.
//

import Foundation
import Moya

// 키체인이나 UserDefaults에 저장해둔 토큰 헤더에 넣기
// 라이브러리 : Moya, KeychainSwift 사용
final class BearerTokenPlugin: PluginType {
    private var accessToken: String? {
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJJZCI6IjEiLCJ0eXBlIjoiUlQiLCJpc3N1ZXIiOiJBcmNoaXZlQVBJU2VydmVyIn0sImlhdCI6MTczOTUwODM1NywiZXhwIjoxNzM5NTIyNzU3fQ.uaHNgLGJIG75C0GbmaQBVkglsT8X1Uw7jZP3YpHzdp4"

        
        
        
//        return KeychainService.shared.load(account: .token, service: .serverAccessToken)
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        // 만약 accessToken이 있다면 Authorization 헤더에 추가합니다.
        if let token = accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
}
