//
//  MypageMusicResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/1/25.
//

import Foundation


public struct LibraryMusicResponseDTO: Decodable {
    let music: LibraryMusicDTO
    let album: LibraryAlbumDTO
    let artist: String
}
struct LibraryMusicDTO: Decodable {
    let id: String
    let title: String
    let releaseTime: Int
    let image: String
}

struct LibraryAlbumDTO: Decodable {
    let id: String
    let title: String
    let releaseTime: Int
    let image: String
}

