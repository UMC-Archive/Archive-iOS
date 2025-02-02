//
//  AlbumCurationReponseDTO.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation


public struct AlbumCurationReponseDTO: Decodable {
    let id: String
    let albumId: String
    let description: String // Description API 분리
    let createdAt: String
    let updatedAt: String
}
