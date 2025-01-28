//
//  On_Boarding9View.swift
//  Archive
//
//  Created by 손현빈 on 1/11/25.
//


import UIKit
import Foundation

class ProfileSelectView : UIView {
    
    
    lazy var Description : UILabel = {
        let label = UILabel()
        label.text = "사용자 프로필을 설정해주세요"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    lazy var profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var profileNmae : UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 28)
        textfield.textColor = .black
        textfield.textAlignment = .center
        textfield.placeholder = "이름을 입력하시오"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    lazy var penImage : UIImageView = {
        let imageView = UIImageView()
         imageView.image = UIImage(named: "pen") // "pen.jpg"가 Assets에 있는 경우, 확장자는 생략 가능
         imageView.contentMode = .scaleAspectFit // 이미지 비율 유지하며 크기 조정
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
    }()
    
    lazy var completButton : UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = (UIColor.white)
        
        return button
    }()
    
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
