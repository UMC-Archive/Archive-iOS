//
//  RecentPlayMusicDto.swift
//  Archive
//
//  Created by 송재곤 on 2/15/25.
//
import Foundation

public struct RecentPlayMusicResponseDTO: Decodable, Hashable {
    let id: String
    let userId: String
    let musicId: String
    let musicTitle: String
    let musicImage: String
    let artists: [recentArtistDTO]
    let createdAt: String
    let updatedAt: String
}

struct recentArtistDTO: Decodable, Hashable {
    let artistId: String
    let artistName: String
    let artistImage: String
}

