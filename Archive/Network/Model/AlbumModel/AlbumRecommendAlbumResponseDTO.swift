//
//  AlbumRecommendAlbumResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/8/25.
//

import Foundation

public struct AlbumRecommendAlbumResponseDTO: Decodable {
    let album: ExploreRecommendAlbum
    let artist: String
}
