//
//  AlbumModel.swift
//  Archive
//
//  Created by 송재곤 on 1/11/25.
//

import UIKit

struct AlbumModel {
    let albumImage: UIImage
    let albumName: String
}

extension AlbumModel {
    static func dummy() -> [AlbumModel]{
        return [//구분을 위해 빨강 추가
            AlbumModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), albumName: "NewJeans"),
            AlbumModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), albumName: "Kiss OF LiFE"),
            AlbumModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), albumName: "Twis"),
            AlbumModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), albumName: "NewJeans"),
            AlbumModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), albumName: "Kiss OF LiFE"),
            AlbumModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), albumName: "Twis"),
            AlbumModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), albumName: "NewJeans"),
            AlbumModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), albumName: "Kiss OF LiFE"),
            AlbumModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), albumName: "Twis"),
            
            
        ]
    }
}
