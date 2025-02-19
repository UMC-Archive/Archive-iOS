//
//  OnBoarding3VC.swift
//  Archive
//
//  Created by 손현빈 on 2/16/25.
//

//
//  OnBoarding2VC.swift
//  Archive
//
//  Created by 손현빈 on 2/16/25.
//

import UIKit


class OnBoarding3VC : UIViewController {
    let OnBOardingView = UIImageView()
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(OnBOardingView)
        OnBOardingView.image = UIImage(named: "OnBoarding3")
        OnBOardingView.contentMode = .scaleAspectFit
        OnBOardingView.frame=view.bounds
        setupTapGesture()
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToNextViewController))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func goToNextViewController() {
        let nextVC = OnBoarding4VC() // 다음 보여줄 뷰컨트롤러로 변경해!
        navigationController?.pushViewController(nextVC, animated: true)

    }
}

