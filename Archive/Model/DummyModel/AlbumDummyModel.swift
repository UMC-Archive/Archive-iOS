//
//  AlbumDummyModel.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import Foundation


struct AlbumDummyModel: Hashable {
    let id: Int
    let albumImageURL: String
    let albumTitle: String
    let artist: String
}


extension AlbumDummyModel {
    static func dummy() -> [AlbumDummyModel] {
        return [
            AlbumDummyModel(id: 0, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
            AlbumDummyModel(id: 1, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
            AlbumDummyModel(id: 2, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
            AlbumDummyModel(id: 3, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
            AlbumDummyModel(id: 4, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans")
        ]
    }
}
