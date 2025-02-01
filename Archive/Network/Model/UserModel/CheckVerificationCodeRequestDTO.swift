//
//  CheckVerificationCodeRequestDTO.swift
//  Archive
//
//  Created by 손현빈 on 2/1/25.
//

//
//  CheckVerificationCodeRequestDTO.swift
//  Archive
//
//  Created by 이수현 on 1/25/25.
//

import Foundation

public struct CheckVerificationCodeRequestDTO: Encodable {
    let cipherCode: String
    let code: String
}
