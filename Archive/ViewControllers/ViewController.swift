//
//  ViewController.swift
//  Archive
//
//  Created by 이수현 on 1/7/25.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let semiBold = UILabel().then { lbl in
            lbl.text = "This is Semi Bold Font"
            lbl.font = .customFont(font: .SFPro, ofSize: 14, rawValue: 590)
        }
        
        let light = UILabel().then { lbl in
            lbl.text = "This is light Font"
            lbl.font = .customFont(font: .SFPro, ofSize: 14, rawValue: 274)
        }
        
        view.addSubview(semiBold)
        view.addSubview(light)
        
        semiBold.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        light.snp.makeConstraints { make in
            make.top.equalTo(semiBold.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        

        view.backgroundColor = .white
    }
}

