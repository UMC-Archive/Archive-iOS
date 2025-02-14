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
    case userPlayingRecord(parameter: UserPlayingRecordRequestDTO) // 재생 기록
    case getHistory // 최근 탐색 연도 불러오기 API
    case info // 사용자 정보 불러오기
    case postHistory(date: PostHistoryRequestDTO)
    case getRecap
    case preference
    case profileChange(image: UIImage, parameter: ProfileChangePostRequestDTO)
    case getRecentMusic
    case gerRecentlyPlayedMusic
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
        case .userPlayingRecord:
            return "play"
        case .getHistory:
            return "history"
        case .info:
            return "info"
        case .postHistory:
            return "history"
        case .getRecap:
            return "recap"
        case .preference:
            return "genre/preference"
        case .profileChange:
            return "profile_image"
        case .getRecentMusic:
            return "recent"
        case .gerRecentlyPlayedMusic:
            return "play"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .sendVerificationCode, .getHistory, .info:
            return .get
        case .checkVerificationCode, .signUp, .login, .userPlayingRecord:
            return .post
        case .postHistory:
            return .post
        case .getRecap:
            return .get
        case .preference:
            return .get
        case .profileChange:
            return .post
        case .getRecentMusic:
            return .get
        case .gerRecentlyPlayedMusic:
            return .get
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
            
            return .uploadMultipart(formData)
            
        case .userPlayingRecord(parameter: let parameter):
            return .requestJSONEncodable(parameter)
        case .getHistory, .info:
            return .requestPlain
        case .postHistory(date: let parameter):
            return .requestJSONEncodable(parameter)
        case .getRecap:
            return .requestPlain
        case .preference:
            return .requestPlain
        case .profileChange(image: let image, parameter: let parameter):
            
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
            
            return .uploadMultipart(formData)
            
        case .getRecentMusic:
            return .requestPlain
        case .gerRecentlyPlayedMusic:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .signUp, .profileChange:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
