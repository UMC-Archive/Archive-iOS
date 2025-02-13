//
//  MusicInfo.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation


public struct MusicInfoResponseDTO: Decodable, Hashable {
    let id: String
    let albumId: String
    let title: String
    let releaseTime: String
    let lyrics: String
    let image: String
    let music: String
    
    enum CodingKeys: CodingKey {
        case id
        case albumId
        case title
        case releaseTime
        case lyrics
        case image
        case music
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.albumId = try container.decode(String.self, forKey: .albumId)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseTime = try container.decode(String.self, forKey: .releaseTime)
        self.lyrics = try container.decode(String.self, forKey: .lyrics)
        self.image = try container.decode(String.self, forKey: .image)
        self.music = try container.decode(String.self, forKey: .music)
    }
}
