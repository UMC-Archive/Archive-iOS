//
//  PlayListCollectionViewCell.swift
//  Archive
//
//  Created by 송재곤 on 1/9/25.
//

import UIKit
import Then
import SnapKit

class PlayListCollectionViewCell: UICollectionViewCell {
    static let playListCollectionViewIdentifier = "playListCollectionViewIdentifier"
    
    private enum constant {
        static let playListAlbumImageCollectionViewSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 50, height: 50) : CGSize(width: 50, height: 50)
        static let playListLabelStackViewSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 101, height: 39) : CGSize(width: 101, height: 39)
        static let etcImageSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 3, height: 17) : CGSize(width: 3, height: 17)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let playListAlbumImage = UIImageView()
    
    private let playListLabelStackView = UIStackView().then{
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let playListLabel = UILabel().then{
        $0.text = "플레이리스트"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        $0.textColor = .white
    }
    
    private let trackNumLabel = UILabel().then{
        $0.text = "재생목록 · N 트랙"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        $0.textColor = .white.withAlphaComponent(0.7)
    }
    
    private let etcImage = UIImageView().then{
        $0.image = UIImage(named: "etc")
    }
    
    private func setComponent(){
        [
            playListAlbumImage,
            playListLabelStackView,
            etcImage
        ].forEach{
            addSubview($0)
        }
        
        playListLabelStackView.addSubview(playListLabel)
        playListLabelStackView.addSubview(trackNumLabel)
        
        playListAlbumImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(constant.playListAlbumImageCollectionViewSize)
        }
        
        playListLabelStackView.snp.makeConstraints{
            $0.leading.equalTo(playListAlbumImage.snp.trailing).offset(10 * UIScreen.main.screenWidth / 375)
            $0.size.equalTo(constant.playListLabelStackViewSize)
            $0.centerY.equalToSuperview()
        }
        playListLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
        }
        trackNumLabel.snp.makeConstraints{
            $0.top.equalTo(playListLabel.snp.bottom)
        }
        etcImage.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(constant.etcImageSize)
        }

    }
    
    public func config(image: UIImage){
        playListAlbumImage.image = image
    }
}
