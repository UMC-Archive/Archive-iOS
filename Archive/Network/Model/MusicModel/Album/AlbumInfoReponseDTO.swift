//
//  AlbumInfo.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation


public struct AlbumInfoReponseDTO: Decodable {
    let id : String
    let title: String
    let releaseTime: String
    let image: String
//    let artist: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseTime 
        case image
//        case artist
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseTime = try container.decode(String.self, forKey: .releaseTime)
        self.image = try container.decode(String.self, forKey: .image)
//        self.artist = try container.decode(String.self, forKey: .artist)
    }
}
