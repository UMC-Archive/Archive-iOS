//
//  HiddenMusicResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 1/24/25.
//

import Foundation

public struct HiddenMusicResponseDTO: Decodable {
    let music: HiddenMusicResponse
    let album: ExploreRecommendAlbum
    let artist: String
}

public struct HiddenMusicResponse: Decodable, Hashable {
    let id: String
    let albumId: String
    let title: String
    let releaseTime: String
    let image: String
    let music: String
    
    enum CodingKeys: CodingKey {
        case id
        case albumId
        case title
        case releaseTime
        case image
        case music
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.albumId = try container.decode(String.self, forKey: .albumId)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseTime = try container.decode(String.self, forKey: .releaseTime)
        self.image = try container.decode(String.self, forKey: .image)
        self.music = try container.decode(String.self, forKey: .music)
    }
}
