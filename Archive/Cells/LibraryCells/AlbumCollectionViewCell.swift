//
//  AlbumCollectionViewCell.swift
//  Archive
//
//  Created by 송재곤 on 1/11/25.
//

import UIKit
import Then
import SnapKit

class AlbumCollectionViewCell: UICollectionViewCell {
    static let albumCollectionViewIdentifier = "albumCollectionViewIdentifier"
    
    private enum constant {
        static let albumImageSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 160, height: 160) : CGSize(width: 160, height: 160)
        static let albumLabelStackViewSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 101, height: 39) : CGSize(width: 101, height: 39)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let albumImage = UIImageView().then{
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    //터치 제스처를 위한 뷰
    public let touchView = UIView()
    
    public let albumNameLabel = UILabel().then{
        $0.text = "Album Name"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        $0.textColor = .white
    }
    
    public let artistLabel = UILabel().then{
        $0.text = "Artist"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        $0.textColor = .white.withAlphaComponent(0.7)
    }

    
    private func setComponent(){
        [
            albumImage,
            albumNameLabel,
            touchView,
            artistLabel,
    
        ].forEach{
            addSubview($0)
        }
        
        albumImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(constant.albumImageSize)
        }
        
        touchView.snp.makeConstraints{
            $0.leading.equalTo(albumImage.snp.leading)
            $0.trailing.equalTo(albumImage.snp.trailing)
            $0.height.equalToSuperview()
        }
        albumNameLabel.snp.makeConstraints{
            $0.top.equalTo(albumImage.snp.bottom).offset(6)
            $0.leading.equalTo(albumImage.snp.leading)
            $0.trailing.equalTo(albumImage.snp.trailing).offset(-10)
        }
        artistLabel.snp.makeConstraints{
            $0.top.equalTo(albumNameLabel.snp.bottom)
            $0.leading.equalTo(albumImage.snp.leading)
        }


    }
    
    public func config(image: String, albumName: String, artist: String){
        let imageUrl = URL(string: image)
        albumImage.kf.setImage(with: imageUrl)
        albumNameLabel.text = albumName
        artistLabel.text = artist
    }
}
