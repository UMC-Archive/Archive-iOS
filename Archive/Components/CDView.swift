//
//  CDView.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

// CD 이미지, 구멍만 있는 뷰
class CDView: UIView {
    
    private let imageWidthHeight: CGFloat // 앨범 이미지 크기
    private let holeWidthHeight: CGFloat // 가운데 구멍 크기
    
    // CD 구멍
    private lazy var CDHole = UIImageView().then { view in
        view.image = .ellipse.withTintColor(.black_70 ?? .black)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        
        view.layer.cornerRadius = holeWidthHeight / 2
        view.layer.borderColor = UIColor(hex: "#929292")?.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 2
    }
    
    // 앨범 이미지
    private lazy var albumImageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = imageWidthHeight / 2
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(hex: "929292")?.withAlphaComponent(0.5).cgColor
    }
    
    init(imageWidthHeight: CGFloat, holeWidthHeight: CGFloat) {
        self.imageWidthHeight = imageWidthHeight
        self.holeWidthHeight = holeWidthHeight
        super.init(frame: .zero)
        
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            albumImageView,
            CDHole
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        
        // 앨범 이미지
        albumImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageWidthHeight)
            make.edges.equalToSuperview()
        }
        
        // CD 구멍
        CDHole.snp.makeConstraints { make in
            make.center.equalTo(albumImageView)
            make.width.height.equalTo(holeWidthHeight)
        }
    }
    
    public func config(albumImageURL: String) {
        albumImageView.kf.setImage(with: URL(string: albumImageURL))
    }
}
