//
//  AlbumView.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

class AlbumView: UIView {
    
    private let scrollView = UIScrollView().then { view in
        view.isScrollEnabled = true
        view.contentInsetAdjustmentBehavior = .never

    }
    
    private let contentView = UIView()
    
    // CD 뷰
    private let albumCDView = CDView(imageWidthHeight: 422, holeWidthHeight: 65.43)
    
    // 뒤로가기 버튼
    public let popButton = UIButton().then { btn in
        btn.setImage(.init(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .white
    }
    
    // 좋아요 버튼
    public let heartButton = UIButton().then { btn in
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        btn.configuration = config
        btn.tintColor = .white
    }
    
    // 앨범 타이틀
    private let titleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 28, rawValue: 700)
        lbl.numberOfLines = 0
        lbl.textColor = .white
    }
    
    // 아티스트
    private let artistLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 14, rawValue: 400)
        lbl.textColor = .white_70
        lbl.numberOfLines = 1
    }
    
    // 본문 내용
    private let contentLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 0
    }
    
    // 수록곡 뷰
    public let trackView = AlbumTrackView()
    
    // 컬렉션 뷰
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then { view in
        view.backgroundColor = .clear
        view.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
        view.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        [
            albumCDView,
            popButton,
            heartButton,
            titleLabel,
            artistLabel,
            contentLabel,
            trackView,
            collectionView
        ].forEach{contentView.addSubview($0)}
        
        scrollView.addSubview(contentView)
        self.addSubview(scrollView)
    }
    
    private func setUI(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            make.bottom.equalTo(collectionView)
//            make.height.equalTo(2000).priority(.low)
        }
        
        albumCDView.snp.makeConstraints { make in
            make.centerY.equalTo(popButton)
            make.centerX.equalToSuperview()
        }
        
        popButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(12)
            make.height.equalTo(20)
        }
        
        heartButton.snp.makeConstraints { make in
            make.centerY.equalTo(popButton)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumCDView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(artistLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        trackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(200) // 수정 필요 180 + 60 * x
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(trackView.snp.bottom).offset(54)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(502)
            make.trailing.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] _ , _ in
            return self?.createBannerSection()
        }, configuration: config)
    }
    
    // 이 아티스트 다른 앨범, 당신을 위한 앨범 추천
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 14)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(186))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    public func config(data: AlbumCurationDummyModel) {
        albumCDView.config(albumImageURL: data.albumImageURL)
        titleLabel.text = data.title
        artistLabel.text = data.artist
        contentLabel.text = data.content
        
        trackView.config(data: data.albumTrack)
    }
}
