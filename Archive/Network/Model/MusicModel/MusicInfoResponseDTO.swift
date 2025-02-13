//
//  MusicInfo.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation


public struct MusicInfoResponseDTO: Decodable {
    let id: String
    let albumId: String
    let title: String
    let releaseTime: String
    let lyrics: String
    let image: String
    let music: String
    let createdAt: String
    let updatedAt: String
}
