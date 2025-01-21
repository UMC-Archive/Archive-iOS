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
    
    // CDView
    private let cdView = CDView(imageWidthHeight: 258, holeWidthHeight: 40)
    
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
        addSubview(cdView)
        addSubview(song)
        addSubview(artist)
        
        cdView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        song.snp.makeConstraints{
            $0.top.equalTo(cdView.snp.bottom).offset(12)
            $0.centerX.equalTo(cdView)
        }
        artist.snp.makeConstraints{
            $0.top.equalTo(song.snp.bottom).offset(2)
            $0.centerX.equalTo(cdView)
        }
    }
    
    public func config(data: MusicDummyModel){
        cdView.config(albumImageURL: data.albumURL)
        song.text = data.musicTitle
        artist.text = data.artist
    }
}
