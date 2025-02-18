//
//  LibraryAlbumResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/1/25.
//

public struct LibraryAlbumResponseDTO: Decodable {
    let id: String
    let title: String
    let image: String
    let artist: String
}
