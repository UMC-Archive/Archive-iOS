//
//  String_Extension.swift
//  Archive
//
//  Created by 이수현 on 2/1/25.
//

import Foundation

extension String {
    func prefixBeforeDash() -> String {
        return self.components(separatedBy: "-").first ?? ""
    }
}
