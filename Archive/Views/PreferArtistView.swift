//
//  On_Boarding1View.swift
//  Archive
//
//  Created by 손현빈 on 1/11/25.
//



import UIKit
import Foundation

class PreferArtistView : UIView {
    
    // cell로 만들기, scroll view 만들기
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var contentView : UIView = {
        let view = UIView()
             return view
    }()
    lazy var ArtistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then ({ make in
        make.estimatedItemSize = .init(width: 60, height : 80)
        make.minimumInteritemSpacing = 10
        make.minimumLineSpacing = 20
        
    })).then {make in
        make.backgroundColor = .clear
        make.isScrollEnabled = false
        make.register(ArtistCell.self,forCellWithReuseIdentifier: ArtistCell.identifier)
    }
    
    class ArtistCell : UICollectionViewCell {
        static let identifier = "CategoryCell"
        var categoryImageView = UIImageView().then {make in
            make.contentMode = .scaleAspectFill }
        var ArtistName = UILabel().then {make in
            make.font = UIFont.systemFont(ofSize:12)
            make.textColor = .black
        }
        
    }
    override init(frame: CGRect) {
           super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        
       }
    
    private func setupViews (){
        
        
    }
    private func setupConstraints(){
        
        
    }
    required init?(coder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
           }
}
