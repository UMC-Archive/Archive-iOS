//
//  AlbumCurationDummyModel.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import Foundation

let albumImage = "https://i.namu.wiki/i/OeTn8iKBxoVy2CowtEAuPJCYIjoeQlveyg2xmPlIgcHtUEBi3q62QUArv-Uekse76QKmQvIpS6_WSf4Tva2APnUJQSOiXbnADfEw7sb1n4bNC6D8AtfG_72r2EQlLKYJq4l3wislCX2J9jjUzsrpCQ.webp"

struct AlbumCurationDummyModel {
    let albumImageURL: String
    let title: String
    let artist: String
    let content: String
    let albumTrack: AlbumTrack // 수록곡
    let anotherAlbum: [AlbumDummyModel] // 이 아티스트의 다른 앨범
    let recommendAlbum: [AlbumDummyModel] // 당신을 위한 추천 앨범
}


struct AlbumTrack {
    let albumImageURL: String
    let title: String
    let artist: String
    let year: Int
    let count: Int
    let totalMinute: Int
    let musicList: [MusicDummyModel]
}


extension AlbumCurationDummyModel {
    static func dummy() -> AlbumCurationDummyModel {
        return AlbumCurationDummyModel(
            albumImageURL: albumImage,
            title: "How Sweet", artist: "New Jeans",
            content: "《'The Spaghetti Incident?'》는 미국의 하드 록 밴드 건즈 앤 로지스의 다섯 번째 스튜디오 음반이다. 이 음반은 오래된 펑크 록과 하드 록 노래들로 커버되어 있다. 《'The Spaghetti Incident?'》는 리듬 기타리스트 길비 클라크가 나오는 유일한 스튜디오 음반으로 1991년 밴드의 Use Your Illusion Tour에서 원래 건즈 앤 로지스의 멤버 이지 스트래들린을 대체했고, 기타리스트 슬래시, 베이시스트 더프 맥케이건, 드러머 맷 소럼을 포함한 마지막 음반을 선보였다. 이 음반은 또한 지지 투어를 동반하지 않은 유일한 건즈 앤 로지스 음반이다. \n\n이 음반은 투어가 지원되지 않는 유일한 건즈 앤 로지스 음반이다. 일반적으로 비평적으로 호평을 받았지만, 이 음반은 2018년까지 미국에서 100만 장이 팔리면서 밴드의 최악의 판매 스튜디오 음반이다.",
            albumTrack: AlbumTrack(albumImageURL: albumImage,
                                   title: "How Sweet",
                                   artist: "New Jeans",
                                   year: 2024,
                                   count: 2,
                                   totalMinute: 14,
                                   musicList: [
                                    MusicDummyModel(musicId: 0, albumURL: albumImage, albumTitle: "How Sweet", albumSubTitle: "", genre: "", musicTitle: "How Sweet", artist: "New Jeans", year: 2024),
                                    MusicDummyModel(musicId: 0, albumURL: albumImage, albumTitle: "Bubble Gum", albumSubTitle: "", genre: "", musicTitle: "How Sweet", artist: "New Jeans", year: 2024)
                                   ]),
            anotherAlbum: [
                AlbumDummyModel(id: 0, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
                AlbumDummyModel(id: 1, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
                AlbumDummyModel(id: 2, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
                AlbumDummyModel(id: 3, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
                AlbumDummyModel(id: 4, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans")
            ],
            
            recommendAlbum: [
                AlbumDummyModel(id: 0, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
                AlbumDummyModel(id: 1, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
                AlbumDummyModel(id: 2, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
                AlbumDummyModel(id: 3, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans"),
                AlbumDummyModel(id: 4, albumImageURL: albumImage, albumTitle: "NewJeans 2nd EP", artist: "New Jeans")
            ]
        )
    }
}
