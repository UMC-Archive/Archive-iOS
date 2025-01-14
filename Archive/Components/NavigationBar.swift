//
//  NavigationBar.swift
//  Archive
//
//  Created by 이수현 on 1/14/25.
//

import UIKit

class NavigationBar: UIView {
    private let title : HeaderTitle
    
    // 타이틀 라벨
    private lazy var titleLabel = UILabel().then { lbl in
        lbl.text = title.rawValue
        lbl.font = .customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    // 뒤로가기 버튼
    public let popButton = UIButton().then { btn in
        btn.setImage(.init(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .white
    }
    
    init(title: HeaderTitle) {
        self.title = title
        
        super.init(frame: .zero)
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            titleLabel,
            popButton
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        // 타이틀 라벨
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(popButton.snp.trailing).offset(20)
            make.centerY.trailing.equalToSuperview()
        }
        
        
        // 뒤로 가기 버튼
        popButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(20)
        }
    }
}
