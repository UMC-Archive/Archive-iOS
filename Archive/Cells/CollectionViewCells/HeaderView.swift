//
//  HeaderCell.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class HeaderView: UICollectionViewCell {
    static let id = "HeaderView"
    
    // 헤더 타이틀
    private lazy var titleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        lbl.textColor = .white
    }
    
    // 디테일 버튼
    public lazy var detailButton = UIButton().then { btn in
        btn.setImage(.init(systemName: "chevron.right"), for: .normal)
        btn.tintColor = .white
//        btn.isHidden = self.headerTitle == .Banner // 홈일 때는 숨기기
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            titleLabel,
            detailButton
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
        
        detailButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(8)
            make.width.equalTo(12)
            make.height.equalTo(20)
        }
    }
    
    public func config(headerTitle: HeaderTitle) {
        titleLabel.text = headerTitle.rawValue
        
        // 배너일 경우 디테일 버튼 히든 처리
        switch headerTitle {
        case .Archive:
            detailButton.isHidden = true
        default:
            detailButton.isHidden = false
        }
    }
}
