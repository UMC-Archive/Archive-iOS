//
//  LibraryMainView.swift
//  Archive
//
//  Created by 송재곤 on 1/9/25.
//

import UIKit
import SnapKit
import Then

class LibraryMainView : UIView {
    
    private enum constant {//작은 디바이스 대응용 constraint
        static let libraryLabelSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 78, height: 33) : CGSize(width: 78, height: 33)
        //앞은 큰 디바이스 뒤는 미니 디바이스
        static let segmentViewSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 350, height: 35) : CGSize(width: 335, height: 31)
        
        static let myPageIconSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 25, height: 25) : CGSize(width: 25, height: 25)
        
        static let playlistCollectionViewIconSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 350, height: 50) : CGSize(width: 335, height: 50)
        
        static let playlistCollectionViewSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 350, height: 422) : CGSize(width: 335, height: 422)
        
        static let albumCollectionViewSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 350, height: 422) : CGSize(width: 335, height: 422)
        static let albumCollectionViewIconSize = UIScreen.main.isWiderThan375pt ? CGSize(width: 350, height: 206) : CGSize(width: 160, height: 206)
      }
    
    
    public let topView = TopView(type: .library)
    
    //상단 세그먼트
    public let librarySegmentControl = UISegmentedControl(items: ["재생목록", "노래", "앨범", "아티스트"]).then{
        
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
               
        $0.selectedSegmentIndex = 0
        
        //기본 상태의 색 설정
        $0.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7), .font: UIFont.customFont(font: .SFPro, ofSize: 14, rawValue: 400),
            ],
            for: .normal)
        //눌린 상태의 색 설정
        $0.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.customFont(font: .SFPro, ofSize: 14, rawValue: 400),
            ],
            for: .selected)
    }
    
    private lazy var normalUnderbar = UIView().then{
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
    public lazy var selectedUnderbar = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
        print(UIScreen.main.screenHeight)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let playlistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.scrollDirection = .vertical
        $0.itemSize = constant.playlistCollectionViewIconSize
        $0.minimumInteritemSpacing = 12 * UIScreen.main.screenHeight / 667
    }).then{
        $0.backgroundColor =  UIColor.black_100
        $0.isScrollEnabled = true
        $0.register(PlayListCollectionViewCell.self, forCellWithReuseIdentifier: "playListCollectionViewIdentifier")
    }
    
    public let songCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.scrollDirection = .vertical
        $0.itemSize = constant.playlistCollectionViewIconSize
        $0.minimumInteritemSpacing = 12 * UIScreen.main.screenHeight / 667
    }).then{
        $0.backgroundColor =  UIColor.black_100
        $0.isScrollEnabled = true
        $0.register(LibrarySongCollectionViewCell.self, forCellWithReuseIdentifier: "librarySongCollectionViewIdentifier")
    }
    
    public let albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.scrollDirection = .vertical
        $0.itemSize = constant.albumCollectionViewIconSize
        $0.minimumInteritemSpacing = 12 * UIScreen.main.screenHeight / 667
    }).then{
        $0.backgroundColor =  UIColor.black_100
        $0.isScrollEnabled = true
        $0.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: "albumCollectionViewIdentifier")
    }
    
    
    public let artistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.scrollDirection = .vertical
        $0.itemSize = constant.playlistCollectionViewIconSize
        $0.minimumInteritemSpacing = 12 * UIScreen.main.screenHeight / 667
    }).then{
        $0.backgroundColor =  UIColor.black_100
        $0.isScrollEnabled = true
        $0.register(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: "artistCollectionViewIdentifier")
    }
    
    private func setComponent(){
        
        //subview에 추가
        [
            topView,
            librarySegmentControl,
            normalUnderbar,
            selectedUnderbar,
            playlistCollectionView,
            songCollectionView,
            albumCollectionView,
            artistCollectionView,
        ].forEach{
            addSubview($0)
        }
        
        topView.snp.makeConstraints{
//            $0.top.equalTo(safeAreaLayoutGuide).offset(46 * UIScreen.main.screenHeight / 667)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(librarySegmentControl)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        librarySegmentControl.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(16 * UIScreen.main.screenHeight / 667)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(constant.segmentViewSize)
        }
        normalUnderbar.snp.makeConstraints{
            $0.top.equalTo(librarySegmentControl.snp.bottom).offset(1 * UIScreen.main.screenHeight / 667) // 667는 미니 화면 높이
            $0.leading.equalTo(librarySegmentControl.snp.leading)
            $0.width.equalTo(librarySegmentControl.snp.width)
            $0.height.equalTo(0.5)
        }
        selectedUnderbar.snp.makeConstraints{
            $0.bottom.equalTo(normalUnderbar.snp.bottom)
            $0.leading.equalTo(librarySegmentControl.snp.leading)
            $0.width.equalTo(67)
            $0.height.equalTo(1)
        }
        playlistCollectionView.snp.makeConstraints{
//            $0.size.equalTo(constant.playlistCollectionViewSize)
            $0.top.equalTo(librarySegmentControl.snp.bottom).offset(20 * UIScreen.main.screenHeight / 667)
//            $0.leading.equalTo(librarySegmentControl.snp.leading)
            $0.horizontalEdges.equalTo(librarySegmentControl)
            $0.bottom.equalToSuperview().inset(FloatingViewHeight)
        }
        songCollectionView.snp.makeConstraints{
//            $0.size.equalTo(constant.playlistCollectionViewSize)
            $0.top.equalTo(librarySegmentControl.snp.bottom).offset(20 * UIScreen.main.screenHeight / 667)
//            $0.leading.equalTo(librarySegmentControl.snp.leading)
            $0.horizontalEdges.equalTo(librarySegmentControl)
            $0.bottom.equalToSuperview().inset(FloatingViewHeight)
        }
        albumCollectionView.snp.makeConstraints{
//            $0.size.equalTo(constant.playlistCollectionViewSize)
            $0.top.equalTo(librarySegmentControl.snp.bottom).offset(20 * UIScreen.main.screenHeight / 667)
//            $0.leading.equalTo(librarySegmentControl.snp.leading)
            $0.horizontalEdges.equalTo(librarySegmentControl)
            $0.bottom.equalToSuperview().inset(FloatingViewHeight)
        }
        artistCollectionView.snp.makeConstraints{
//            $0.size.equalTo(constant.playlistCollectionViewSize)
            $0.top.equalTo(librarySegmentControl.snp.bottom).offset(20 * UIScreen.main.screenHeight / 667)
//            $0.leading.equalTo(librarySegmentControl.snp.leading)
            $0.horizontalEdges.equalTo(librarySegmentControl)
            $0.bottom.equalToSuperview().inset(FloatingViewHeight)
        }
    }
}
