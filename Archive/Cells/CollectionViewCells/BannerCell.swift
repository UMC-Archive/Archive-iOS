//
//  BannerCell.swift
//  Archive
//
//  Created by 이수현 on 1/14/25.
//

import UIKit

class BannerCell: UICollectionViewCell {
    static let id = "BannerCell"
    
    // 앨범 이미지 뷰
    public let imageView = AlbumImageView()
    
    // Album & SongTitle
    private let titleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    public let artistLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white_70
        lbl.numberOfLines = 1
        lbl.isUserInteractionEnabled = true
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
        titleLabel.text = ""
        artistLabel.text = ""
        self.gestureRecognizers = nil
    }
    
    private func setSubView() {
        [
            imageView,
            titleLabel,
            artistLabel
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI(){
        // 이미지 뷰
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        // 타이틀
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(3)
        }
        
        // 아티스트
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview().inset(3)
        }
    }
    
    public func configMusic(data: MusicDummyModel){
        imageView.kf.setImage(with: URL(string: data.albumURL))
        titleLabel.text = data.musicTitle
        artistLabel.text = data.artist
    }
    
    public func configAlbum(data: AlbumDummyModel) {
        imageView.kf.setImage(with: URL(string: data.albumImageURL))
        titleLabel.text = data.albumTitle
        artistLabel.text = data.artist
    }
}
