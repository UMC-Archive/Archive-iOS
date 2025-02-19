//
//  SelectionResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/13/25.
//

import Foundation

public struct SelectionResponseDTO: Decodable {
    let music: MusicInfoResponseDTO
    let album: AlbumInfoReponseDTO
    let artist: String
}

extension SelectionResponseDTO {
    static func loadingData() -> SelectionResponseDTO {
        return SelectionResponseDTO(music: MusicInfoResponseDTO.loadingData(), album: AlbumInfoReponseDTO.loadingData(), artist: Constant.LoadString)
    }
}
