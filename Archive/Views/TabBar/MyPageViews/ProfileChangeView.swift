//
//  ProfileChangeView.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class ProfileChangeView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    private let view = UIView().then{
        $0.backgroundColor = UIColor.black_100
    }
    public let navigationView = NavigationBar(title: .profile)
    public let profileImage = UIImageView().then{
        $0.image = UIImage(named: "profileSample")
    }
    public let profileChange = UIImageView().then{
        $0.image = UIImage(named: "edit_back")
    }
    private let nickLabel = UILabel().then{
        $0.text = "닉네임"
        $0.textColor = .white
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 16, rawValue: 700)
    }
    private let nicknameLabel = UILabel().then{
        $0.text = "혀콩"
        $0.textColor = .white
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 14, rawValue: 400)
    }
    private let divideLine = UIView().then{
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 0.5
    }
    public let button = UIButton().then{
        $0.setTitle("저장하기", for: .normal)
        $0.backgroundColor = UIColor.black_20
        $0.layer.cornerRadius = 10
    }
    func setConstraint(){
        [
            view,
            navigationView,
            profileImage,
            profileChange,
            nickLabel,
            nicknameLabel,
            divideLine,
            button
            
        ].forEach{
            addSubview($0)
        }
        view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        navigationView.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(19)
            $0.height.equalTo(30)
        }
        profileImage.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(99)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 120, height: 120))
        }
        profileChange.snp.makeConstraints{
            $0.top.equalTo(profileImage.snp.top).offset(89)
            $0.leading.equalTo(profileImage.snp.leading).offset(97.75)
            $0.size.equalTo(CGSize(width: 31, height: 31))
        }
        nickLabel.snp.makeConstraints{
            $0.top.equalTo(profileImage.snp.bottom).offset(70)
            $0.size.equalTo(CGSize(width: 43, height: 19))
            $0.leading.equalToSuperview().offset(31)
        }
        nicknameLabel.snp.makeConstraints{
            $0.centerY.equalTo(nickLabel.snp.centerY)
            $0.size.equalTo(CGSize(width: 26, height: 17))
            $0.leading.equalTo(nickLabel.snp.trailing).offset(62)
        }
        divideLine.snp.makeConstraints{
            $0.top.equalTo(nickLabel.snp.bottom).offset(8.5)
            $0.leading.equalToSuperview().offset(22.35)
            $0.width.equalTo(330)
            $0.height.equalTo(1)
        }
        button.snp.makeConstraints{
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-46)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 335, height: 50))
        }
    }
}
