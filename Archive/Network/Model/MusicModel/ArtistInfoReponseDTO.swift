//
//  ArtistInfo.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation

public struct ArtistInfoReponseDTO: Decodable {
    let id: String
    let name: String
    let image: String
    let description: String
    let createdAt: String
    let updatedAt: String
}
