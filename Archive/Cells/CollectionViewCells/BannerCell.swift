//
//  BannerCell.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit
import Kingfisher

class BannerCell: UICollectionViewCell {
    static let id = "BannerCell"
    private let imageWidth = 185.0
    
    // 앨범 이미지
    private lazy var albumImageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = imageWidth / 2
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(hex: "929292")?.withAlphaComponent(0.5).cgColor
    }
    
    private let infoGroupView = UIView()
    
    // 앨범 타이틀
    private let albumTitleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        lbl.textColor = .white
    }
    
    // 앨범 서브 타이틀
    private let albumSubTitleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        lbl.textColor = .white
    }
    
    // 아티스트
    private let artistLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white_70
    }
    
    // 년도
    private let yearLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 12, rawValue: 400)
        lbl.textAlignment = .left
        lbl.textColor = .white_70
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setBorder()
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBorder() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setSubView() {
        
        [
            albumTitleLabel,
            albumSubTitleLabel,
            artistLabel,
            yearLabel
        ].forEach{infoGroupView.addSubview($0)}
        
        [
            albumImageView,
            infoGroupView
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        // 앨범 이미지
        albumImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageWidth)
            make.top.equalToSuperview().inset(10.5)
            make.trailing.equalToSuperview().inset(11)
        }
        
        // 정보 그룹
        infoGroupView.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(8)
        }
        
        // 앨범 타이틀
        albumTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        // 앨범 서브 타이틀
        albumSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumTitleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        // 아티스트
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(albumSubTitleLabel.snp.bottom).offset(2)
            make.leading.bottom.equalToSuperview()
        }
        
        // 년도
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(artistLabel)
            make.bottom.trailing.equalToSuperview()
            make.leading.equalTo(artistLabel.snp.trailing).offset(4)
        }
    }
    
    
    public func config(album: MusicDummyModel) {
        albumImageView.kf.setImage(with: URL(string: album.albumURL))
        albumTitleLabel.text = album.albumTitle
        albumSubTitleLabel.text = album.albumSubTitle
        artistLabel.text = album.artist
        yearLabel.text = "⦁ \(album.year)"
    }
}
