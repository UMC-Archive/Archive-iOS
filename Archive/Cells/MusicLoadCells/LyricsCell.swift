//
//  LyricsCell.swift
//  Archive
//
//  Created by 손현빈 on 2/20/25.
//

import UIKit

// MARK: - LyricsCell
class LyricsCell: UICollectionViewCell {
    static let identifier = "LyricsCell"

    private let label: UILabel = {
        let label = UILabel()
        label.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 700)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.label.text = nil
    }
    
    func configure(text: String, isHighlighted: Bool) {
        label.text = text
        label.textColor = isHighlighted ? .white : .lightGray
        label.font = isHighlighted ? UIFont.boldSystemFont(ofSize: 18) : UIFont.systemFont(ofSize: 16)
    }
}
