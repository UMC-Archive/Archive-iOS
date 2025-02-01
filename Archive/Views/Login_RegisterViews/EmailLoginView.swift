
//
//  EmailLoginView.swift
//  Archive
//
//  Created by 손현빈 on 1/11/25.
//
import Foundation
import UIKit
import Then
class EmailLoginView : UIView {
    
  
    
    lazy var AppImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var PWField = UITextField().then{make in
        
    }
    
    lazy var Login = UIButton().then {make in
        
        make.setTitle("로그인", for: .normal)
        make.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        make.setTitleColor(UIColor.white, for: .normal)
        make.backgroundColor = UIColor( red: 0, green: 0,blue: 0.6, alpha: 1)
        make.clipsToBounds = true
        make.layer.cornerRadius = 8
    }
    
    
    lazy var ID = UILabel().then {make in
        make.textColor = .black
        make.text = "아이디 찾기"
        make.font = UIFont.systemFont(ofSize: 12)
        
    }
    lazy var PW = UILabel().then {make in
        make.textColor = .black
        make.text = "비밀번호 찾기"
        make.font = UIFont.systemFont(ofSize: 12)
        
    }
    
    lazy var register = UILabel().then {make in
        make.textColor = .black
        make.text = "회원가입"
        make.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var google = UIButton().then{ make in
        make.setTitle("구글로 로그인", for: .normal)
        make.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        make.setTitleColor(UIColor.black, for: .normal)
        make.backgroundColor = UIColor( red: 1, green: 1,blue: 1, alpha: 1)
        make.clipsToBounds = true
        make.layer.cornerRadius = 8
    }
    
    lazy var  apple = UIButton().then{ make in
        make.setTitle("애플로 로그인", for: .normal)
        make.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        make.setTitleColor(UIColor.black, for: .normal)
        make.backgroundColor = UIColor( red: 1, green: 1,blue: 1, alpha: 1)
        make.clipsToBounds = true
        make.layer.cornerRadius = 8
    }
    
    lazy var kakao = UIButton().then{ make in
        make.setTitle("카카오로 로그인", for: .normal)
        make.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        make.setTitleColor(UIColor.black, for: .normal)
        make.backgroundColor = UIColor( red: 1, green: 1,blue: 1, alpha: 1)
        make.clipsToBounds = true
        make.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        
       }
    
    private func setupViews(){
        
    }
    private func setupConstraints(){
        
        
    }
    required init?(coder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
           }
}

