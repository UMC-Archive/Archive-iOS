//
//  RecentMusicResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/15/25.
//
import Foundation

public struct RecentMusicResponseDTO: Decodable, Hashable {
    let music: RecentMusicDTO
    let album: AlbumInfoReponseDTO
    let artist: ArtistDTO
}

extension RecentMusicResponseDTO {
    static func loadingData() -> RecentMusicResponseDTO {
        return RecentMusicResponseDTO(music: RecentMusicDTO.loadingData(), album: AlbumInfoReponseDTO.loadingData(), artist: ArtistDTO(name: ""))
    }
}



public struct RecentMusicDTO: Decodable, Hashable {
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

extension RecentMusicDTO {
    static func loadingData() -> RecentMusicDTO {
        return RecentMusicDTO(id: "1", title: "노래를 재생해주세요!", releaseTime: "", image: "")
    }
}



public struct ArtistDTO: Decodable, Hashable {
    let name: String
}

