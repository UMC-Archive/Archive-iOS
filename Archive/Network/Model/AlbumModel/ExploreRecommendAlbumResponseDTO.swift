//
//  ExploreRecommendAlbumResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/1/25.
//

import Foundation

public struct ExploreRecommendAlbumResponseDTO: Decodable {
    let album: ExploreRecommendAlbum
    let artist: String
}

public struct ExploreRecommendAlbum: Decodable, Hashable {
    let id: String
    let title: String
    let releaseTime: String
    let image: String
    
    init(id: String, title: String, releaseTime: String, image: String) {
        self.id = id
        self.title = title
        self.releaseTime = releaseTime
        self.image = image
    }
    
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

extension ExploreRecommendAlbum {
    static func loadingData() -> ExploreRecommendAlbum {
        return ExploreRecommendAlbum(id: "1", title: Constant.LoadString, releaseTime: "", image: Constant.LoadingImageURL)
    }
}
