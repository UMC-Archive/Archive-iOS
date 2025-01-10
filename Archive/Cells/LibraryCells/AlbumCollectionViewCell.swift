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
        static let albumLabelStackViewSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 160, height: 40) : CGSize(width: 101, height: 39)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let albumImage = UIImageView() 
    
    private let albumLabelStackView = UIStackView().then{
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let albumNameLabel = UILabel().then{
        $0.text = "Album Name"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        $0.textColor = .white
    }
    
    private let albumLabel = UILabel().then{
        $0.text = "Artist"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        $0.textColor = .white.withAlphaComponent(0.7)
    }
    
    
    private func setComponent(){
        [
            albumImage,
            albumLabelStackView,
        ].forEach{
            addSubview($0)
        }
        
        albumLabelStackView.addSubview(albumNameLabel)
        albumLabelStackView.addSubview(albumLabel)
        
        albumImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(constant.albumImageSize)
        }
        
        albumLabelStackView.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.size.equalTo(constant.albumLabelStackViewSize)
            $0.top.equalTo(albumImage.snp.bottom).offset(6 * UIScreen.main.screenHeight / 667)
        }
        albumNameLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
        }
        albumLabel.snp.makeConstraints{
            $0.top.equalTo(albumNameLabel.snp.bottom)
        }

    }
    
    public func config(image: UIImage, albumName: String){
        albumImage.image = image
        albumNameLabel.text = albumName
    }
}
