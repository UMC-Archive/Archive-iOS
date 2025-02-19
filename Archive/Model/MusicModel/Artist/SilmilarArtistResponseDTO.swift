//
//  SimilarArtistResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/9/25.
//

import Foundation

public struct SimilarArtistResponseDTO: Decodable {
    let album: AlbumInfoReponseDTO
    let artist: ArtistInfoReponseDTO
}
