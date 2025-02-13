//
//  AllInfoResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/11/25.
//

import Foundation

public struct AllInfoResponseDTO: Decodable {
    let music: AllMusicInfoReponseDTO
    let album: AllAlbumInfoReponseDTO
    let artist: AllArtistInfoReponseDTO
}


public struct AllMusicInfoReponseDTO: Decodable {
    let name: Bool
    let value: Bool
    let info: AllMusicInfoResponse
}

public struct AllAlbumInfoReponseDTO: Decodable {
    let name: Bool
    let value: Bool
    let info: AllAlbumInfoResponse
}


public struct AllArtistInfoReponseDTO: Decodable {
    let name: Bool
    let value: Bool
    let info: AllArtistInfoResponse
}



public struct AllMusicInfoResponse: Decodable {
    let id: String?
    
    enum CodingKeys: CodingKey {
        case id
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
    }
}

public struct AllAlbumInfoResponse: Decodable {
    let id: String?
    
    enum CodingKeys: CodingKey {
        case id
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
    }
}

public struct AllArtistInfoResponse: Decodable {
    let id: String?
    
    enum CodingKeys: CodingKey {
        case id
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
    }
}
