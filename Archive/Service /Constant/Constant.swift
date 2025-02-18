//
//  File.swift
//  Archive
//
//  Created by 이수현 on 2/14/25.
//

import Foundation

public let FloatingViewHeight = 66

public enum Constant {
    static let FloatingViewHeight = 66 // 탭바
    static let LoadString = "Loading..."
    static let LoadingImageURL = "https://cdn.imweb.me/thumbnail/20230830/be4f689f63b2b.gif"
}

// 홈 로딩 데이터
extension Constant {
    // 당신을 위한 아카이브 로딩 데이터
    static let ArchiveLoadingData: [(AlbumRecommendAlbum, String)] = [
        (AlbumRecommendAlbum.loadingData(), Constant.LoadString)
    ]
    
    // 빠른 선곡 로딩 데이터
    static let FastSelectionLoadingData: [
        (MusicInfoResponseDTO, AlbumInfoReponseDTO, String)] = [
            (MusicInfoResponseDTO.loadingData(), AlbumInfoReponseDTO.loadingData(), Constant.LoadString)
        ]
    
    // 당신을 위한 추천곡 로딩 데이터
    static let RecommendMusicLoadingData: [
        (RecommendMusic, RecommendAlbum, String)] = [
            (RecommendMusic.loadingData(), RecommendAlbum.loadingData(), Constant.LoadString)
        ]
}


// 탐색 뷰 로딩 데이터
extension Constant {
    // 메인 CD 로딩 데이터
    static let MainCDLoadingData: [
        MainCDResponseDTO] = [
            MainCDResponseDTO.loadingData()
        ]
    
    // 숨겨진 명곡 로딩 데이터
    static let HiddenMusicLoadingData: [(HiddenMusicResponse, ExploreRecommendAlbum, String)] = [
        (HiddenMusicResponse.loadingData(), ExploreRecommendAlbum.loadingData(), Constant.LoadString)
    ]
    
    // 추천 음악 로딩 데이터
    static let ExploreRecommnedMusicLoadingData: [
        (ExploreRecommendMusic, ExploreRecommendAlbum, String)] = [
            (ExploreRecommendMusic.loadingData(), ExploreRecommendAlbum.loadingData(), Constant.LoadString)
        ]
    
    // 추천 앨범 로딩 데이터
    static let RecommendAlbumLoadingData: [
        (ExploreRecommendAlbum, String)] = [
            (ExploreRecommendAlbum.loadingData(), Constant.LoadString)
        ]
}
