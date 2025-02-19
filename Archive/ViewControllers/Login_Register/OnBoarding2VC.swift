//
//  OnBoarding2VC.swift
//  Archive
//
//  Created by 손현빈 on 2/16/25.
//

import UIKit


class OnBoarding2VC : UIViewController {
    let OnBOardingView = UIImageView()
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(OnBOardingView)
        OnBOardingView.image = UIImage(named: "OnBoarding2")
        OnBOardingView.contentMode = .scaleAspectFit
        OnBOardingView.frame=view.bounds
        self.navigationController?.navigationBar.isHidden = true
        setupTapGesture()
    }
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToNextViewController))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func goToNextViewController() {
        let nextVC = OnBoarding3VC() // 다음 보여줄 뷰컨트롤러로 변경해!
        navigationController?.pushViewController(nextVC, animated: true)

    }

}

