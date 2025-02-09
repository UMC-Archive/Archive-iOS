//
//  AlbumTrackView.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

// 수록곡 뷰
class AlbumTrackView: UIView {
    private let artistImageWidth: CGFloat = 20
    
    // 이미지 포합 그룹 뷰
    private let imageInfoGroupView = UIView()
    
    // 정보 그룹 뷰
    private let infoGroupView = UIView()
        
    // 수록곡 이미지 뷰
    private let trackImageView = AlbumImageView()
    
    // 수록곡 타이틀
    private let trackTitleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        lbl.numberOfLines = 1
        lbl.textColor = .white
    }
    
    // 아티스트 이미지 뷰
    private lazy var artistImageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = artistImageWidth / 2
    }
    
    // 수록곡 아티스트
    private let trackArtist = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    // 년도, 곡 수, 분
    private let trackDetailLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        lbl.textColor = .white_70
        lbl.numberOfLines = 1
    }

    // 수록곡 컬렉션뷰
    public let trackCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({ layout in
        // AlbumTrackView의 inset 합 40, collectionView inset 합 32
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 72, height: 50)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = .zero
        layout.scrollDirection = .horizontal  // 가로 스크롤 활성화
    })).then { view in
        view.isPagingEnabled = true // 페이지 단위 스크롤 적용
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(VerticalCell.self, forCellWithReuseIdentifier: VerticalCell.id)
    }
    
    // 페이지 인디케이터
    public let pageControl = UIPageControl().then { view in
        view.currentPage = 0
        view.numberOfPages = 2  // 페이지 개수 (이후 동적으로 설정 가능)
        view.isUserInteractionEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        backgroundColor = .black.withAlphaComponent(0.3)
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            trackTitleLabel,
            trackArtist,
            artistImageView,
            trackDetailLabel,
        ].forEach{infoGroupView.addSubview($0)}
        
        [
            trackImageView,
            infoGroupView
        ].forEach{imageInfoGroupView.addSubview($0)}
        
        [
            imageInfoGroupView,
            trackCollectionView,
            pageControl,
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI() {
        
        imageInfoGroupView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        trackImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        infoGroupView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(17)
            make.leading.lessThanOrEqualTo(trackImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(8)
        }
        
        
        trackTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        artistImageView.snp.makeConstraints { make in
            make.top.equalTo(trackTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.width.height.equalTo(artistImageWidth)
        }
        
        trackArtist.snp.makeConstraints { make in
            make.centerY.equalTo(artistImageView)
            make.leading.equalTo(artistImageView.snp.trailing).offset(6)
            make.trailing.equalToSuperview()
        }
        
        trackDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(artistImageView.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
        }
        
        trackCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageInfoGroupView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(30)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(13)
            make.height.equalTo(4.8)
            make.centerX.equalToSuperview()
        }
    }
    
    public func config(data: AlbumTrack){
        trackImageView.kf.setImage(with: URL(string: data.albumImageURL)) { [weak self] result in
            switch result {
            case .success:
                // 이미지 설정 완료 후 평균 색상을 계산
                self?.setBackgroundColorBasedOnImageColor()

            case .failure(let error):
                print("Error loading image: \(error)")
                self?.backgroundColor = .black
            }
        }
        trackTitleLabel.text = data.title
        artistImageView.kf.setImage(with: URL(string: data.artistImageURL))
        trackArtist.text = data.artist
        trackDetailLabel.text = "\(data.year) • \(data.count)곡 • \(data.totalMinute)분"
        
        pageControl.numberOfPages = data.musicList.count / 4 + 1
    }
    
    private func setBackgroundColorBasedOnImageColor() {
        // 배경색 지정 (이미지 평균 색)
        guard let avgColor = trackImageView.avgImageColor() else {return}
        self.backgroundColor = avgColor
        
        // 페이지 컨트롤
        pageControl.currentPageIndicatorTintColor = .white_70
        pageControl.pageIndicatorTintColor = avgColor.withAlphaComponent(0.7)
        
        print("\(String(describing: avgColor.cgColor))")
        
        
//        let gradientLayer = CAGradientLayer().then { layer in
//            layer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
//            layer.colors = [
//                avgColor.withAlphaComponent(0.5).cgColor,
//                avgColor.cgColor,
//            ]
//        }
//        
//        self.layer.addSublayer(gradientLayer)
    }
}
