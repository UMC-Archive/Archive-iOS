//
//  HomeView.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class HomeView: UIView {
    private let topView = TopView(type: .home)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            topView
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(33)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
