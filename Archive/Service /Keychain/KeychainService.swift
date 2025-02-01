//
//  KeychainService.swift
//  Blism
//
//  Created by 이수현 on 12/20/24.
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()
    
    // 싱들톤 패턴 
    private init() {}
    
    @discardableResult
    func save(account : KeychainAccountType, service : KeychainServiceType, value : String) -> OSStatus {
        guard let valueData = value.data(using: .utf8) else {return errSecParam}
        
        let query : [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account.rawValue,
            kSecAttrService as String : service.rawValue,
            kSecValueData as String : valueData
        ]
        
        SecItemDelete(query as CFDictionary) // 이미 있으면 삭제
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    @discardableResult
    func load(account : KeychainAccountType, service : KeychainServiceType) -> String?{
        
        let query : [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account.rawValue,
            kSecAttrService as String : service.rawValue,
            kSecReturnData as String : true,
            kSecMatchLimit as String : kSecMatchLimitOne // 결과 하나만 리턴
        ]
        
        var item : CFTypeRef?       // CFTypeRef 타입 == AnyObject 타입
        let osStatus = SecItemCopyMatching(query as CFDictionary, &item)
        
        if osStatus == errSecSuccess,
            let data = item as? Data,
            let value = String(data: data, encoding: .utf8) {
            return value
            
        } else {
            return nil
        }
    }
    
    @discardableResult
    func update(account : KeychainAccountType, service : KeychainServiceType, newValue : String) -> OSStatus {
        
        guard let value = newValue.data(using: .utf8) else {return errSecParam}

        let query : [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account.rawValue,
            kSecAttrService as String : service.rawValue,
        ]
        
        
        let attributesToUpdate : [String : Any] = [
            kSecValueData as String : value
        ]
        
        return SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
    }
    
    func delete(account : KeychainAccountType, service : KeychainServiceType) -> OSStatus{
        
        let query : [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account.rawValue,
            kSecAttrService as String : service.rawValue
        ]
        
        return SecItemDelete(query as CFDictionary)
    }
}

/*
 1. Save Example
 1-1. 유저 아이디 저장
 KeychainService.shared.save(account: .userInfo, service: .userId, value: "사용자 아이디 입력")
 
 1-2. 유저 닉네임 저장
 KeychainService.shared.save(account: .userInfo, service: .nickname, value: "사용자 아이디 입력")
 
 2. Load Example
 2-1. 유저 아이디 불러오기
 KeychainService.shared.load(account: .userInfo, service: .userId)
 
 2-2. 유저 닉네임 불러오기
 KeychainService.shared.load(account: .userInfo, service: .nickname)
 
 
 3. delete Example
 3-1. 유저 아이디 삭제
 KeychainService.shared.delete(account: .userInfo, service: .userId)
 
 3-2. 유저 닉네임 삭제
 KeychainService.shared.delete(account: .userInfo, service: .nickname)
 
 4. update Example
 4-1. 유저 아이디 업데이트
 KeychainService.shared.update(account: .userInfo, service: .userId, newValue: "New ID")
 
 4-2. 유저 닉네임 업데이트
 KeychainService.shared.update(account: .userInfo, service: .nickname, newValue: "New Nickname")
 
 */





