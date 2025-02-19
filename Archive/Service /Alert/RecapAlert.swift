//
//  RecapAlert.swift
//  Archive
//
//  Created by 송재곤 on 2/19/25.
//

import UIKit

public enum RecapAlertType: String {
    case recap = "recap"
}

class RecapAlert {
    static let shared = RecapAlert()
    
    private init() {}
    
    func getAlertController(type:  RecapAlertType) -> UIAlertController{
        let alert = UIAlertController(title: type.rawValue, message: "recap 정보 수집이 진행중입니다.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(alertAction)
        return alert
    }
}
