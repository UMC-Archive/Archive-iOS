//
//  LibraryMainView.swift
//  Archive
//
//  Created by 송재곤 on 1/9/25.
//

import UIKit
import SnapKit
import Then

class LibraryMainView : UIView {
    
    private lazy var normalUnderbar = UIView().then{
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
    public lazy var selectedUnderbar = UIView().then{
        $0.backgroundColor = UIColor.white
    }
      

    //상단 세그먼트
    public let librarySegmentControl = UISegmentedControl(items: ["재생목록", "노래", "앨범", "장르", "아티스트"]).then{
        
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
               
        $0.selectedSegmentIndex = 0
        
        //기본 상태의 색 설정
        $0.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7), .font: UIFont.customFont(font: .SFPro, ofSize: 14, rawValue: 400),
            ],
            for: .normal)
        //눌린 상태의 색 설정
        $0.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.customFont(font: .SFPro, ofSize: 14, rawValue: 400),
            ],
            for: .selected)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setComponent(){
        
        //subview에 추가
        [
            librarySegmentControl,
            normalUnderbar,
            selectedUnderbar
        ].forEach{
            addSubview($0)
        }
        
        librarySegmentControl.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(20)
        }
        normalUnderbar.snp.makeConstraints{
            $0.top.equalTo(librarySegmentControl.snp.bottom).offset(7)
            $0.leading.equalTo(librarySegmentControl.snp.leading)
            $0.width.equalTo(librarySegmentControl.snp.width)
            $0.height.equalTo(0.5)
        }
        selectedUnderbar.snp.makeConstraints{
            $0.bottom.equalTo(normalUnderbar.snp.bottom)
            $0.leading.equalTo(librarySegmentControl.snp.leading)
            $0.width.equalTo(67)
            $0.height.equalTo(1)
        }
        
    }
}
