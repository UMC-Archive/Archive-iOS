//
//  AlbumInfo.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation


public struct AlbumInfoReponseDTO: Decodable {
    let id : String
    let title: String
    let releaseTime: String
    let image: String
    let artist: String
}
