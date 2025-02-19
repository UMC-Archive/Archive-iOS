//
//  ProfileAlert.swift
//  Archive
//
//  Created by 송재곤 on 2/18/25.
//

import UIKit


public enum ProfileAlertType: String {
    case nickname = "프로필 변경"
}

class ProfileAlert {
    static let shared = ProfileAlert()
    
    private init() {}
    
    func getAlertController(type: ProfileAlertType) -> UIAlertController{
        let alert = UIAlertController(title: type.rawValue, message: "닉네임을 입력해주세요!!!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(alertAction)
        return alert
    }
}
