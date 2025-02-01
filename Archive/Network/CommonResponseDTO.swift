//
//  CommonRequestDTO.swift
//  Archive
//
//  Created by 손현빈 on 2/1/25.
//

//
//  CommonResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 1/20/25.
//

import Foundation

// 최상위 응답 모델
public struct ApiResponse<T: Decodable>: Decodable {
    public let isSuccess: Bool
    public let code: String
    public let message: String
    public let result: T?
}
