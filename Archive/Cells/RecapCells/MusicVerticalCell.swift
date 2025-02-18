//
//  VerticalCell.swift
//  Archive
//
//  Created by 이수현 on 1/14/25.
//

import UIKit

class MusicVerticalCell: UICollectionViewCell {
    static let id = "MusicVerticalCell"
    
    // 앨범 이미지 뷰
    private let imageView = AlbumImageView()
    public let touchView = UIView()
    
    // Album & SongTitle
    private let titleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    // 아티스트 ⦁ year
    public let artistYearLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        lbl.textColor = .white_70
        lbl.numberOfLines = 1
    }
    
    // 더보기 버튼
    public let overflowButton = OverflowButton()
    
    // 더보기 뷰
    public let overflowView = OverflowView().then { view in
        view.isHidden = true
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
        artistYearLabel.text = ""
        overflowButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    
    private func setSubView() {
        [
            imageView,
            titleLabel,
            touchView,
            artistYearLabel,
            overflowButton,
            overflowView
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI(){
        // 이미지 뷰
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(50)
            make.bottom.equalToSuperview().priority(.low)
        }
        
        // 타이틀
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(6)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(overflowButton.snp.leading).offset(-20)
        }
        
        // 아티스트
        artistYearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
        }
        
        // 더보기 버튼
        overflowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(3)
            make.height.equalTo(17)
        }
        touchView.snp.makeConstraints{
            $0.leading.equalTo(imageView.snp.leading)
            $0.trailing.equalTo(overflowButton.snp.leading)
            $0.height.equalToSuperview()
        }
        // 더보기 뷰
        overflowView.snp.makeConstraints { make in
            make.width.equalTo(97)
            make.height.equalTo(52.5)
//            make.top.equalTo(overflowButton.snp.bottom).offset(7.5)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(overflowButton).offset(-7)
        }
    }
    
    public func config(albumURL: String, musicTitle: String, artist: String, year: Int) {
        // 이미지 설정
        imageView.kf.setImage(with: URL(string: albumURL))
        
        // 제목 설정
        titleLabel.text = musicTitle
        
        // 아티스트 및 연도 설정
        artistYearLabel.text = "\(artist) ⦁ \(year)"
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
