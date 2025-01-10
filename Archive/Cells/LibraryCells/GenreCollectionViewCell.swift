//
//  GenreCollectionViewCell.swift
//  Archive
//
//  Created by 송재곤 on 1/10/25.
//

import UIKit
import Then
import SnapKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let genreCollectionViewIdentifier = "genreCollectionViewIdentifier"
    
    private enum constant {
        static let genreImageSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 50, height: 50) : CGSize(width: 50, height: 50)
        static let genreLabelStackViewSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 101, height: 39) : CGSize(width: 101, height: 39)
        static let etcImageSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 3, height: 17) : CGSize(width: 3, height: 17)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let genreImage = UIImageView() 
    
    private let genreLabelStackView = UIStackView().then{
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let songLabel = UILabel().then{
        $0.text = "노래 제목"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        $0.textColor = .white
    }
    
    private let artistYearLabel = UILabel().then{
        $0.text = "아티스트 · 년도"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        $0.textColor = .white.withAlphaComponent(0.7)
    }
    
    private let etcImage = UIImageView().then{
        $0.image = UIImage(named: "etc")
    }
    
    private func setComponent(){
        [
            genreImage,
            genreLabelStackView,
            etcImage
        ].forEach{
            addSubview($0)
        }
        
        genreLabelStackView.addSubview(songLabel)
        genreLabelStackView.addSubview(artistYearLabel)
        
        genreImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(constant.genreImageSize)
        }
        
        genreLabelStackView.snp.makeConstraints{
            $0.leading.equalTo(genreImage.snp.trailing).offset(10 * UIScreen.main.screenWidth / 375)
            $0.size.equalTo(constant.genreLabelStackViewSize)
            $0.centerY.equalToSuperview()
        }
        songLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
        }
        artistYearLabel.snp.makeConstraints{
            $0.top.equalTo(songLabel.snp.bottom)
        }
        etcImage.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(constant.etcImageSize)
        }

    }
    
    public func config(image: UIImage, songName: String, artist: String, year: String){
        genreImage.image = image
        songLabel.text = songName
        
        songLabel.text = songName
        
        let updatedText = "\(artist) · \(year)"
        artistYearLabel.text = updatedText
    }
}
