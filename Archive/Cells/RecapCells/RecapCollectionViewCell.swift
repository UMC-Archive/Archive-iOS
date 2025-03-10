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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.gestureRecognizers = nil
    }
    
    // CDView
    public let cdView = CDView(imageWidthHeight: 258, holeWidthHeight: 40)
    
    private let song = UILabel().then{
        $0.text = "Song Title"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    public let artist = UILabel().then{
        $0.text = "Artist · 9999"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        $0.textColor = UIColor.white_70
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
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
            $0.leading.equalToSuperview().offset(59)
            $0.trailing.equalToSuperview().offset(-59)
//            $0.centerX.equalTo(cdView)
        }
        artist.snp.makeConstraints{
            $0.top.equalTo(song.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(59)
            $0.trailing.equalToSuperview().offset(-59)
//            $0.centerX.equalTo(cdView)
        }
    }
    
    public func config(data: MusicDummyModel){
        cdView.config(albumImageURL: data.albumURL)
        song.text = data.musicTitle
        artist.text = data.artist
    }
    public func recapConfig(data: RecapResponseDTO){
        cdView.config(albumImageURL: data.image)
        song.text = data.title
        let updatedText = "\(data.artists) · \(data.releaseYear)"
        print("---------123")
        print(updatedText)
        artist.text = updatedText
    }
    
    // mainCD
    public func configMainCD(data: MainCDResponseDTO) {
        cdView.config(albumImageURL: data.album.image)
        song.text = data.music.title
        artist.text = "\(data.artist) · \(data.music.releaseTime.prefixBeforeDash())"
    }
}
