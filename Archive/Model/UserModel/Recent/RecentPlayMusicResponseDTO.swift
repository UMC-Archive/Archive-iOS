//
//  RecentPlayMusicDto.swift
//  Archive
//
//  Created by 송재곤 on 2/15/25.
//
import Foundation

public struct RecentPlayMusicResponseDTO: Decodable, Hashable {
    let userId: String
    let play: RecentPlayResponseDTO
    let music: RecentMusicDTO
    let album: AlbumInfoReponseDTO
    let artist: ArtistInfoReponseDTO
}

extension RecentPlayMusicResponseDTO {
    static func loadingData() -> RecentPlayMusicResponseDTO {
        return RecentPlayMusicResponseDTO(userId: "1", play: RecentPlayResponseDTO(id: "2"), music: RecentMusicDTO.loadingData(), album: AlbumInfoReponseDTO.loadingData(), artist: ArtistInfoReponseDTO.loadingData())
    }
}


public struct RecentPlayResponseDTO: Decodable, Hashable {
    let id: String
            
    init(id: String) {
        self.id = id
    }
    
    enum CodingKeys: CodingKey {
        case id
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
    }
}
