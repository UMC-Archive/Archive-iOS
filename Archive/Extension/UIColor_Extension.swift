//
//  UIColor_Extension.swift
//  Archive
//
//  Created by 이수현 on 1/8/25.
//

import UIKit

extension UIColor {
    // Hex 문자열을 UIColor로 변환하는 메서드
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        // Hex 문자열 길이에 따라 RGB 값을 추출
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        // UIColor 초기화
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// Example
// let buttonColor = UIColor(hex: "#314B9E")



extension UIColor {
    static let lightOrange = UIColor(hex: "FFFDF3")
    static let Orange = UIColor(hex: "FFD880")
    static let Black = UIColor(hex: "202020")
    static let Black70 = UIColor(hex: "636363")
    static let Black35 = UIColor(hex: "B3B3B3")
    static let Black20 = UIColor(hex: "BFBFBF")
    static let Black10 = UIColor(hex: "F4F4F4")
    static let LightBlue = UIColor(hex: "E7F1FF")
    static let PositiveBlue = UIColor(hex: "407BD2")
    static let LightRed = UIColor(hex: "FDF5F4")
    static let NegativeRed = UIColor(hex: "ED6863")
//    static let LightOrange = UIColor(hex: "202020")
//    static let Orange = UIColor(hex: "FF8A00")
    static let LightGreen = UIColor(hex: "F4FBD8")
    static let Green = UIColor(hex: "9BC202")
    static let LightPurple = UIColor(hex: "F1E4FF")
    static let Purple = UIColor(hex: "9E48FF")
    
    
}
// Example
// let buttonColor = .lightOrange // Hex: #FFFDF3
// let backgroundColor = UIColor.Orange // Hex: #FFD880
