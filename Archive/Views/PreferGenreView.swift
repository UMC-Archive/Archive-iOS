//
//  PreferenceView.swift
//  Archive
//
//  Created by 손현빈 on 1/11/25.
//

import UIKit
import Foundation

class PreferGenreView : UIView {
    
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
    
    lazy var GenreCollectionView = UICollectionView (frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then ({make in
        make.estimatedItemSize = .init(width: 60, height: 80)
        make.minimumLineSpacing = 10
        make.minimumInteritemSpacing = 10
    })).then { make in
        make.backgroundColor = .clear
        make.isScrollEnabled = false
        make.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        
    }
    class GenreCell : UICollectionViewCell {
        static let identifier = "GenreCell"
        var categoryImageView = UIImageView().then {make in
            make.contentMode = .scaleAspectFill }
        var GenreName = UILabel().then {make in
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
