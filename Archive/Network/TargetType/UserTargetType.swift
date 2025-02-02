//
//  UserTargetType.swift
//  Archive
//
//  Created by 이수현 on 1/25/25.
//

import UIKit
import Moya

public enum UserTargetType {
    case signUp(image: UIImage, parameter: SignUpRequestDTO) // 회원가입
    case sendVerificationCode(email: String) // 이메일 인증번호 전송
    case checkVerificationCode(parameter: CheckVerificationCodeRequestDTO) // 이메일 인증번호 확인
    case login(parameter: LoginRequestDTO)
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
        case .signUp:
            return "signup"
        case .login:
            return "login"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .sendVerificationCode:
            return .get
        case .checkVerificationCode, .signUp, .login:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .login(parameter: let parameter):
                  // `LoginRequestDTO`를 JSON body로 보냅니다.
                  return .requestJSONEncodable(parameter)
            
        case .sendVerificationCode(let email):
            return .requestParameters(parameters: ["email" : email], encoding: URLEncoding.queryString)
        case .checkVerificationCode(let parameter):
            return .requestJSONEncodable(parameter)
        case .signUp(image: let image, parameter: let parameter):
            
                // 이미지 데이터를 Data로 전환
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    return .requestPlain
                }
                
                var formData: [MultipartFormData] = []
                
                // 이미지 추가
                let imagePart = MultipartFormData(provider: .data(imageData),
                                                  name: "image",
                                                  fileName: "\(image.hashValue).jpg",
                                                  mimeType: "image/jpeg"
                )
                formData.append(imagePart)
            
            // Request body(createLetterRequestDTO)를 JSON으로 인코딩
            do {
                let jsonData = try JSONEncoder().encode(parameter)
                let requestPart = MultipartFormData(
                    provider: .data(jsonData),
                    name: "data"
                )
                formData.append(requestPart)
            } catch {
                print("Failed to encode request body: \(error)")
                return .requestPlain
            }
                
            // 일반 텍스트 필드 추가
//            let textFields: [String: String] = [
//                "nickname": parameter.nickname,
//                "email": parameter.email,
//                "password": parameter.password,
//                "status": parameter.status,
//                "socialType": parameter.socialType,
//                "inactiveDate": parameter.inactiveDate
//            ]
//
//            for (key, value) in textFields {
//                if let data = value.data(using: .utf8) {
//                    formData.append(MultipartFormData(provider: .data(data), name: key))
//                }
//            }
//
//            // 배열 필드 추가
//            for artist in parameter.artists {
//                if let data = "\(artist)".data(using: .utf8) {
//                    formData.append(MultipartFormData(provider: .data(data), name: "artists"))
//                }
//            }
//
//            for genre in parameter.genres {
//                if let data = "\(genre)".data(using: .utf8) {
//                    formData.append(MultipartFormData(provider: .data(data), name: "genres"))
//                }
//            }

            return .uploadMultipart(formData)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .signUp:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
