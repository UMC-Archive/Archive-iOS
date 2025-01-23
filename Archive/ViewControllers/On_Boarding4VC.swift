//
//  On_Boarding4VC.swift
//  Archive
//
//  Created by 손현빈 on 1/11/25.
//

import UIKit
import Foundation

class On_Boarding4VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            datePicker.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    // @objc 메서드는 viewDidLoad 외부로 이동
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        print("Selected Date: \(formatter.string(from: sender.date))")
    }
}
