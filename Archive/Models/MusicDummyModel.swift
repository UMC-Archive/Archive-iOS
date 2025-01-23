//
//  MusicDummyModel.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import Foundation

struct MusicDummyModel: Hashable {
    let musicId: Int
    let albumURL: String
    let albumTitle: String
    let albumSubTitle: String
    let genre: String
    let musicTitle: String
    let artist: String
    let year: Int
}

extension MusicDummyModel {
    static func dummy() -> [MusicDummyModel] {
        return [
            MusicDummyModel(musicId: 1,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            MusicDummyModel(musicId: 2,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            MusicDummyModel(musicId: 3,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            MusicDummyModel(musicId: 4,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            MusicDummyModel(musicId: 5,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            MusicDummyModel(musicId: 6,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            MusicDummyModel(musicId: 7,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            MusicDummyModel(musicId: 8,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            MusicDummyModel(musicId: 9,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            MusicDummyModel(musicId: 10,
                       albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400",
                       albumTitle: "POWER",
                       albumSubTitle: "POWER입니다",
                       genre: "랩/힙합",
                       musicTitle: "POWER",
                       artist: "G-DRAGN",
                       year: 2024),
            
        ]
    }
}
