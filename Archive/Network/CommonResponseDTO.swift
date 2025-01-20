//
//  CommonResponseDTO.swift
//  Archive
//
//  Created by 이수현 on 1/20/25.
//

import Foundation

// 최상위 응답 모델
public struct ApiResponse<T: Codable>: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    public let result: T?
}
