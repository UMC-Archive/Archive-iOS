//
//  CircleCell.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import UIKit

class CircleCell: UICollectionViewCell {
    static let id = "CircleCell"
    
    // 이미지 뷰
    private let imageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFill
//        view.layer.cornerRadius = 105 / 2
        view.clipsToBounds = true
    }
    
    // 아티스트 이름
    private let artistLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 700)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        artistLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    private func setSubView() {
        [
            imageView,
            artistLabel
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    public func config(data: SimilarArtistModel){
        imageView.kf.setImage(with: URL(string: data.imageURL))
        artistLabel.text = data.artist

    }
}
