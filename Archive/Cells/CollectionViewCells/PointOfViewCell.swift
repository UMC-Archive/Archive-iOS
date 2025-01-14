//
//  PointOfViewCell.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class PointOfViewCell: UICollectionViewCell {
    static let id = "PointOfViewCell"
    
    // 앨범 이미지
    private let albumImageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.alpha = 0.3 // 투명도
    }
    
    // 타이틀
    private let titleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 12, rawValue: 590)
        lbl.textColor = .white
        lbl.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBorder()
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumImageView.image = nil
        titleLabel.text = ""
    }
    
    private func setBorder() {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
    
    private func setSubView() {
        [
            albumImageView,
            titleLabel
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        albumImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func config(data: PointOfViewDummyModel) {
        albumImageView.kf.setImage(with: URL(string: data.albumURL))
        titleLabel.text = "\(data.year) \(data.month) \(data.week)"
    }
}
