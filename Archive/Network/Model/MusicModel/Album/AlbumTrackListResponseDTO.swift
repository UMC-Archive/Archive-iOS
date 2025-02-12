//
//  AlbumTrackListResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/12/25.
//

import Foundation

public struct AlbumTrackListResponseDTO: Decodable {
    let album: AlbumTrackListResponse
    let tracks: [TrackListResponse]
}

public struct AlbumTrackListResponse: Decodable {
    let id: String
    let title: String
    let image: String
    let artist: String
    let releaseTime: Int
}

public struct TrackListResponse: Decodable {
    let id: String
    let title: String
    let artist: String
    let image: String
    let releaseTime: Int
}
