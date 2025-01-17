////
////  MyPageViewController.swift
////  Archive
////
////  Created by 송재곤 on 1/14/25.
////
//
//import UIKit
//
//class MyPageViewController: UIViewController {
//    
//    let rootView = MyPageView()
//    let gradient = CAGradientLayer()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        self.view = rootView
//        
//        buildGradient()
//    }
//    
//    override func viewDidLayoutSubviews() {
//           super.viewDidLayoutSubviews()
//           // rootView의 크기가 업데이트된 후 gradient의 프레임을 설정
//        gradient.frame = rootView.CDView.bounds
//       }
//    
//    func buildGradient() {
//        
//        gradient.type = .conic
//        gradient.colors = [
//            UIColor.dance_100?.cgColor,
//            UIColor.hiphop_100?.cgColor,
//            UIColor.RnB_100?.cgColor,
//            UIColor.dance_100?.cgColor
//        ]
//        gradient.locations = [0.0, 0.17, 0.5, 0.84, 1.0]
//        gradient.startPoint = CGPoint(x: 0.5, y: 0.5) // 중심점
//        gradient.endPoint = CGPoint(x: 01.0, y: 1.0)   // conic 그라데이션은 중심을 공유
//        
//        
//        rootView.CDView.layer.addSublayer(gradient)
//    }
//}
