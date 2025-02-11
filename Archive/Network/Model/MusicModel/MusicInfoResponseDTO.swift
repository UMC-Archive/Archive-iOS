//
//  MusicInfo.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation


public struct MusicInfoResponseDTO: Decodable {
    let id: String
    let albumId: String
    let title: String
    let releaseTime: String
    let lyrics: String
    let image: String
    let musicUrl: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: CodingKey {
        case id
        case albumId
        case title
        case releaseTime
        case lyrics
        case image
        case musicUrl
        case createdAt
        case updatedAt
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.albumId = try container.decode(String.self, forKey: .albumId)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseTime = try container.decode(String.self, forKey: .releaseTime)
        self.lyrics = try container.decode(String.self, forKey: .lyrics)
        self.image = try container.decode(String.self, forKey: .image)
        self.musicUrl = try container.decode(String.self, forKey: .musicUrl)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
}
