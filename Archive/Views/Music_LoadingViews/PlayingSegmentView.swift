//
//  PlayingSegmentView.swift
//  Archive
//
//  Created by 이수현 on 2/19/25.
//

import UIKit

class PlayingSegmentView: UIView {
    
    // 탭바와 동일한 플로팅 뷰
    public let floatingView = AlbumInfoView()
    
    // 세그먼트뷰와 분리선
    private let seperator = UIView().then { view in
        view.backgroundColor = .white_70
    }
    
    // 세그먼트 컨트롤
    public let segmentedControl = UISegmentedControl(items: ["다음 트랙", "가사", "추천 컨텐츠"]).then { sc in
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .black_100
        sc.setTitleTextAttributes([NSAttributedString.Key
            .foregroundColor : UIColor.white_70,
                                   .font : UIFont.customFont(font: .SFPro, ofSize: 14, rawValue: 400),
            .baselineOffset : 7,
        ], for: .normal)
    }
    
    // 다음 트랙 컬렉션 뷰
    public let nextTrackCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({ layout in

    })).then { view in
        view.backgroundColor = .black_100
    }
}
