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
        yearLabel.text = ""
        artistLabel.text = ""
    }
    
    private func setSubView() {
        [
            CDCaseImageView,
            CDImageView
        ].forEach{CDGrorupView.addSubview($0)}
        
        [
            albumTitleLabel,
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
            make.horizontalEdges.bottom.equalToSuperview().inset(1)
        }
        
        // 앨범 타이틀
        albumTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
    
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
        infoGroupView.layer.addSublayer(borderLayer)
        
        // 상단에만 테두리 없이 그릴 수 있도록 경로 설정
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0)) // 왼쪽 상단
        path.addLine(to: CGPoint(x: 0, y: infoGroupView.frame.size.height - 10)) // 왼쪽 아래로 이동
        
        
        // 왼쪽 아래 둥근 테두리
        var center = CGPoint(x: 10, y: infoGroupView.frame.size.height - 10) // 원의 center
        path.addArc(withCenter: center, radius: 10, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: false)
           
        // 아래 테두리
        path.addLine(to: CGPoint(x: infoGroupView.frame.size.width - 10, y: infoGroupView.frame.size.height)) // 오른쪽 아래로 이동
        
        // 오른쪽 아래 둥근 테두리
        center = CGPoint(x: infoGroupView.frame.size.width - 10, y: infoGroupView.frame.size.height - 10) // 원의 center
        path.addArc(withCenter: center, radius: 10, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: false)
        
        // 오른쪽 테두리
        path.addLine(to: CGPoint(x: infoGroupView.frame.size.width, y: 0)) // 오른쪽 위로 이동
        
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineWidth = 1
        borderLayer.frame = infoGroupView.bounds

        // 그라데이션을 위한 레이어 추가
//        setGradientForBorder(borderLayer)
    }

    public func setGradientForBorder(_ borderLayer: CAShapeLayer) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = borderLayer.bounds
        
        // 그라데이션 색상 설정 (상단은 투명, 하단은 흰색)
        gradientLayer.colors = [
            UIColor.clear.cgColor,  // 상단 투명
            UIColor.white.cgColor   // 하단 흰색
        ]
        
        // 그라데이션 방향 설정 (위에서 아래로)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        // 그라데이션 레이어를 테두리 레이어에 추가
        borderLayer.addSublayer(gradientLayer)
    }
    
    public func config(album: AlbumRecommendAlbum, artist: String) {
        CDImageView.config(albumImageURL: album.image)
        albumTitleLabel.text = album.title
        artistLabel.text = artist
        yearLabel.text = "⦁ \(album.releaseTime.prefixBeforeDash())"
    }
}
