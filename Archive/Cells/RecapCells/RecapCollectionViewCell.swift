//
//  RecapCollectionViewCells.swift
//  Archive
//
//  Created by 송재곤 on 1/16/25.
//

import UIKit

class RecapCollectionViewCell: UICollectionViewCell {
    static let recapCollectionViewIdentifier = "recapCollectionViewIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let CDImage = UIImageView().then{
        $0.layer.cornerRadius = 129
        $0.clipsToBounds = true
    }
    private let song = UILabel().then{
        $0.text = "Song Title"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    private let artist = UILabel().then{
        $0.text = "Artist · 9999"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private func setComponent(){
        addSubview(CDImage)
        addSubview(song)
        addSubview(artist)
        
        CDImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(258)
        }
        song.snp.makeConstraints{
            $0.top.equalTo(CDImage.snp.bottom).offset(12)
            $0.centerX.equalTo(CDImage)
        }
        artist.snp.makeConstraints{
            $0.top.equalTo(song.snp.bottom).offset(2)
            $0.centerX.equalTo(CDImage)
        }
    }
    
    public func config(image: UIImage){
        CDImage.image = image
    }
}
