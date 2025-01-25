//
//  UserTargetType.swift
//  Archive
//
//  Created by 이수현 on 1/25/25.
//

import Foundation
import Moya

public enum UserTargetType {
    case sendVerificationCode(email: String) // 이메일 인증번호 전송
    case checkVerificationCode(parameter: CheckVerificationCodeRequestDTO) // 이메일 인증번호 확인
}

extension UserTargetType: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: Domain.usersURL) else {
            fatalError("Error: Invalid URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .sendVerificationCode:
            return "signup/email/send-verification-code"
        case .checkVerificationCode:
            return "signup/email/check-verification-code"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .sendVerificationCode:
            return .get
        case .checkVerificationCode:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .sendVerificationCode(let email):
                .requestParameters(parameters: ["email" : email], encoding: URLEncoding.queryString)
        case .checkVerificationCode(let parameter):
                .requestJSONEncodable(parameter)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
