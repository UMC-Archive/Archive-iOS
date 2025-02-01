//
//  SignUpRequestDTO.swift
//  Archive
//
//  Created by 손현빈 on 2/1/25.
//

//
//  SignUpRequest.swift
//  Archive
//
//  Created by 이수현 on 1/27/25.
//

import UIKit

public struct SignUpRequestDTO: Encodable {
    let nickname: String
    let email: String
    let password: String
    let status: String
    let socialType: String
    let inactiveDate: String
    let artists: [String]
    let genres: [String]
}
