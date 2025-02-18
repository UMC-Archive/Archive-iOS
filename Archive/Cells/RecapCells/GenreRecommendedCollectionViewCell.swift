//
//  Untitled.swift
//  Archive
//
//  Created by 송재곤 on 1/18/25.
//

import UIKit

class GenreRecommendedCollectionViewCell: UICollectionViewCell {
    static let genreRecommendedCollectionViewIdentifier = "genreRecommendedCollectionViewIdentifier"
    let darkOverlay = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
        setupCell()
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
    private func setupCell() {
        AlbumImage.frame = contentView.bounds
        AlbumImage.contentMode = .scaleAspectFill
        contentView.addSubview(AlbumImage)
        
        darkOverlay.frame = contentView.bounds
        darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.6) // 반투명 어두운 효과
//        darkOverlay.isHidden = true
        contentView.addSubview(darkOverlay)
    }
       
    func updateOverlayVisibility(_ darkRatio: CGFloat) {
        print("----------\(darkRatio)")
        self.darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(darkRatio)
        self.darkOverlay.layer.layoutIfNeeded()
    }

    
    public func configExample(image: UIImage){
        AlbumImage.image = image
    }
    public func config(data : GenrePreferenceResponseDTO){
        let genre = data.name
        switch genre {
        case "Pop":
            AlbumImage.image = .popPattern
        case "Hip hop":
            AlbumImage.image = .hiphopPattern
        case "Afrobeats":
            AlbumImage.image = .afrobeatsPattern
        case "Ballad":
            AlbumImage.image = .balladPattern
        case "Disco":
            AlbumImage.image = .discoPattern
        case "Electronic":
            AlbumImage.image = .electronicPattern
        case "Funk":
            AlbumImage.image = .funkPattern
        case "Indie":
            AlbumImage.image = .indiePattern
        case "Jazz":
            AlbumImage.image = .jazzPattern
        case "Latin":
            AlbumImage.image = .latinPattern
        case "Phonk":
            AlbumImage.image = .phonkPattern
        case "Punk":
            AlbumImage.image = .punkPattern
        case "Rock":
            AlbumImage.image = .rockPattern
        case "Trot":
            AlbumImage.image = .trotPattern
        default:
            AlbumImage.image = .otherPattern
        }

    }
}
