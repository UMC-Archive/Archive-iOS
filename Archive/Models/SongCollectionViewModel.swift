//
//  SongCollectionViewModel.swift
//  Archive
//
//  Created by 송재곤 on 1/10/25.
//

import UIKit

struct SongCollectionViewModel {
    let albumImage: UIImage //collectionView로 변경예정?
    let songName: String
    let artist: String
    let year: String
}

extension SongCollectionViewModel {
    static func dummy() -> [SongCollectionViewModel]{
        return [
            SongCollectionViewModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "How Sweet", artist: "NewJeans", year: "2024"),
            SongCollectionViewModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Attention", artist: "NewJeans", year: "2022"),
            SongCollectionViewModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Ditto", artist: "NewJeans", year: "2022"),
            SongCollectionViewModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "How Sweet", artist: "NewJeans", year: "2024"),
            SongCollectionViewModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Attention", artist: "NewJeans", year: "2022"),
            SongCollectionViewModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Ditto", artist: "NewJeans", year: "2022"),
            SongCollectionViewModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "How Sweet", artist: "NewJeans", year: "2024"),
            SongCollectionViewModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Attention", artist: "NewJeans", year: "2022"),
            SongCollectionViewModel(albumImage: UIImage(named: "myPageIcon") ?? UIImage(), songName: "Ditto", artist: "NewJeans", year: "2022"),
           
        ]
    }
}
