//
//  String_Extension.swift
//  Archive
//
//  Created by 이수현 on 2/1/25.
//

import Foundation

extension String {
    // 2025-02-01T05:35:02 -> 2025만 출력
    func prefixBeforeDash() -> String {
        return self.components(separatedBy: "-").first ?? ""
    }
}
