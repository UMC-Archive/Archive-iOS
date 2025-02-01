//
//  RecommendMusicResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/1/25.
//

import Foundation

public struct RecommendMusicResponseDTO: Decodable {
    let music: RecommendMusic
    let artist: String
}

public struct RecommendMusic: Decodable, Hashable {
    let id: String
    let albumId: String
    let title: String
    let releaseTime: String
    let image: String
    
    enum CodingKeys: CodingKey {
        case id
        case albumId
        case title
        case releaseTime
        case image
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.albumId = try container.decode(String.self, forKey: .albumId)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseTime = try container.decode(String.self, forKey: .releaseTime)
        self.image = try container.decode(String.self, forKey: .image)
    }
}
