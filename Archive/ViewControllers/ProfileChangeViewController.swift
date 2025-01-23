//
//  ProfileChangeViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class ProfileChangeViewController : UIViewController {
    let rootView = ProfileChangeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = rootView
        
        controlTapped()
    }
    private func controlTapped(){
        rootView.navigationView.popButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
    }
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
        print("1")
    }
}
