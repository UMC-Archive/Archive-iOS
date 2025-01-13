//
//  AlbumImageView.swift
//  Archive
//
//  Created by 이수현 on 1/14/25.
//

import UIKit

class AlbumImageView: UIImageView{
    
    init(){
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
    }
}
