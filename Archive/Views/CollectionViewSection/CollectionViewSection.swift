//
//  CollectionViewSection.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import Foundation

enum HeaderTitle: String {
    case Banner = "당신을 위한 아카이브"
}

enum Section: Hashable {
    case Banner(HeaderTitle) // 홈 - 당신을 위한 아카이브
}

enum Item: Hashable {
    case musicItem(DummyModel) // 앨범 아이템
}
