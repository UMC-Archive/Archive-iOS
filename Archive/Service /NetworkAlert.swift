//
//  NetworkAlert.swift
//  Archive
//
//  Created by 이수현 on 1/23/25.
//

import UIKit

class NetworkAlert {
    static let shared = NetworkAlert()
    
    private init() {}
    
    func getAlertController(title: String) -> UIAlertController{
        let alert = UIAlertController(title: "네트워크 오류", message: title, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(alertAction)
        return alert
    }
}
