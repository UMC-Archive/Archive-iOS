//
//  NetworkManager.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Foundation
import Moya

protocol NetworkManager {
    associatedtype Endpoint: TargetType // 범용 타입 설정 (제네릭 타입과 같음)
    
    var provider: MoyaProvider<Endpoint> { get }
    
    // ✅ 1. 일반 데이터 요청 (T, 필수값)
    func request<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    // ✅ 2. 일반 데이터 요청 (T?, 옵셔널)
    func requestOptional<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    )
    
    // ✅ 3. 상태 코드만 확인
    func requestStatusCode(
        target: Endpoint,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    )
}
