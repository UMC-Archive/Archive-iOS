//
//  ChooseArtistResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/2/25.
//

import Foundation

public struct ChooseArtistResponseDTO: Decodable {
    let artists: [ArtistInfoReponseDTO]
}
