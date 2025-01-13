//
//  PointOfViewDummyModel.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import Foundation

struct PointOfViewDummyModel: Hashable {
    let id: Int
    let year: Int
    let month: Int
    let week: String
    let albumURL: String
}


extension PointOfViewDummyModel {
    static func dummy() -> [PointOfViewDummyModel] {
        return [
            PointOfViewDummyModel(id: 0, year: 2000, month: 10, week: "1st", albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400"),
            PointOfViewDummyModel(id: 1, year: 1955, month: 9, week: "3rd", albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400"),
            PointOfViewDummyModel(id: 2, year: 2000, month: 10, week: "2nd", albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400"),
            PointOfViewDummyModel(id: 3, year: 1955, month: 1, week: "1st", albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400"),
            PointOfViewDummyModel(id: 4, year: 2000, month: 10, week: "4th", albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400"),
            PointOfViewDummyModel(id: 5, year: 1955, month: 8, week: "1st", albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400"),
            PointOfViewDummyModel(id: 6, year: 2000, month: 10, week: "1st", albumURL: "https://musicmeta-phinf.pstatic.net/album/032/261/32261031.jpg?type=r360Fll&v=20241031162400"),
        ]
    }
}
