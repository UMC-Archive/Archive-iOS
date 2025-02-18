//
//  RecentMusicView.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class RecentMusicView: UIView {
    private enum constant {//작은 디바이스 대응용 constraint
        static let itemSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 350, height: 50) : CGSize(width: 337, height: 50)
    }
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
    public let navigationView = NavigationBar(title: .RecentlyPlayedMusic)
    
    public let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.scrollDirection = .vertical
        $0.itemSize = constant.itemSize
        $0.minimumInteritemSpacing = 12 * UIScreen.main.screenHeight / 667
    }).then{
        $0.backgroundColor = UIColor.black_100
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "genreCollectionViewIdentifier")
//        $0.register(RecapCollectionViewVerticalCell.self, forCellWithReuseIdentifier: "recapCollectionViewVerticalCellIdentifier")
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
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        collectionView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(30)
            $0.bottom.equalToSuperview().inset(FloatingViewHeight)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        
        
    }
}
