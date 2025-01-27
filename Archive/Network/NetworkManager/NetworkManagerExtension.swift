//
//  NetworkManagerExtension.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import Moya
import Foundation

extension NetworkManager {
    // ✅ 1. 필수 데이터 요청
    func request<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            do {
                print(try result.get().request?.url?.absoluteString ?? "")
            } catch {
                print("error")
            }
            switch result {
            case .success(let response):
                print(response.statusCode)
                let result: Result<T, NetworkError> = self.handleResponse(response, decodingType: decodingType)
                completion(result)
            case .failure(let error):
                let networkError = self.handleNetworkError(error)
                completion(.failure(networkError))
            }
        }
    }
    
    // ✅ 2. 옵셔널 데이터 요청
    func requestOptional<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            do {
                print(try result.get().request?.url?.absoluteString ?? "")
            } catch {
                print("error")
            }
            switch result {
            case .success(let response):
                let result: Result<T?, NetworkError> = self.handleResponseOptional(response, decodingType: decodingType)
                completion(result)
            case .failure(let error):
                let networkError = self.handleNetworkError(error)
                completion(.failure(networkError))
            }
        }
    }
    
    // ✅ 3. 상태 코드만 확인
    func requestStatusCode(
        target: Endpoint,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                let result: Result<ApiResponse<String?>?, NetworkError> = self.handleResponseOptional(
                    response,
                    decodingType: ApiResponse<String?>.self
                )
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                let networkError = self.handleNetworkError(error)
                completion(.failure(networkError))
            }
        }
    }
    
    // MARK: - 상태 코드 처리 처리 함수
    private func handleResponse<T: Decodable>(
        _ response: Response,
        decodingType: T.Type
    ) -> Result<T, NetworkError> { // ✅ 옵셔널 미지원
        do {
            // 1. 상태 코드 확인
            guard (200...299).contains(response.statusCode) else {
                // 서버 통신에 실패한 경우
                let errorMessage: String
                switch response.statusCode {
                case 300..<400:
                    errorMessage = "리다이렉션 오류 발생: \(response.statusCode)"
                case 400..<500:
                    errorMessage = "클라이언트 오류 발생: \(response.statusCode)"
                case 500..<600:
                    errorMessage = "서버 오류 발생: \(response.statusCode)"
                default:
                    errorMessage = "알 수 없는 오류 발생: \(response.statusCode)"
                }

                // 2. 서버 응답 메시지 처리
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data)
                let finalMessage = errorResponse?.message ?? errorMessage
                return .failure(.networkError(message: finalMessage))
            }

            // 3. 응답 디코딩
            let apiResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
            
            // 3.5 Response 코드 확인
            guard apiResponse.code == "200" else {
                return .failure(.serverError(apiResponse.message))
            }

            // 4. result 처리 (빈 데이터 불허)
            guard let result = apiResponse.result else {
                return .failure(.dataNil)
            }

            return .success(result) // ✅ 반드시 데이터가 필요함

        } catch {
            return .failure(.failToDecode(response.description)) // 디코딩 실패
        }
    }
    
    private func handleResponseOptional<T: Decodable>(
        _ response: Response,
        decodingType: T.Type
    ) -> Result<T?, NetworkError> { // ✅ 옵셔널 지원
        do {
            // 1. 상태 코드 확인
            guard (200...299).contains(response.statusCode) else {
                let errorMessage: String
                switch response.statusCode {
                case 300..<400:
                    errorMessage = "리다이렉션 오류가 발생했습니다. 코드: \(response.statusCode)"
                case 400..<500:
                    errorMessage = "클라이언트 오류가 발생했습니다. 코드: \(response.statusCode)"
                case 500..<600:
                    errorMessage = "서버 오류가 발생했습니다. 코드: \(response.statusCode)"
                default:
                    errorMessage = "알 수 없는 오류가 발생했습니다. 코드: \(response.statusCode)"
                }

                // 서버 응답 메시지 디코딩
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data)
                let finalMessage = errorResponse?.message ?? errorMessage
                return .failure(.networkError(message: finalMessage))
            }

            // 2. 빈 데이터 처리
            if response.data.isEmpty {
                return .success(nil) // ✅ 빈 데이터 처리 (옵셔널 허용)
            }

            // 3. 응답 디코딩
            let apiResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
            
            // 3.5 Response 코드 확인
            guard apiResponse.code == "200" else {
                return .failure(.serverError(apiResponse.message))
            }

            // 4. result 처리
            return .success(apiResponse.result) // ✅ result가 옵셔널이라면 nil 반환 가능

        } catch {
            return .failure(.failToDecode(response.description)) // 디코딩 에러 처리
        }
    }
    
    // MARK: - 네트워크 오류 처리 함수
    func handleNetworkError(_ error: Error) -> NetworkError {
        let nsError = error as NSError
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            return .networkError(message: "인터넷 연결이 끊겼습니다.")
        case NSURLErrorTimedOut:
            return .networkError(message: "요청 시간이 초과되었습니다.")
        default:
            return .networkError(message: "네트워크 오류가 발생했습니다.")
        }
    }
}

