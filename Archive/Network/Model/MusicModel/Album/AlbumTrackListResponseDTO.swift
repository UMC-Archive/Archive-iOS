//
//  AlbumTrackListResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/12/25.
//

import Foundation

public struct AlbumTrackListResponseDTO: Decodable {
    let tracks: [TrackListResponse]
    
    enum CodingKeys: CodingKey {
        case tracks
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tracks = try container.decode([TrackListResponse].self, forKey: .tracks)
    }
}

public struct TrackListResponse: Decodable {
    let id: String
    let title: String
    let artist: String
    let image: String
    let releaseTime: Int
}
