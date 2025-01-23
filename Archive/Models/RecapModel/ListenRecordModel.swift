//
//  ListenRecordModel.swift
//  Archive
//
//  Created by 송재곤 on 1/19/25.
//

import UIKit

struct ListenRecordModel {
    let albumImage: UIImage
    let albumName: String
}

extension ListenRecordModel{
    static func dummy() -> [ListenRecordModel] {
        return [
            ListenRecordModel(albumImage: UIImage(named: "test1") ?? UIImage(), albumName: "NewJeans"),
            ListenRecordModel(albumImage: UIImage(named: "test1") ?? UIImage(), albumName: "Kiss OF LiFE"),
            ListenRecordModel(albumImage: UIImage(named: "test1") ?? UIImage(), albumName: "Twis"),
            ListenRecordModel(albumImage: UIImage(named: "test1") ?? UIImage(), albumName: "NewJeans"),
            ListenRecordModel(albumImage: UIImage(named: "test1") ?? UIImage(), albumName: "Kiss OF LiFE"),
            ListenRecordModel(albumImage: UIImage(named: "test1") ?? UIImage(), albumName: "Twis"),
            ListenRecordModel(albumImage: UIImage(named: "test1") ?? UIImage(), albumName: "NewJeans"),
            ListenRecordModel(albumImage: UIImage(named: "test1") ?? UIImage(), albumName: "Kiss OF LiFE"),
            ListenRecordModel(albumImage: UIImage(named: "test1") ?? UIImage(), albumName: "Twis"),
            
            
        ]
    }
}
