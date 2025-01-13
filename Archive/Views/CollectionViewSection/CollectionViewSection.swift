//
//  CollectionViewSection.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import Foundation

enum HeaderTitle: String {
    case Banner = "당신을 위한 아카이브"
    case PointOfView = "탐색했던 시점"
}

enum Section: Hashable {
    case Banner(HeaderTitle) // 홈 - 당신을 위한 아카이브
    case PointOfView(HeaderTitle) // 홈 - 탐색했던 시점
}

enum Item: Hashable {
    case musicItem(MusicDummyModel) // 앨범 아이템
    case pointItem(PointOfViewDummyModel) // 탐색했던 시점 아이템
}
