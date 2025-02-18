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
