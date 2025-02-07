//
//  OverflowView.swift
//  Archive
//
//  Created by 이수현 on 2/7/25.
//

import UIKit

class OverflowView: UIView {
    private let groupView = UIView().then { view in
        view.backgroundColor = .black_35
        view.layer.cornerRadius = 4
    }
    public let goToAlbumButton = UIButton().then { btn in
        btn.setTitle("앨범으로 이동", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .customFont(font: .SFPro, ofSize: 12, rawValue: 400)
    }
    
    private let seperatorLine = UIView().then { view in
        view.backgroundColor = .white_35
    }
    
    public let libraryButton = UIButton().then { btn in
        btn.setTitle("보관함에서 제거", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .customFont(font: .SFPro, ofSize: 12, rawValue: 400)
    }
    
    init(){
        super.init(frame: .zero)
        
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView(){
        [
            goToAlbumButton,
            seperatorLine,
            libraryButton
        ].forEach{groupView.addSubview($0)}
        
        self.addSubview(groupView)
    }
    
    
    private func setUI(){
        groupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        goToAlbumButton.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        seperatorLine.snp.makeConstraints { make in
            make.top.equalTo(goToAlbumButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        libraryButton.snp.makeConstraints { make in
            make.top.equalTo(seperatorLine.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(26)
        }
    }
}
