//
//  TopView.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

// 각 뷰의 상단 바 타입
enum TopViewType: String{
    case home = "홈"
    case library = "보관함"
    case explore = "탐색"
    case myPage = "마이페이지"
}


// 홈, 보관함, 탐색 등 공통으로 쓰이는 상단 뷰 (타이틀, 검색, 마이페이지 뷰)
class TopView: UIView {
    private let type: TopViewType
    
    // 타이틀 (홈, 마이페이지, 탐색 등)
    private lazy var titleLabel = UILabel().then { lbl in
        lbl.text = self.type.rawValue // enum 타입의 String 값으로 타이틀 설정
        lbl.font = UIFont.customFont(font: .SFPro, ofSize: 28, rawValue: 700)
        lbl.textColor = .white
    }
    
    // 마이페이지 버튼
    public let myPageIconButton = UIButton().then { btn in
        btn.setImage(.myPageIcon, for: .normal)
    }
    
    // 탐색 버튼
    public let exploreIconButton = UIButton().then { btn in
        btn.setImage(.exploreIcon, for: .normal)
    }
    
    // 검색 버튼
    public let searchIconButton = UIButton().then { btn in
        btn.setImage(.searchIcon, for: .normal)
    }
    
    
    init(type: TopViewType) {
        self.type = type
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        
        setSubView()
        setUI()
        setIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            titleLabel,
            exploreIconButton,
            searchIconButton,
            myPageIconButton,
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        // 타이틀
        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.trailing.equalTo(exploreIconButton.snp.leading)
        }
        
        // 마이페이지
        myPageIconButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        // 검색
        searchIconButton.snp.makeConstraints { make in
            make.trailing.equalTo(myPageIconButton.snp.leading).offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(21.24)
        }
        
        // 탐색
        exploreIconButton.snp.makeConstraints { make in
            make.trailing.equalTo(searchIconButton.snp.leading).offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
    }
    
    // 각 화면에 따라 아이콘 유무 설정
    private func setIcon() {
        switch type {
        case .home:
            self.myPageIconButton.isHidden = false  // 프로필 아이콘
            self.exploreIconButton.isHidden = false // 탐색 아이콘
            self.searchIconButton.isHidden = false  // 검색 아이콘
        case .library:
            self.myPageIconButton.isHidden = false  // 프로필 아이콘
            self.exploreIconButton.isHidden = false // 탐색 아이콘
            self.searchIconButton.isHidden = false  // 검색 아이콘
        case .explore:
            self.myPageIconButton.isHidden = false  // 프로필 아이콘
            self.exploreIconButton.isHidden = true // 탐색 아이콘
            self.searchIconButton.isHidden = false  // 검색 아이콘
        case .myPage:
            self.myPageIconButton.isHidden = false  // 프로필 아이콘
            self.exploreIconButton.isHidden = false // 탐색 아이콘
            self.searchIconButton.isHidden = false  // 검색 아이콘
        }
    }
}


