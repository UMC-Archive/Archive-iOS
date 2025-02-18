//
//  ProfileChangeResponseDTO.swift
//  Archive
//
//  Created by 송재곤 on 2/14/25.
//

import Foundation

public struct ProfileChangeResponseDTO: Decodable {
    let id: String
    let nickname: String
    let email: String
    let password: String
    let profileImage: String
    let status: String
    let socialType: String
    let inactiveDate: String
    let createdAt: String
    let updatedAt: String
}

