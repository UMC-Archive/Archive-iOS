//
//  AlbumCollectionViewCell.swift
//  Archive
//
//  Created by 송재곤 on 1/11/25.
//

import UIKit
import Then
import SnapKit

class ListenRecordCollectionViewCell: UICollectionViewCell {
    static let listenRecordCollectionViewIdentifier = "listenRecordCollectionViewIdentifier"
    
    private enum constant {
        static let albumImageSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 160, height: 160) : CGSize(width: 140, height: 140)
        static let albumLabelStackViewSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 140, height: 40) : CGSize(width: 140, height: 40)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let albumImage = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    public let touchView = UIView()
    
    private let songNameLabel = UILabel().then{
        $0.text = "song Name"
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
            songNameLabel,
            touchView,
            artistLabel,
        ].forEach{
            addSubview($0)
        }
        
        albumImage.snp.makeConstraints{

            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(albumImage.snp.width)
        }
        
        touchView.snp.makeConstraints{
            $0.leading.equalTo(albumImage.snp.leading)
            $0.trailing.equalTo(albumImage.snp.trailing)
            $0.height.equalToSuperview()
        }
        songNameLabel.snp.makeConstraints{
            $0.top.equalTo(albumImage.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(3)
        }
        artistLabel.snp.makeConstraints{
            $0.top.equalTo(songNameLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview().inset(3)
        }

    }
    
    public func config(image: UIImage, albumName: String){
        albumImage.image = image
        songNameLabel.text = albumName
    }
    public func configData(image: String, albumName: String, artist: String){
        albumImage.kf.setImage(with: URL(string: image))
        songNameLabel.text = albumName
        artistLabel.text = artist
    }
}
