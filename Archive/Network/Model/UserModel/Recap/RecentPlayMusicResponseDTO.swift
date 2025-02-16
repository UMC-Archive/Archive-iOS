//
//  RecentPlayMusicDto.swift
//  Archive
//
//  Created by 송재곤 on 2/15/25.
//

public struct RecentPlayMusicResponseDTO: Decodable {
    
    let id: String
    let userId: String
    let musicId: String
    let musicTitle: String
    let musicImage: String
    let artists: [recentArtistDTO]
    let createdAt: String
    let updatedAt: String
}

struct recentArtistDTO: Decodable {
    let artistId: String
    let artistName: String
    let artistImage: String
}

