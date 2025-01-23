//
//  DatePickerMonthModel.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

struct DatePickerMonthModel {
    let month: [String]
    
    init(startMonth: Int = 1) {
        self.month = Array(startMonth...12).map { String(format: "%02d", $0) }
    }
}
