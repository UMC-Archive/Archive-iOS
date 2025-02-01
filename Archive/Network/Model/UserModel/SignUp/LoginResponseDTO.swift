//
//  LoginResponseDTO.swift
//  Archive
//
//  Created by 손현빈 on 2/1/25.
//

import UIKit

public struct LoginResponseDTO:  Decodable{
    let isSuccess : Bool
    let code: String
     let message: String
    let result : String
    
}

