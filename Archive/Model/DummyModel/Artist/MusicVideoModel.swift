//
//  MusicVideoModel.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import Foundation

struct MusicVideoModel: Hashable {
    let id: Int
    let imageURL: String
    let title: String
    let artist: String
}

extension MusicVideoModel {
    static func dummy() -> [MusicVideoModel] {
        return [
            MusicVideoModel(id: 1, imageURL: "https://image.xportsnews.com/contents/images/upload/article/2024/1031/1730371339427826.jpg", title: "POWER", artist: "G-DRAGON"),
            MusicVideoModel(id: 2, imageURL: "https://i.ytimg.com/vi/9kaCAbIXuyg/maxresdefault.jpg", title: "무제", artist: "G-DRAGON"),
            MusicVideoModel(id: 3, imageURL: "https://image.xportsnews.com/contents/images/upload/article/2024/1031/1730371339427826.jpg", title: "POWER", artist: "G-DRAGON"),
            MusicVideoModel(id: 4, imageURL: "https://i.ytimg.com/vi/doFK7Eanm3I/maxresdefault.jpg", title: "니가 뭔데", artist: "G-DRAGON"),
            MusicVideoModel(id: 5, imageURL: "https://i.ytimg.com/vi/RKhsHGfrFmY/maxresdefault.jpg", title: "삐딱하게", artist: "G-DRAGON")
        ]
    }
}
