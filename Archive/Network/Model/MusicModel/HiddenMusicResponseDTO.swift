//
//  HiddenMusicResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 1/24/25.
//

import Foundation

public struct HiddenMusicResponseDTO: Decodable {
    let music: HiddenMusicResponse
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

/*
 "result": [
    {
      "music": {
        "id": 1,
        "albumId": 1,
        "title": "Celebrity",
        "releaseTime": "2021-03-25",
        "lyrics": "세상의 모서리 구부정하게 커버린 골칫거리 outsider (ah ah)",
        "image": "https://example.com/music_image.jpg",
        "musicUrl": "https://example.com/preview_music.m4a",
        "createdAt": "2025-01-01",
        "updatedAt": "2025-01-01"
      },
      "artist": "IU"
    }
 */
