//
//  SignUpResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 1/27/25.
//

import Foundation


public struct SignUpResponseDTO: Decodable {
    let user: User
    let artists: [String]
    let genres: [String]
    let library: Library
    
    enum CodingKeys: CodingKey {
        case user
        case artists
        case genres
        case library
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try container.decode(User.self, forKey: .user)
        self.artists = try container.decode([String].self, forKey: .artists)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.library = try container.decode(Library.self, forKey: .library)
    }
}

public struct Library: Decodable {
    let id: String
    let userId: String
    
    enum CodingKeys: CodingKey {
        case id
        case userId
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
    }
}


public struct User: Decodable {
    let id: String
    let nickname: String
    let email: String
    let password: String
    let profileImage: String
    let status: String
    let socialType: String
    
    enum CodingKeys: CodingKey {
        case id
        case nickname
        case email
        case password
        case profileImage
        case status
        case socialType
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.profileImage = try container.decode(String.self, forKey: .profileImage)
        self.status = try container.decode(String.self, forKey: .status)
        self.socialType = try container.decode(String.self, forKey: .socialType)
    }
}
