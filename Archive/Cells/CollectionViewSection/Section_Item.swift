//
//  Section_Item.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import Foundation

enum HeaderTitle: String {
    case Archive = "당신을 위한 아카이브"            // 홈뷰
    case PointOfView = "탐색했던 시점"             // 홈뷰
    case FastSelection = "빠른 선곡"              // 홈뷰
    case RecommendMusic = "당신을 위한 추천곡"      // 홈뷰, 탐색뷰
    case RecentlyPlayedMusic = "최근 들은 노래"   // 홈뷰
    case RecentlyAddMusic = "최근에 추가한 노래"    // 홈뷰
    case AnotherAlbum = "이 아티스트의 다른 앨범"    //  앨범뷰
    case RecommendAlbum = "당신을 위한 앨범 추천"    // 앨범뷰, 탐색뷰
    case HiddenMusic = "숨겨진 명곡"               // 탐색뷰
    case recap = "Recap 결산"
    case listenRecord = "청취기록"
    case profile = "프로필 수정"
    case ArtistPopularMusic = "아티스트 인기곡"    // 아티스트뷰
    case SameArtistAnotherAlbum = "앨범 둘러보기"  // 아티스트뷰
    case MusicVideo = "아티스트 뮤직비디오"           // 아티스트뷰
    case SimilarArtist = "다른 비슷한 아티스트"      // 아티스트뷰
}

enum Section: Hashable {
    case BigBanner(HeaderTitle) // 홈 - 당신을 위한 아카이브
    case PointOfView(HeaderTitle) // 홈 - 탐색했던 시점
    case Banner(HeaderTitle) // 홈 - 빠른 선곡 / 최근 들은 노래
    case Vertical(HeaderTitle) // 홈 - 당신을 위한 추천곡 / 최근에 추가한 노래
    case MusicVideoCell(HeaderTitle) // 아티스트 뮤직 비디오
    case Circle(HeaderTitle)        // 다른 비슷한 아티스트
}

enum Item: Hashable {
    case ArchiveItem(AlbumRecommendAlbum, String)                // 아카이브 아이템
    case PointItem(UserHistoryResponseDTO, String)            // 탐색했던 시점 아이템
    case FastSelectionItem(MusicInfoResponseDTO, AlbumInfoReponseDTO, String)          // 빠른 선곡
    case RecommendMusic(RecommendMusic, RecommendAlbum, String)       // 당신을 위한 추천곡 (홈 뷰)
    case RecommendAlbum(AlbumRecommendAlbum, String)       // 당신을 위한 앨범 추천(앨범 뷰)
    case ExploreRecommendMusic(ExploreRecommendMusic, ExploreRecommendAlbum, String)       // 당신을 위한 추천곡 (탐색 뷰)
    case ExploreRecommendAlbum(ExploreRecommendAlbum, String)    // 당신을 위한 앨범 추천(탐색 뷰)
    case RecentlyPlayedMusicItem(RecentPlayMusicResponseDTO)   // 최근 들은 노래
    case RecentlyAddMusicItem(RecentMusicResponseDTO)       // 최근에 추가한 노래
    case AnotherAlbum(AnotherAlbumResponseDTO, String)               // 이 아티스트의 다른 앨범
    case HiddenMusic(HiddenMusicResponse, ExploreRecommendAlbum, String)         // 숨겨진 명곡
    case ArtistPopularMusic(MusicInfoResponseDTO, AlbumInfoReponseDTO, String)        // 아티스트 인기곡
    case SameArtistAnotherAlbum(SameArtistAnotherAlbumResponseDTO, String)     // 앨범 둘러보기
    case MusicVideo(MusicVideoModel)                // 아티스트 뮤직비디오
    case SimilarArtist(ArtistInfoReponseDTO, AlbumInfoReponseDTO)          // 다른 비슷한 아티스트
}
