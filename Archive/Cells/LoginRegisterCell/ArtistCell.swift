//
//  Untitled.swift
//  Archive
//
//  Created by 손현빈 on 2/20/25.
//

import UIKit
import Foundation

class ArtistCell: UICollectionViewCell {
    static let identifier = "ArtistCell"
    private static var imageCache = NSCache<NSString, UIImage>() // 이미지 캐시
    
    private var artistImageView = UIImageView().then { make in
        make.contentMode = .scaleAspectFill
        make.layer.cornerRadius = 50
        make.clipsToBounds = true
    }
    
    private var artistNameLabel = UILabel().then { make in
        make.font = UIFont.systemFont(ofSize: 12)
        make.textColor = .white
        make.textAlignment = .center
    }
    
    private var overlayView = UIView().then { make in
        make.backgroundColor = UIColor(white: 0, alpha: 0.4) // 어둡게 보이는 오버레이
        make.isHidden = true // 기본적으로 숨김
        make.layer.cornerRadius = 50
        make.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(artistImageView)
        contentView.addSubview(overlayView) // 오버레이 추가
        contentView.addSubview(artistNameLabel)
    }
    
    private func setupConstraints() {
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artistImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            artistImageView.widthAnchor.constraint(equalToConstant: 100),
            artistImageView.heightAnchor.constraint(equalToConstant: 100),
            
            overlayView.topAnchor.constraint(equalTo: artistImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: artistImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: artistImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: artistImageView.bottomAnchor),
            
            artistNameLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 5),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(imageURL: String, name: String, isSelected: Bool) {
        artistNameLabel.text = name
        overlayView.isHidden = isSelected
        
        if let cachedImage = ArtistCell.imageCache.object(forKey: imageURL as NSString) {
            //  캐시된 이미지가 있으면 사용
            artistImageView.image = cachedImage
        } else {
            // 캐시된 이미지가 없으면 URL에서 다운로드
            downloadImage(from: imageURL)
        }
    }
    
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print(" 잘못된 이미지 URL: \(urlString)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                print("이미지 다운로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            //  이미지 캐시에 저장
            ArtistCell.imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self.artistImageView.image = image
            }
        }
        task.resume()
    }
}

