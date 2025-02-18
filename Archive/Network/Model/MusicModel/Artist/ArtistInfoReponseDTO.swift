//
//  ArtistInfo.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation

public struct ArtistInfoReponseDTO: Decodable, Hashable {
    let id: String
    let name: String
    let image: String
    
    init(id: String, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
    
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

extension ArtistInfoReponseDTO {
    static func loadingData() -> ArtistInfoReponseDTO {
        return ArtistInfoReponseDTO(id: "1", name: Constant.LoadString, image: Constant.LoadingImageURL)
    }
}
