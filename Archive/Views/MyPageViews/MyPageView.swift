////
////  myPageView.swift
////  Archive
////
////  Created by 송재곤 on 1/14/25.
////
//
//import UIKit
//
//class MyPageView: UIView {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setConstraint()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    public var CDView = UIView().then {
//        $0.clipsToBounds = true
//        $0.backgroundColor = .systemGray
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.layer.cornerRadius = 129
//        $0.layer.borderWidth = 3
//        $0.layer.borderColor = UIColor.lightGray.cgColor
//    }
//    public var CDHoleView = UIView().then {
//        $0.clipsToBounds = true
//        $0.backgroundColor = UIColor.black_70
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.layer.cornerRadius = 20
//        $0.layer.borderWidth = 3
//        $0.layer.borderColor = UIColor.lightGray.cgColor
//    }
//    
//    
//    func setConstraint() {
//        addSubview(CDView)
//        addSubview(CDHoleView)
//        
//        CDView.snp.makeConstraints {
//            $0.centerX.centerY.equalToSuperview()
//            $0.height.width.equalTo(258)
//        }
//        CDHoleView.snp.makeConstraints{
//            $0.centerX.centerY.equalToSuperview()
//            $0.height.width.equalTo(40)
//        }
//    }
//    
//    
//}
//
