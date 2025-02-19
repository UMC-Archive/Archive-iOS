//
//  ProfileChangePostRequestDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/14/25.
//

public struct ProfileChangePostRequestDTO: Encodable {
    let nickname: String
    
    init(nickname: String) {
            self.nickname = nickname
        }
}
