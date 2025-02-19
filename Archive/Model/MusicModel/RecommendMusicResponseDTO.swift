//
//  RecommendMusicResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/9/25.
//

import Foundation

public struct RecommendMusicResponseDTO: Decodable {
    let music: RecommendMusic
    let album: RecommendAlbum
    let artist: String
}

public struct RecommendMusic: Decodable, Hashable {
    let id: String
    let albumId: String
    let title: String
    let releaseTime: String
    let image: String
    
    init(id: String, albumId: String, title: String, releaseTime: String, image: String) {
        self.id = id
        self.albumId = albumId
        self.title = title
        self.releaseTime = releaseTime
        self.image = image
    }
    
    enum CodingKeys: CodingKey {
        case id
        case albumId
        case title
        case releaseTime
        case image
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.albumId = try container.decode(String.self, forKey: .albumId)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseTime = try container.decode(String.self, forKey: .releaseTime)
        self.image = try container.decode(String.self, forKey: .image)
    }
}

extension RecommendMusic {
    static func loadingData() -> RecommendMusic {
        return RecommendMusic(id: "1", albumId: "1", title: Constant.LoadString, releaseTime: "", image: Constant.LoadingImageURL)
    }
}

public struct RecommendAlbum: Decodable, Hashable {
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

extension RecommendAlbum {
    static func loadingData() -> RecommendAlbum {
        return RecommendAlbum(id: "1", title: Constant.LoadString, releaseTime: "", image: Constant.LoadingImageURL)
    }
}
