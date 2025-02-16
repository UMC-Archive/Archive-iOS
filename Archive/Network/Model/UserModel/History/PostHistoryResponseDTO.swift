//
//  PostHistoryResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/10/25.
//

public struct PostHistoryResponseDTO: Decodable, Hashable {
    let id: String
    let userId: String
    let history: String
    
    enum CodingKeys: CodingKey {
        case id
        case userId
        case history
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.history = try container.decode(String.self, forKey: .history)
    }
}
