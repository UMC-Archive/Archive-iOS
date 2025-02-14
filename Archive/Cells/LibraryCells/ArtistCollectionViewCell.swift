//
//  ArtistCollectionViewCell.swift
//  Archive
//
//  Created by 송재곤 on 1/11/25.
//

import UIKit
import Then
import SnapKit

class ArtistCollectionViewCell: UICollectionViewCell {
    static let artistCollectionViewIdentifier = "artistCollectionViewIdentifier"
    
    private enum constant {
        static let artistImageSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 50, height: 50) : CGSize(width: 50, height: 50)
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
    
    private let artistImage = UIImageView().then{
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }
    
    private let artistLabelStackView = UIStackView().then{
        $0.axis = .vertical
        $0.alignment = .leading
        
    }
    
    
    private let artistNameLabel = UILabel().then{
        $0.text = "아티스트 이름"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        $0.textColor = .white
    }
    
    private let artistLabel = UILabel().then{
        $0.text = "아티스트"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        $0.textColor = .white.withAlphaComponent(0.7)
    }
    
    public let etcImage = UIImageView().then{
        $0.image = UIImage(named: "etc")
    }
    // 더보기 뷰
    public let overflowView = OverflowView().then { view in
        view.isHidden = true
    }
    
    private func setComponent(){
        [
            artistImage,
            artistLabelStackView,
            etcImage,
            overflowView
        ].forEach{
            addSubview($0)
        }
        
        artistLabelStackView.addSubview(artistNameLabel)
        artistLabelStackView.addSubview(artistLabel)
        
        artistImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(constant.artistImageSize)
        }
        
        artistLabelStackView.snp.makeConstraints{
            $0.leading.equalTo(artistImage.snp.trailing).offset(10 * UIScreen.main.screenWidth / 375)
            $0.size.equalTo(constant.genreLabelStackViewSize)
            $0.centerY.equalToSuperview()
        }
        artistNameLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
        }
        artistLabel.snp.makeConstraints{
            $0.top.equalTo(artistNameLabel.snp.bottom)
        }
        etcImage.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(constant.etcImageSize)
        }
        // 더보기 뷰
        overflowView.snp.makeConstraints { make in
            make.width.equalTo(97)
            make.height.equalTo(52.5)
//            make.top.equalTo(overflowButton.snp.bottom).offset(7.5)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(etcImage).offset(-7)
        }

    }
    
    public func config(image: String, artistName: String){
        let imageUrl = URL(string: image)
        artistImage.kf.setImage(with: imageUrl)
        artistNameLabel.text = artistName
    }
    public func setOverflowView(type: OverflowType){
        overflowView.setType(type: type)
        switch type {
        case .inAlbum:
            overflowView.snp.updateConstraints { make in
                make.height.equalTo(26)
            }
        default:
            return
        }
    }
}
