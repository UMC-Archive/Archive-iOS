//
//  RecapCollectionViewCells.swift
//  Archive
//
//  Created by 송재곤 on 1/16/25.
//

import UIKit

class RecapCollectionViewCell: UICollectionViewCell {
    static let recapCollectionViewIdentifier = "recapCollectionViewIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let CDImage = UIImageView().then{
        $0.layer.cornerRadius = 129
        $0.clipsToBounds = true
    }
    
    private func setComponent(){
        addSubview(CDImage)
        
        CDImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(258)
        }
    }
    
    public func config(image: UIImage){
        CDImage.image = image
    }
}
