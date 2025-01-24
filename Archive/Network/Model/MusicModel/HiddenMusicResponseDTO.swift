//
//  HiddenMusicResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 1/24/25.
//

import Foundation

public struct HiddenMusicResponseDTO: Decodable {
    let musics: [HiddenMusicResponse]
}

public struct HiddenMusicResponse: Decodable {
    let id: String
    let albumId: String
    let title: String
    let releaseTime: String
    let lyrics: String
    let image: String
    let createdAt: String
    let updatedAt: String
}

/*
 "musics": [
   {
     "id": 1,
     "albumId": 1,
     "title": "Celebrity",
     "releseTime": "2021-03-25",
     "lyics": "세상의 모서리 구부정하게 커버린 골칫거리 outsider (ah ah)",
     "image": "https://example.com/music_image.jpg",
     "createdAt": "2025-01-01",
     "updatedAt": "2025-01-01"
   }
 ]
 */
