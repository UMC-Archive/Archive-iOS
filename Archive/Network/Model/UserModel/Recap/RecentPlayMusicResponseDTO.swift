//
//  RecentPlayMusicDto.swift
//  Archive
//
//  Created by 송재곤 on 2/15/25.
//

public struct RecentPlayMusicResponseDTO: Decodable {
    let userId: String
    let play: PlayDTO
    let music: MusicDTO
    let album: AlbumDTO
    let artist: ArtistDTO
}

struct PlayDTO: Decodable {
    let id: String
    let createdAt: String
    let updatedAt: String
}

struct MusicDTO: Decodable {
    let id: String
    let title: String
    let releaseTime: String
    let image: String
}

struct AlbumDTO: Decodable {
    let id: String
    let title: String
    let image: String
}

struct ArtistDTO: Decodable {
    let id: String
    let name: String
    let image: String
}
