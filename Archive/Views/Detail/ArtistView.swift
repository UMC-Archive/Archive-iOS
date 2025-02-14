//
//  ArtistView.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import UIKit

class ArtistView: UIView {
    private let scrollView = UIScrollView().then { view in
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never

    }
    
    private let contentView = UIView()
    
    // 아티스트 메인 이미지
    private let imageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
    }
    
    // 그라데이션뷰
    public let gradientView = UIView().then { view in
        view.isUserInteractionEnabled = false
    }
    
    public let gradientLayer = CAGradientLayer().then { layer in
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 162)
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black_100?.withAlphaComponent(0.15).cgColor ?? UIColor.black.cgColor,
            UIColor.black_100?.withAlphaComponent(0.8117).cgColor ?? UIColor.black.cgColor,
            UIColor.black_100?.cgColor ?? UIColor.black.cgColor,
        ]
    }
    
    // 이름 라벨
    private let nameLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 36, rawValue: 700)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    // 재생 버튼
    public let playButton = UIButton().then { btn in
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 41, weight: .light)
        config.image = .init(systemName: "play.circle.fill")?.withConfiguration(imageConfig)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        btn.configuration = config

        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.tintColor = .black_100
        btn.backgroundColor = .white
    }
    
    // 설명
    public let descriptionLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 14, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 3
        lbl.isUserInteractionEnabled = true // 터치 이벤트 가능하도록 설정
    }
    
    // 컬렉션뷰
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then { view in
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        
        view.register(VerticalCell.self, forCellWithReuseIdentifier: VerticalCell.id)
        view.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
        view.register(MusicVideoCell.self, forCellWithReuseIdentifier: MusicVideoCell.id)
        view.register(CircleCell.self, forCellWithReuseIdentifier: CircleCell.id)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black_100
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            imageView,
            gradientView,
            nameLabel,
            playButton,
            descriptionLabel,
            collectionView
        ].forEach{contentView.addSubview($0)}
        
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    
    private func setUI() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(collectionView) 
        }
        
        // 이미지 뷰
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(440)
        }
        
        // 그라데이션뷰
        gradientView.snp.makeConstraints { make in
            make.height.equalTo(162)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(nameLabel).offset(33.5)
        }
        
        // 이름
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView).offset(-33.5)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(playButton.snp.leading).offset(-8)
        }
        
        // 재생 버튼
        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
        
        // 설명 라벨
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // 컬렉션 뷰
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(1100)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0: // 아티스트 인기곡
                self?.createVerticalSection()
            case 1: // 앨범 둘러보기
                self?.createBannerSection()
            case 2: //아티스트 뮤직 비디오
                self?.createMusicVideoSection()
            case 3: //다른 비슷한 아티스트
                self?.createCircleSection()
            default:
                self?.createVerticalSection()
            }
        }, configuration: config)
    }
    
    // 아티스트 인기곡
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(298))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let header = createHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 앨범 둘러보기
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 14)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(186))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let header = createHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 뮤직 미디오 섹션
    private func createMusicVideoSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(114))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let header = createHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 다른 비슷한 아티스트
    private func createCircleSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .absolute(134))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let header = createHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }

    // 헤더 생성
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        return header
    }
    
    
    public func config(artistInfo: ArtistInfoReponseDTO, curation: ArtistCurationResponseDTO){
        self.imageView.kf.setImage(with: URL(string: artistInfo.image))
        self.nameLabel.text = artistInfo.name
        self.descriptionLabel.text = curation.description
    }
}
