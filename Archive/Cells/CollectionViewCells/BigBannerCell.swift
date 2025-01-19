//
//  BigBannerCell.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit
import Kingfisher

class BigBannerCell: UICollectionViewCell {
    static let id = "BigBannerCell"
    private let imageWidth = 180.0
    private let holeWidthHeight = 28.68
    
    // CD 그룹
    private let CDGrorupView = UIView()
    
    // CD 케이스
    private let CDCaseImageView = UIImageView().then { view in
        view.image = .cDcase
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
    }
    
    // CD View
    private lazy var CDImageView = CDView(imageWidthHeight: imageWidth, holeWidthHeight: holeWidthHeight)
    
    private let infoGroupView = UIView()
    
    // 앨범 타이틀
    private let albumTitleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        lbl.textColor = .white
    }
    
    // 앨범 서브 타이틀
//    private let albumSubTitleLabel = UILabel().then { lbl in
//        lbl.font = .customFont(font: .SFPro, ofSize: 13, rawValue: 400)
//        lbl.textColor = .white
//    }
    
    // 아티스트
    public let artistLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white_70
        lbl.isUserInteractionEnabled = true
    }
    
    // 년도
    private let yearLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 12, rawValue: 400)
        lbl.textAlignment = .left
        lbl.textColor = .white_70
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBorder()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        CDImageView.albumImageView.image = nil
        albumTitleLabel.text = ""
//        albumSubTitleLabel.text = ""
        yearLabel.text = ""
        artistLabel.text = ""
    }
    
    private func setSubView() {
        [
            CDCaseImageView,
            CDImageView
//            albumImageView,
//            CDHole
        ].forEach{CDGrorupView.addSubview($0)}
        
        [
            albumTitleLabel,
//            albumSubTitleLabel,
            artistLabel,
            yearLabel
        ].forEach{infoGroupView.addSubview($0)}
        
        [
            CDGrorupView,
            infoGroupView
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        
        // CD 그룹
        CDGrorupView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(206)
        }
        
        // CD case
        CDCaseImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        CDImageView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(10.5)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(11)
        }
        
        
        // 정보 그룹
        infoGroupView.snp.makeConstraints { make in
            make.top.equalTo(CDGrorupView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        // 앨범 타이틀
        albumTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        
        // 앨범 서브 타이틀
//        albumSubTitleLabel.snp.makeConstraints { make in
//            make.top.equalTo(albumTitleLabel.snp.bottom)
//            make.horizontalEdges.equalToSuperview()
//        }
        
        // 아티스트
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(albumTitleLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(14)
        }
        
        // 년도
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalTo(artistLabel)
            make.trailing.equalToSuperview().inset(14)
            make.leading.equalTo(artistLabel.snp.trailing).offset(4)
        }
    }
    
    public func setBorder() {
        // 상단에만 테두리를 제거하고, 양옆과 아래쪽에 테두리를 추가
        let borderLayer = CAShapeLayer()
        
        // 상단에만 테두리 없이 그릴 수 있도록 경로 설정
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0)) // 왼쪽 상단
        path.addLine(to: CGPoint(x: 0, y: infoGroupView.frame.size.height)) // 왼쪽 아래
        path.addLine(to: CGPoint(x: infoGroupView.frame.size.width, y: infoGroupView.frame.size.height)) // 오른쪽 아래
        path.addLine(to: CGPoint(x: infoGroupView.frame.size.width, y: 0)) // 오른쪽 위
        
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.frame = infoGroupView.bounds
        borderLayer.lineWidth = 1
        
        infoGroupView.layer.addSublayer(borderLayer)
        
        // 상단의 cornerRadius만 제거하고, 바텀 양 끝에 cornerRadius를 적용
        let maskPath = UIBezierPath(roundedRect: infoGroupView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        infoGroupView.layer.mask = maskLayer
    }
    
    public func config(album: MusicDummyModel) {
//        albumImageView.kf.setImage(with: URL(string: album.albumURL))
        albumTitleLabel.text = album.albumTitle
//        albumSubTitleLabel.text = album.albumSubTitle
        artistLabel.text = album.artist
        yearLabel.text = "⦁ \(album.year)"
        CDImageView.config(albumImageURL: album.albumURL)

    }
}
