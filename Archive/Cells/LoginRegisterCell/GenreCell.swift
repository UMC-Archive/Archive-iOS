//
//  GenreCell.swift
//  Archive
//
//  Created by 손현빈 on 2/20/25.
//

import UIKit


class GenreCell: UICollectionViewCell {
    static let identifier = "GenreCell"
    private static var imageCache = NSCache<NSString, UIImage>() // 이미지 캐시

    private var genreImageView = UIImageView().then { make in
        make.contentMode = .scaleAspectFill
        make.layer.cornerRadius = 12 // 모서리 둥글게
        make.clipsToBounds = true
    }

    private var genreNameLabel = UILabel().then { make in
        make.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        make.textColor = .white
        make.textAlignment = .center
    }

    private var overlayView = UIView().then { make in
        make.backgroundColor = UIColor(white: 0, alpha: 0.4) // 어둡게 보이는 오버레이
        make.isHidden = true // 기본적으로 숨김
        make.layer.cornerRadius = 12
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
        contentView.addSubview(genreImageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(genreNameLabel)
    }

    private func setupConstraints() {
        genreImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        genreNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            genreImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            genreImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genreImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            genreImageView.heightAnchor.constraint(equalToConstant: 100),

            overlayView.topAnchor.constraint(equalTo: genreImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: genreImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: genreImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: genreImageView.bottomAnchor),

            genreNameLabel.topAnchor.constraint(equalTo: genreImageView.bottomAnchor, constant: 5),
            genreNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genreNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(imageURL: String, name: String, isSelected: Bool) {
        genreNameLabel.text = name
        overlayView.isHidden = isSelected

        if let cachedImage = GenreCell.imageCache.object(forKey: imageURL as NSString) {
            //  캐시된 이미지가 있으면 사용
            genreImageView.image = cachedImage
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
                print(" 이미지 다운로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }

            //  이미지 캐시에 저장
            GenreCell.imageCache.setObject(image, forKey: urlString as NSString)

            DispatchQueue.main.async {
                self.genreImageView.image = image
            }
        }
        task.resume()
    }
}
