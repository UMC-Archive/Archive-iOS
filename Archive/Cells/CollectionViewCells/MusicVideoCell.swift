//
//  MusicVideoCell.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import UIKit

class MusicVideoCell: UICollectionViewCell {
    static let id = "MusicVideoSection"
    
    // 이미지 뷰
    private let imageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
    }
    
    // 재생 버틑
    private let playImageView = UIImageView().then { view in
        view.image = .init(systemName: "play.fill")
        view.tintColor = .black_100
    }
    
    // title
    private let titleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    // 아티스트
    private let artistLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white_70
        lbl.numberOfLines = 1
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
        titleLabel.text = nil
        artistLabel.text = nil
    }
    
    private func setSubView() {
        [
            imageView,
            playImageView,
            titleLabel,
            artistLabel
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI(){
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(70)
        }
        
        playImageView.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.width.equalTo(18)
            make.height.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
        }
        
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    public func config(data: MusicVideoModel) {
        imageView.kf.setImage(with: URL(string: data.imageURL))
        titleLabel.text = data.title
        artistLabel.text = data.artist
    }
}
