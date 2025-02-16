//
//  LibraryAlert.swift
//  Archive
//
//  Created by 이수현 on 2/16/25.
//

import UIKit


public enum LibraryAlertType: String {
    case artist = "아티스트"
    case music = "음악"
    case album = "앨범"
}

class LibraryAlert {
    static let shared = LibraryAlert()
    
    private init() {}
    
    func getAlertController(type: LibraryAlertType) -> UIAlertController{
        let alert = UIAlertController(title: type.rawValue, message: "보관함에 추가되었습니다.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(alertAction)
        return alert
    }
}
