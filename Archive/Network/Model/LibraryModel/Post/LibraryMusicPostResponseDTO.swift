//
//  LibraryMusicPostResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/10/25.
//

import Foundation

public struct LibraryMusicPostResponseDTO: Decodable {
    let id: String
    let libraryId: String
    let musicId: String
    let createdAt: String
    let updatedAt: String
}
