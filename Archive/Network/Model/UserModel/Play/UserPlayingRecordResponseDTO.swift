//
//  UserPlayingRecordResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/5/25.
//

import Foundation


public struct UserPlayingRecordResponseDTO: Decodable {
    let id: String
    let userId: String
    let musicId: String
    
    enum CodingKeys: CodingKey {
        case id
        case userId
        case musicId
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.musicId = try container.decode(String.self, forKey: .musicId)
    }
}
