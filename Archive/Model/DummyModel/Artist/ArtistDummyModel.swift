//
//  ArtistDummyModel.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import Foundation

struct ArtistDummyModel: Hashable {
    let artistId: Int
    let profileImageURL: String             // 아티스트 이미지
    let name: String                        // 가수
    let description: String                 // 설명
    let isHeart: Bool                       // 좋아요
    let popularMusicList: [MusicDummyModel] // 아티스트 인기곡
    let albumList: [AlbumDummyModel]        // 앨범 둘러보기
    let musicVideoList: [MusicVideoModel]   // 아티스트 뮤직 비디오
    let similarArtist: [SimilarArtistModel]      // 비슷한 아티스트
}


extension ArtistDummyModel {
    static func dummy() -> ArtistDummyModel {
        return ArtistDummyModel(artistId: 1, profileImageURL: "https://cdn.hankyung.com/photo/202410/01.38493988.1.jpg", name: "G-DRAGON", description: "지드래곤(본명: 권지용)은 1988년 8월 18일 서울특별시 용산구에서 아버지 권영환, 어머니 한기란의 아들로 태어났다. 형제로는 누나 1명이 있다. 어린 시절 어머니로부터 남다른 교육을 받고 자란 그는 1994년 《로그원》에 출연하며 연예계에 입문했다.[5][6] 이후 안무가 서용화의 눈에 띄어 또래의 친구들과 당시의 최고 인기그룹 룰라의 키즈 버전인 '꼬마 룰라'로 활동했다.[7][8] 또한 임권택 감독의 영화 《태백산맥》으로 아역배우로도 활동했던 경력이 있다.[9] 이후 또래 친구들과 같이 평범한 학교 생활을 하고 있었던 그는 가족들과 스키장에 놀러가서 우연히 서게 된 춤 대회에서 나이 많은 형들을 제치고 1등을 했고, 그 무대에서 사회를 보던 SM 엔터테인먼트의 이수만은 그의 끼를 알아보고 SM의 연습생으로 발탁되어, SM에서 가계약을 하고 5년 정도 연습생으로 속해 있었다. 하지만 뚜렷한 비전을 갖지 못했던 그는 숭의초등학교 3학년 때 절친한 친구의 집에서 우탱클랜 등의 흑인음악을 처음 접하고 큰 충격을 받고 힙합 장르에 관심을 갖게 되었다", isHeart: true, popularMusicList: MusicDummyModel.dummy(), albumList: AlbumDummyModel.dummy(), musicVideoList: MusicVideoModel.dummy(), similarArtist: SimilarArtistModel.dummy())
    }
}


