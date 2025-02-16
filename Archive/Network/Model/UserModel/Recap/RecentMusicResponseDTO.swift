//
//  RecentMusicResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/15/25.
//

public struct RecentMusicResponseDTO: Decodable {
    
    let music: RecentMusicDTO
}

struct RecentMusicDTO: Decodable {
    let id: String
    let title: String
    let releaseTime: String
    let image: String
    let updatedAt: String
    let artist: ArtistDTO
}

struct ArtistDTO: Decodable {
    let name: String
}

