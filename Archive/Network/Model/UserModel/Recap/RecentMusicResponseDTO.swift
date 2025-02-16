//
//  RecentMusicResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/15/25.
//
import Foundation

public struct RecentMusicResponseDTO: Decodable {
    
    let music: RecentMusicDTO
}

public struct RecentMusicDTO: Decodable, Hashable {
    
    let id: String
    let title: String
    let releaseTime: String
    let image: String
    let updatedAt: String
    let artist: ArtistDTO
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case releaseTime
        case image
        case updatedAt
        case artist
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseTime = try container.decode(String.self, forKey: .releaseTime)
        self.image = try container.decode(String.self, forKey: .image)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.artist = try container.decode(ArtistDTO.self, forKey: .artist)
    }
}

public struct ArtistDTO: Decodable, Hashable {
    let name: String
}

