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
    
    init(music: MusicInfoResponseDTO, album: AlbumInfoReponseDTO, artist: String) {
        self.music = music
        self.album = album
        self.artist = artist
    }
}

extension MainCDResponseDTO {
    static func loadingData() -> MainCDResponseDTO {
        return MainCDResponseDTO(music: MusicInfoResponseDTO.loadingData(), album: AlbumInfoReponseDTO.loadingData(), artist: Constant.LoadString)
    }
}
