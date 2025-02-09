//
//  GetHistoryResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/9/25.
//

import Foundation

public struct GetHistoryResponseDTO: Decodable {
    let id: String
    let history: String
    
    enum CodingKeys: CodingKey {
        case id
        case history
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.history = try container.decode(String.self, forKey: .history)
    }
}
