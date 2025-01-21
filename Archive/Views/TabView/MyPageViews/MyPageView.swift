//
//  myPageView.swift
//  Archive
//
//  Created by 송재곤 on 1/14/25.
//

import UIKit

class MyPageView: UIView {
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    public let topView = TopView(type: .myPage)
    
    // ScrollView 정의
    public var scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    // ScrollView의 ContentView 정의
    public var contentView = UIView()
    
    public let profileView = UIImageView().then{
        $0.image = UIImage(named: "test1")
        $0.clipsToBounds = true
        
    }
    
    public let profileLabel = UILabel().then{
        $0.text = "아킴"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        $0.textColor = .white
    }
    public let arrowButton = UIImageView().then{
        $0.image = UIImage(named: "rightArrow")
    }
    
    public var CDView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 129
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // CDView 및 CDHoleView
    public var CDBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.black_70
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 45
    }
    
    public var CDHoleView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.black_70
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    public let goRecapButton = UIButton().then{
        $0.setTitle("내 Recap 확인하기", for: .normal)
        $0.tintColor = UIColor.black_35
        $0.titleLabel?.font = UIFont.customFont(font: .SFPro, ofSize: 16, rawValue: 700)
        $0.titleLabel?.textColor = UIColor.white
        $0.layer.cornerRadius = 15
        $0.backgroundColor = UIColor.black_35
        $0.isUserInteractionEnabled = true
    }
    
    private let headerView = UILabel().then{
        $0.text = "청취 기록"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        $0.textColor = .white
    }
    public let headerButton = UIButton().then{
        $0.setImage(UIImage(named: "rightArrow"), for: .normal)
    }
    public let recordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.itemSize = CGSize(width: 140, height: 186)
        $0.minimumLineSpacing = 14
        $0.scrollDirection = .horizontal
    }).then{
        $0.backgroundColor = UIColor.black_100
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(ListenRecordCollectionViewCell.self, forCellWithReuseIdentifier: "listenRecordCollectionViewIdentifier")
    }
    
    private let headerView2 = UILabel().then{
        $0.text = "최근에 추가한 노래"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        $0.textColor = .white
    }
    public let headerButton2 = UIButton().then{
        $0.setImage(UIImage(named: "rightArrow"), for: .normal)
    }
    public let recentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.itemSize = CGSize(width: 140, height: 186)
        $0.minimumLineSpacing = 14
        $0.scrollDirection = .horizontal
    }).then{
        $0.backgroundColor = UIColor.black_100
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(ListenRecordCollectionViewCell.self, forCellWithReuseIdentifier: "listenRecordCollectionViewIdentifier")
    }
    
    func setConstraint() {
       
        [
            
            profileView,
            profileLabel,
            arrowButton,
            CDBackgroundView,
            CDView,
            CDHoleView,
            goRecapButton,
            headerView,
            headerButton,
            recordCollectionView,
            headerView2,
            headerButton2,
            recentCollectionView
            
        ].forEach{
            contentView.addSubview($0)
        }
        
        [
            topView,
            scrollView
        ].forEach{
            addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        topView.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide).offset(46)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom) // scrollView는 navigationView 아래에 위치
            $0.leading.trailing.bottom.equalToSuperview()
        }
                
                
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView) // 가로 스크롤 방지
            $0.bottom.equalTo(recentCollectionView.snp.bottom)
        }
        
        profileView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(50)
        }
        profileLabel.snp.makeConstraints{
            $0.centerY.equalTo(profileView)
            $0.leading.equalTo(profileView.snp.trailing).offset(10)
        }
        arrowButton.snp.makeConstraints{
            $0.centerY.equalTo(profileView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        CDView.snp.makeConstraints {
            $0.centerY.equalTo(CDBackgroundView)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(258)
        }
        CDHoleView.snp.makeConstraints{
            $0.centerX.centerY.equalTo(CDView)
            $0.height.width.equalTo(40)
        }
        CDBackgroundView.snp.makeConstraints{
            $0.top.equalTo(profileView.snp.bottom).offset(10)
            $0.centerX.equalTo(CDView)
            $0.width.height.equalTo(312)
        }
        goRecapButton.snp.makeConstraints{
            $0.top.equalTo(CDBackgroundView.snp.bottom).offset(26)
            $0.size.equalTo(CGSize(width: 184, height: 51))
            $0.centerX.equalToSuperview()
        }
        headerView.snp.makeConstraints{
            $0.top.equalTo(goRecapButton.snp.bottom).offset(39)
            $0.leading.equalToSuperview().offset(20)
        }
        headerButton.snp.makeConstraints{
            $0.centerY.equalTo(headerView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 12, height: 20))
        }
        recordCollectionView.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.leading.equalTo(headerView)
            $0.width.equalToSuperview()
            $0.height.equalTo(186)
        }
        headerView2.snp.makeConstraints{
            $0.top.equalTo(recordCollectionView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        headerButton2.snp.makeConstraints{
            $0.centerY.equalTo(headerView2.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 12, height: 20))
        }
        recentCollectionView.snp.makeConstraints{
            $0.top.equalTo(headerView2.snp.bottom).offset(20)
            $0.leading.equalTo(headerView)
            $0.width.equalToSuperview()
            $0.height.equalTo(186)
        }
    }
    
    
}

