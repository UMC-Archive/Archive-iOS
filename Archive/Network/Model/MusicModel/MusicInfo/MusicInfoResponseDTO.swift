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
    
    init(id: String, albumId: String, title: String, releaseTime: String, lyrics: String, image: String, music: String) {
        self.id = id
        self.albumId = albumId
        self.title = title
        self.releaseTime = releaseTime
        self.lyrics = lyrics
        self.image = image
        self.music = music
    }

    
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


extension MusicInfoResponseDTO {
    static func loadingData() -> MusicInfoResponseDTO {
        return
            MusicInfoResponseDTO(
                 id: "1",
                 albumId: "1",
                 title: Constant.LoadString,
                 releaseTime: "",
                 lyrics: "",
                 image: Constant.LoadingImageURL,
                 music: ""
             )
    }
}
