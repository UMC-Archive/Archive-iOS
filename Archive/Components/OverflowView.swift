//
//  OverflowView.swift
//  Archive
//
//  Created by 이수현 on 2/7/25.
//

import UIKit

enum OverflowType {
    case inLibrary // 보관함에서 눌렀을 때 (앨범으로 이동, 보관함에서 삭제_
    case inAlbum   // 앨범에서 눌렀을 때 (보관함에 추가)
    case other     // 나머지 뷰 (앨범으로 이동, 보관함에 추가)
}

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
    
    public func setType(type: OverflowType){
        goToAlbumButton.isHidden = type == .inAlbum ? true : false
        seperatorLine.isHidden = type == .inAlbum ? true : false
        libraryButton.setTitle(type == .inLibrary ? "보관함에서 제거" : "보관함에 추가", for: .normal)
        
        switch type {
        case .inAlbum:
            libraryButton.snp.remakeConstraints { make in
                make.horizontalEdges.centerY.equalToSuperview()
                
            }
        default:
            return
        }
    }
}
