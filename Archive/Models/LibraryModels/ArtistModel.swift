//
//  ArtistModel.swift
//  Archive
//
//  Created by 송재곤 on 1/11/25.
//

import UIKit

struct ArtistModel {
    let albumImage: UIImage
    let artistName: String
}

extension ArtistModel {
    static func dummy() -> [ArtistModel]{
        return [//구분을 위해 빨강 추가
            ArtistModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), artistName: "NewJeans"),
            ArtistModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), artistName: "Kiss OF LiFE"),
            ArtistModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), artistName: "Twis"),
            ArtistModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), artistName: "NewJeans"),
            ArtistModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), artistName: "Kiss OF LiFE"),
            ArtistModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), artistName: "Twis"),
            ArtistModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), artistName: "NewJeans"),
            ArtistModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), artistName: "Kiss OF LiFE"),
            ArtistModel(albumImage: UIImage(named: "myPageIcon")?.withTintColor(.red) ?? UIImage(), artistName: "Twis"),
            
            
        ]
    }
}
