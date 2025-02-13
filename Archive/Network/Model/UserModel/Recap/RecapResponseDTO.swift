//
//  RecapResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/11/25.
//

import Foundation

public struct RecapResponseDTO: Decodable {
    let id: String
    let title: String
    let image: String
    let releaseYear: Int
    let artists: String
    let period: String
}
