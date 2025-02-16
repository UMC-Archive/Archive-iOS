//
//  MainCDResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/15/25.
//

import Foundation

public struct MainCDResponseDTO: Decodable {
    let music: MusicInfoResponseDTO
    let album: AlbumInfoReponseDTO
    let artist: String
}
