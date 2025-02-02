//
//  ArtistCurationResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/1/25.
//

import Foundation


public struct ArtistCurationResponseDTO: Decodable {
    let id: String
    let artistId: String
    let description: String
    
    enum CodingKeys: CodingKey {
        case id
        case artistId
        case description
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.artistId = try container.decode(String.self, forKey: .artistId)
        self.description = try container.decode(String.self, forKey: .description)
    }
}
