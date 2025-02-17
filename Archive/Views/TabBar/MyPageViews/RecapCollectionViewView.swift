//
//  RecapCollectionViewView.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

//
//  RecentMusicView.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class RecapCollectionViewView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let view = UIView().then{
        $0.backgroundColor = UIColor.black_100
    }
    public let navigationView = NavigationBar(title: .recap)
    
    public let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.scrollDirection = .vertical
        $0.itemSize = CGSize(width: 337, height: 50)
        $0.minimumInteritemSpacing = 12 * UIScreen.main.screenHeight / 667
    }).then{
        $0.backgroundColor = UIColor.black_100
        $0.isScrollEnabled = true
        $0.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "genreCollectionViewIdentifier")
    }
    
    
    private func setConstraint(){
        [
            view,
            navigationView,
            collectionView
        ].forEach{
            addSubview($0)
        }
        view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        navigationView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(46)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        collectionView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(30)
            $0.height.equalTo(422)
            $0.width.equalTo(337)
            $0.leading.equalToSuperview().offset(19)
        }
        
        
        
    }
}
