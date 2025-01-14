//
//  Section_Item.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import Foundation

enum HeaderTitle: String {
    case Archive = "당신을 위한 아카이브"
    case PointOfView = "탐색했던 시점"
    case FastSelection = "빠른 선곡"
    case RecommendMusic = "당신을 위한 추천곡"
    case RecentlyListendMusic = "최근 들은 노래"
    case RecentlyAddMusic = "최근에 추가한 노래"
    case none
}

enum Section: Hashable {
    case BigBanner(HeaderTitle) // 홈 - 당신을 위한 아카이브
    case PointOfView(HeaderTitle) // 홈 - 탐색했던 시점
    case Banner(HeaderTitle) // 홈 - 빠른 선곡 / 최근 들은 노래
    case Vertical(HeaderTitle) // 홈 - 당신을 위한 추천곡 / 최근에 추가한 노래
}

enum Item: Hashable {
    case ArchiveItem(MusicDummyModel) // 아카이브 아이템
    case PointItem(PointOfViewDummyModel) // 탐색했던 시점 아이템
    case FastSelectionItem(MusicDummyModel) // 빠른 선곡
    case RecommendMusicItem(MusicDummyModel) // 당신을 위한 추천곡
    case RecentlyListendMusicItem(MusicDummyModel) // 최근 들은 노래
    case RecentlyAddMusicItem(MusicDummyModel) // 최근에 추가한 노래
}
