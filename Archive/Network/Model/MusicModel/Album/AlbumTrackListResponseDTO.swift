//
//  AlbumTrackListResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/12/25.
//

import Foundation

public struct AlbumTrackListResponseDTO: Decodable {
    let album: AlbumTrackListResponse
    let tracks: [TrackListResponse]
}

public struct AlbumTrackListResponse: Decodable {
    let id: String
    let title: String
    let image: String
    let artistId: String
    let artist: String
    let artistImage: String
    let releaseTime: Int
    let totalDuration: Int
    let trackCount: Int
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case image
        case artistId
        case artist
        case artistImage
        case releaseTime
        case totalDuration
        case trackCount
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.image = try container.decode(String.self, forKey: .image)
        self.artistId = try container.decode(String.self, forKey: .artistId)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.artistImage = try container.decode(String.self, forKey: .artistImage)
        self.releaseTime = try container.decode(Int.self, forKey: .releaseTime)
        self.totalDuration = try container.decode(Int.self, forKey: .totalDuration)
        self.trackCount = try container.decode(Int.self, forKey: .trackCount)
    }
}

public struct TrackListResponse: Decodable {
    let id: String
    let title: String
    let artist: String
    let image: String
    let releaseTime: Int
    
    init(id: String, title: String, artist: String, image: String, releaseTime: Int) {
        self.id = id
        self.title = title
        self.artist = artist
        self.image = image
        self.releaseTime = releaseTime
    }
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case artist
        case image
        case releaseTime
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.image = try container.decode(String.self, forKey: .image)
        self.releaseTime = try container.decode(Int.self, forKey: .releaseTime)
    }
}

extension TrackListResponse {
    static func loadingData() -> TrackListResponse {
        return TrackListResponse(id: "1", title: Constant.LoadString, artist: Constant.LoadString, image: Constant.LoadingImageURL, releaseTime: 0)
    }
}
