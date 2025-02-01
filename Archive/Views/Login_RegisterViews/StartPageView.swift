//
//  dummy.swift
//  Archive
//
//  Created by 손현빈
//

import Foundation
import UIKit
import SnapKit
import Then

class StartPageView: UIView {
    
    lazy var email = UIButton().then{ make in
        make.setTitle("이메일로 가입하기", for: .normal)
        make.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        make.setTitleColor(UIColor.white, for: .normal)
        make.backgroundColor = UIColor( red: 0, green: 0,blue: 0.6, alpha: 1)
        make.clipsToBounds = true
        make.layer.cornerRadius = 8
    }
    lazy var google = UIButton().then{ make in
        make.setTitle("구글로 가입하기", for: .normal)
        make.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        make.setTitleColor(UIColor.black, for: .normal)
        make.backgroundColor = UIColor( red: 1, green: 1,blue: 1, alpha: 1)
        make.clipsToBounds = true
        make.layer.cornerRadius = 8
    }
    lazy var  apple = UIButton().then{ make in
        make.setTitle("애플로 가입하기", for: .normal)
        make.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        make.setTitleColor(UIColor.black, for: .normal)
        make.backgroundColor = UIColor( red: 1, green: 1,blue: 1, alpha: 1)
        make.clipsToBounds = true
        make.layer.cornerRadius = 8
    }
    lazy var kakao = UIButton().then{ make in
        make.setTitle("카카오로 가입하기", for: .normal)
        make.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        make.setTitleColor(UIColor.black, for: .normal)
        make.backgroundColor = UIColor( red: 1, green: 1,blue: 1, alpha: 1)
        make.clipsToBounds = true
        make.layer.cornerRadius = 8
    }
    lazy var login = UILabel().then {make in
        make.textColor = .black
        make.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    lazy var Title = UILabel().then {make in
        make.font = UIFont.boldSystemFont(ofSize: 20)
        make.textColor = .black
        make.text = "특별한 순간을 위한 음악 아카이브"
    }
    lazy var AppIcon: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "AppIcon")
         imageView.layer.cornerRadius = 40
         imageView.clipsToBounds = true
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()
    lazy var bottomStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [email,google,apple,kakao])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var TopStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [Title, AppIcon] )
        stackView.axis = .vertical
        stackView.alignment = .center // 요소를 중앙 정렬
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        }()
    
    lazy var mainStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews:[TopStackView, bottomStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
      override init(frame: CGRect) {
             super.init(frame: frame)
          self.backgroundColor = .white
          setupViews()
          setupConstraints()
          
          
         }
    private func setupViews() {
          self.addSubview(mainStackView)
      }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
                 mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                 mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                 mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20) ,// 아래쪽 제약 추가
         
            AppIcon.widthAnchor.constraint(equalToConstant: 80),
            AppIcon.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    required init?(coder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
           }
}


