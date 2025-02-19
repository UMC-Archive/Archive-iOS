//
//  MusicResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/18/25.
//

import Foundation

public struct MusicResponseDTO: Decodable {
    let music: MusicInfoResponseDTO
    let artist: ArtistInfoReponseDTO
}
