//
//  TrackCell.swift
//  Archive
//
//  Created by 이수현 on 2/19/25.
//

import UIKit

class TrackCell: UICollectionViewCell {
    static let identifier = "TrackCell"
    
    public let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(named: "placeholder") // 기본 이미지
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public let moreButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named :  "etc"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // 더보기 뷰
    public let overflowView = OverflowView().then { view in
        view.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black_100
        setupViews()
        setupConstraints()
        // 버튼 눌릴 시 타게팅
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.albumImageView.image = nil
        self.titleLabel.text = nil
        self.detailLabel.text = nil
        self.moreButton.removeTarget(nil, action: nil, for: .allEvents)
        self.overflowView.gestureRecognizers = nil
        
        self.gestureRecognizers = nil
    }
    
    
    public let touchView = UIView()
    
    private func setupViews() {
        
        contentView.addSubview(albumImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(touchView)
        contentView.addSubview(detailLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(overflowView)
    }
    
    private func setupConstraints() {
        // 앨범 이미지
        albumImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        // 제목
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumImageView.snp.trailing).offset(12)
            make.top.equalTo(albumImageView.snp.top).offset(2)
            make.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-8)
        }
        touchView.snp.makeConstraints{
            $0.leading.equalTo(albumImageView.snp.leading)
            $0.trailing.equalTo(moreButton.snp.leading)
            $0.height.equalToSuperview()
        }
        
        // 아티스트와 연도
        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumImageView.snp.trailing).offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-8)
        }
        
        // 점 세 개 버튼
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        overflowView.snp.makeConstraints { make in
            make.width.equalTo(97)
            make.height.equalTo(52.5)
//            make.top.equalTo(overflowButton.snp.bottom).offset(7.5)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(moreButton).offset(-15)
        }

    }
    
    public func setOverflowView(type: OverflowType){
        overflowView.setType(type: type)
        switch type {
        case .inAlbum:
            overflowView.snp.updateConstraints { make in
                make.height.equalTo(26)
            }
//        case .inLibrary:
//            overflowView.snp.updateConstraints { make in
//                make.height.equalTo(26)
//            }
        default:
            return
        }
    }
    
    func configure(dto: SelectionResponseDTO) {
        titleLabel.text = dto.music.title
        detailLabel.text = "\(dto.artist) · \(dto.music.releaseTime.prefixBeforeDash())"
        albumImageView.kf.setImage(with: URL(string: dto.music.image))
    }

    func configure(dto: RecommendMusicResponseDTO) {
        titleLabel.text = dto.music.title
        detailLabel.text = "\(dto.artist) · \(dto.album.releaseTime.prefixBeforeDash())"
        albumImageView.kf.setImage(with: URL(string: dto.album.image))
    }

}
