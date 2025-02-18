//
//  ChooseArtistRequestDTO.swift
//  Archive
//
//  Created by 이수현 on 2/18/25.
//

import Foundation

public struct ChooseArtistRequestDTO: Encodable {
    let artist_name: String?
    let genre_id: [Int]
}
