//
//  AlbumTrackView.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

// 수록곡 뷰
class AlbumTrackView: UIView {
    private let artistImageWidth: CGFloat = 20
        
    // 수록곡 이미지 뷰
    private let trackImageView = AlbumImageView()
    
    // 수록곡 타이틀
    private let trackTitleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        lbl.numberOfLines = 1
        lbl.textColor = .white
    }
    
    // 아티스트 이미지 뷰
    private lazy var artistImageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = artistImageWidth / 2
    }
    
    // 수록곡 아티스트
    private let trackArtist = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    // 년도, 곡 수, 분
    private let trackDetailLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        lbl.textColor = .white_70
        lbl.numberOfLines = 1
    }

    // 수록곡 컬렉션뷰
    public let trackCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({ layout in
        layout.itemSize = CGSize(width: 303, height: 50)
        layout.minimumInteritemSpacing = 10
    })).then { view in
        view.backgroundColor = .clear
        view.register(VerticalCell.self, forCellWithReuseIdentifier: VerticalCell.id)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor(hex: "D68577")
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            trackImageView,
            trackTitleLabel,
            trackArtist,
            artistImageView,
            trackDetailLabel,
            trackCollectionView
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        trackImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(120)
        }
        
        trackTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(34)
            make.leading.equalTo(trackImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        artistImageView.snp.makeConstraints { make in
            make.top.equalTo(trackTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(trackTitleLabel)
            make.width.height.equalTo(artistImageWidth)
        }
        
        trackArtist.snp.makeConstraints { make in
            make.centerY.equalTo(artistImageView)
            make.leading.equalTo(artistImageView.snp.trailing).offset(6)
            make.trailing.equalTo(trackTitleLabel)
        }
        
        trackDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(artistImageView.snp.bottom).offset(2)
            make.leading.equalTo(trackTitleLabel)
            make.trailing.equalTo(trackTitleLabel)
        }
        
        trackCollectionView.snp.makeConstraints { make in
            make.top.equalTo(trackImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(17)
        }
    }
    
    public func config(data: AlbumTrack){
        trackImageView.kf.setImage(with: URL(string: data.albumImageURL))
        trackTitleLabel.text = data.title
        artistImageView.kf.setImage(with: URL(string: data.artistImageURL))
        trackArtist.text = data.artist
        trackDetailLabel.text = "\(data.year) • \(data.count)곡 • \(data.totalMinute)분"
    }
}
