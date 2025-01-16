//
//  StartPageVC.swift
//  Archive
//
//  Created by 손현빈 on 1/11/25.
//

import UIKit
class StartPageVC : UIViewController {
    override func viewDidLoad() {
           super.viewDidLoad()
       
            let startPageView = StartPageView(frame: self.view.bounds) // StartPageView의 초기화
       
          self.view.addSubview(startPageView) // StartPageVC의 view에 추가
        
        // 액션 추가
        startPageView.email.addTarget(self, action: #selector(handleEmailSignup), for: .touchUpInside)
         
       }
    
    @objc private func handleEmailSignup() {
          // Spotify 로그인 시작
          SpotifyAuthManager.shared.startAuthentication(from: self)
      }
    
}
