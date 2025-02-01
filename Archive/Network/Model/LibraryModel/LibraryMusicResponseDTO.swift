//
//  MypageMusicResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/1/25.
//

import Foundation


public struct LibraryMusicResponseDTO: Decodable {
    let title: String
    let releaseTime: Int
    let image: String
    let artist: String
}
