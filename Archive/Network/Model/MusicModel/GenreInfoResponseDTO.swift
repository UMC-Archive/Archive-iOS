//
//  GenreInfoResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 1/27/25.
//

import Foundation

public struct GenreInfoResponseDTO: Decodable {
    let id: String
    let name: String
    let image: String
}
