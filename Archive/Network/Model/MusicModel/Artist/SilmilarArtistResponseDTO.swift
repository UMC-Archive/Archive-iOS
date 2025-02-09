//
//  SilmilarArtistResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/9/25.
//

import Foundation

public struct SilmilarArtistResponseDTO: Decodable {
    let artists: [SimilarArtistResponse]
}


public struct SimilarArtistResponse: Decodable, Hashable {
    let id: String
    let name: String
    let image: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case image
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
    }
}
