//
//  AlbumPost.swift
//  Archive
//
//  Created by 송재곤 on 2/13/25.
//

import Foundation

public struct LibraryAlbumPostResponseDTO: Decodable {
    let id: String
    let libraryId: String
    let albumId: String
    let createdAt: String
    let updatedAt: String
}
