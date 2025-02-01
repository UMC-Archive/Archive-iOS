//
//  Untitled.swift
//  Archive
//
//  Created by 송재곤 on 1/18/25.
//

import UIKit

class GenreRecommendedCollectionViewCell: UICollectionViewCell {
    static let genreRecommendedCollectionViewIdentifier = "genreRecommendedCollectionViewIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let AlbumImage = UIImageView().then{
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private func setComponent(){
        addSubview(AlbumImage)
        
        AlbumImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(120)
        }
    }
    
    public func config(image: UIImage){
        AlbumImage.image = image
    }
}
