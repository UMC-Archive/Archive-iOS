//
//  GetHistoryResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 2/9/25.
//

import Foundation

public struct GetHistoryResponseDTO: Decodable {
    let userHistory: UserHistoryResponseDTO
    let historyImage: String?
}

public struct UserHistoryResponseDTO: Decodable, Hashable {
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

/*
 "result": [
     {
       "userHistory": {
         "id": "16",
         "userId": "1",
         "history": "2010-02-02T00:00:00.000Z",
         "createdAt": "2025-02-11T06:59:16.830Z",
         "updatedAt": "2025-02-11T06:59:16.830Z"
       },
       "historyImage": "https://example.com/history_image"
     },
     {
       "userHistory": {
         "id": "15",
         "userId": "1",
         "history": "1984-06-08T00:00:00.000Z",
         "createdAt": "2025-02-10T15:58:32.008Z",
         "updatedAt": "2025-02-10T15:58:32.008Z"
       },
       "historyImage": "https://example.com/history_image"
     },
 */
