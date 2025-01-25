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
