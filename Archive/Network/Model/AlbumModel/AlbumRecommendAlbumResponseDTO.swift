//
//  AlbumRecommendAlbumResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/8/25.
//

import Foundation

public struct AlbumRecommendAlbumResponseDTO: Decodable {
    let album: AlbumRecommendAlbum
    let artist: String
}


public struct AlbumRecommendAlbum: Decodable, Hashable {
    let id: String
    let title: String
    let releaseTime: String
    let image: String
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case releaseTime
        case image
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseTime = try container.decode(String.self, forKey: .releaseTime)
        self.image = try container.decode(String.self, forKey: .image)
    }
}
