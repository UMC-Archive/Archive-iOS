//
//  OnBoarding1VC.swift
//  Archive
//
//  Created by 손현빈 on 2/16/25.
//

import UIKit


class OnBoarding1VC : UIViewController {
    let OnBOardingView = UIImageView()
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(OnBOardingView)
        OnBOardingView.image = UIImage(named: "OnBoarding1")
        OnBOardingView.contentMode = .scaleAspectFit
        OnBOardingView.frame=view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        goToNextViewControllerAfterDelay()
    }
   
    private func goToNextViewControllerAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {[weak self] in
            self?.goToNextViewController()
        }
    }

    @objc private func goToNextViewController() {
        let nextVC = UINavigationController(rootViewController: LoginVC())  // 다음 보여줄 뷰컨트롤러로 변경해!
        nextVC.modalPresentationStyle = .fullScreen
               present(nextVC, animated: true, completion: nil)
    }

}
