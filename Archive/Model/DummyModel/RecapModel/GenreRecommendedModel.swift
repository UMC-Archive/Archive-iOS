//
//  GenreRecommendedModel.swift
//  Archive
//
//  Created by 송재곤 on 1/18/25.
//

import UIKit

struct GenreRecommendedModel {
    let AlbumImage : UIImage
}

extension GenreRecommendedModel {
    static func dummy() -> [GenreRecommendedModel]{
        return [//구분을 위해 빨강 추가
            GenreRecommendedModel(AlbumImage: .indiePattern),
            GenreRecommendedModel(AlbumImage: .popPattern),
            GenreRecommendedModel(AlbumImage: .funkPattern),
            GenreRecommendedModel(AlbumImage: .electronicPattern),
            GenreRecommendedModel(AlbumImage: .balladPattern)
            
            
            
        ]
    }
}
