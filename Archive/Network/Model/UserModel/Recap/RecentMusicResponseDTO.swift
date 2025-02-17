//
//  RecentMusicResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/15/25.
//

public struct RecentMusicResponseDTO: Decodable {
    let music: RecentMusicDTO
    let album: RecentAlbumDTO
    let artist: RecentArtistDTO
}

struct RecentMusicDTO: Decodable {
    let id: String
    let title: String
    let releaseTime: String
    let image: String
    let updatedAt: String
}

struct RecentAlbumDTO: Decodable {
    let id: String
    let title: String
    let releaseTime: String
    let image: String
}

struct RecentArtistDTO: Decodable {
    let name: String
}

