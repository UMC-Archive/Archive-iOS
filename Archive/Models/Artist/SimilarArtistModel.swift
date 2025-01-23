//
//  SimilarArtistModel.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import Foundation

struct SimilarArtistModel: Hashable {
    let id: Int
    let imageURL: String
    let artist: String
}

extension SimilarArtistModel {
    static func dummy() -> [SimilarArtistModel] {
        return [
            SimilarArtistModel(id: 1, imageURL: "https://i.namu.wiki/i/bpYqBWs5CJw-cwxCcJtHBf_VKFCT_hYT_ohhmH-OyKs6tQqMEs5jNt3Szn5eX60K18tWEs1XlFWhvkf7r71wgw.webp", artist: "태양"),
            SimilarArtistModel(id: 2, imageURL: "https://file2.nocutnews.co.kr/newsroom/image/2023/01/03/202301031055521283_0.jpg", artist: "대성"),
            SimilarArtistModel(id: 3, imageURL: "https://img7.yna.co.kr/etc/inner/KR/2021/03/25/AKR20210325163000005_01_i_P2.jpg", artist: "빈지노"),
            SimilarArtistModel(id: 4, imageURL: "https://i.namu.wiki/i/BJ78_AUJY6bhb-mhg9EFmk-8FKrj0ymDqGR2Fmp-Ph9_Tx6yeSAGGQd1JGFsPk6nqHczTKbOP2ibZoLUbQZ9ZQ.webp", artist: "기리보이"),
            SimilarArtistModel(id: 5, imageURL: "https://i.namu.wiki/i/5AUJiLl8pL70JVp-3Wi85HN-ET6ubrbUglqSpEODMRCWwjxlZWZCfjikqqRlRhU5o11brHyplRlBqaC3Y6Vanw.webp", artist: "양홍원"),
        ]
    }
}
