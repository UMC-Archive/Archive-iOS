//
//  DatePickerModel.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//
import UIKit

struct DatePickerModel {
    let years: [String]
    
    init(startYear: Int = 1980) {
        let currentYear = Calendar.current.component(.year, from: Date())
        self.years = Array(startYear...currentYear).map { String($0) }
    }
}
