//
//  UserInfoResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/13/25.
//

import Foundation

public struct UserInfoResponseDTO: Decodable {
    let id: String
    let nickname: String
    let email: String
    let profileImage: String
    
    enum CodingKeys: CodingKey {
        case id
        case nickname
        case email
        case profileImage
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.email = try container.decode(String.self, forKey: .email)
        self.profileImage = try container.decode(String.self, forKey: .profileImage)
    }
}

