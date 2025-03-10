//
//  AlbumCell.swift
//  Archive
//
//  Created by 이수현 on 2/19/25.
//

import UIKit
class AlbumCell: UICollectionViewCell {
    static let identifier = "AlbumCell"
    
    public let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        label.textColor = .white
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        label.textColor = .gray
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumImageView.image = nil
        titleLabel.text = nil
        artistLabel.text = nil
       
        gestureRecognizers = nil
    }
    
    private func setupViews() {
        contentView.addSubview(albumImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
    }
    
    private func setupConstraints() {
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 앨범 이미지
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            albumImageView.heightAnchor.constraint(equalTo: albumImageView.widthAnchor), // 정사각형
            
            // 제목
            titleLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // 아티스트
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            artistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(dto: AlbumRecommendAlbumResponseDTO) {
        let album = dto.album
        titleLabel.text = album.title
        titleLabel.lineBreakMode = .byTruncatingTail // 말줄임표 설정
          titleLabel.numberOfLines = 1 // 한 줄만 표시

        artistLabel.text = dto.artist
        albumImageView.kf.setImage(with: URL(string: album.image))
    }


}
