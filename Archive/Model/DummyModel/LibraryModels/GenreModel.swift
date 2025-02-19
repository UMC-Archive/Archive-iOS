//
//  GenreModel.swift
//  Archive
//
//  Created by 송재곤 on 1/10/25.
//

import UIKit

struct GenreModel {
    let albumImage: UIImage 
    let songName: String
    let artist: String
    let year: String
}

extension GenreModel {
    static func dummy() -> [GenreModel]{
        return [//구분을 위해 빨강 추가
            GenreModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), songName: "How Sweet", artist: "NewJeans", year: "2024"),
            GenreModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Attention", artist: "NewJeans", year: "2022"),
            GenreModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Ditto", artist: "NewJeans", year: "2022"),
            GenreModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "How Sweet", artist: "NewJeans", year: "2024"),
            GenreModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Attention", artist: "NewJeans", year: "2022"),
            GenreModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Ditto", artist: "NewJeans", year: "2022"),
            GenreModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "How Sweet", artist: "NewJeans", year: "2024"),
            GenreModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Attention", artist: "NewJeans", year: "2022"),
            GenreModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Ditto", artist: "NewJeans", year: "2022"),
        ]
    }
}
