//
//  LibraryArtistDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/1/25.
//

public struct LibraryArtistResponseDTO: Decodable {
    let artist: artistArtistDTO
    let album: [artistAlbumDTO]
}

struct artistArtistDTO: Decodable {
    let id: String
    let name: String
    let image: String
}

struct artistAlbumDTO: Decodable {
    let id: String
    let title: String
    let releaseTime: Int
    let image: String
}
