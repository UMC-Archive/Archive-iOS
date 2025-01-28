//
//  On_Boarding8View.swift
//  Archive
//
//  Created by 손현빈 on 1/11/25.
//


import UIKit
import Foundation
import Then
class On_Boarding8View : UIView {
    
    
    lazy var Description = UILabel().then { make in
            make.textColor = .black
            make.text = "안녕하세요'\n' 당신의 특별한 음악을 '\n' 아카이빙하는 Archieve입니다 "
            make.font = UIFont.systemFont(ofSize: 24)
       
    }
   
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        
       }
    
    private func setupViews (){
        
        
    }
    private func setupConstraints(){
        
        
    }
    required init?(coder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
           }
}
