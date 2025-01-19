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
    }
    
    private let contentView = UIView()
    
    // 아티스트 메인 이미지
    private let imageView = UIImageView().then { view in
        view.kf.setImage(with: URL(string: "https://cdn.hankyung.com/photo/202410/01.38493988.1.jpg"))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
    }
    
    // 그라데이션뷰
    public let gradientView = UIView().then { view in
//        view.backgroundColor = .yellow
    }
    
    // 이름 라벨
    private let nameLabel = UILabel().then { lbl in
        lbl.text = "G-DRAGON"
        lbl.font = .customFont(font: .SFPro, ofSize: 36, rawValue: 700)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    // 재생 버튼
    public let playButton = UIButton().then { btn in
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        config.image = .init(systemName: "play.circle.fill")?.withConfiguration(imageConfig)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        btn.configuration = config

        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.tintColor = UIColor(hex: "#191817")
        btn.backgroundColor = .white
    }
    
    // 설명
    public let descriptionLabel = UILabel().then { lbl in
        lbl.text =  "지드래곤(본명: 권지용)은 1988년 8월 18일 서울특별시 용산구에서 아버지 권영환, 어머니 한기란의 아들로 태어났다. 형제로는 누나 1명이 있다. 어린 시절 어머니로부터 남다른 교육을 받고 자란 그는 1994년 《로그원》에 출연하며 연예계에 입문했다.[5][6] 이후 안무가 서용화의 눈에 띄어 또래의 친구들과 당시의 최고 인기그룹 룰라의 키즈 버전인 '꼬마 룰라'로 활동했다.[7][8] 또한 임권택 감독의 영화 《태백산맥》으로 아역배우로도 활동했던 경력이 있다.[9] 이후 또래 친구들과 같이 평범한 학교 생활을 하고 있었던 그는 가족들과 스키장에 놀러가서 우연히 서게 된 춤 대회에서 나이 많은 형들을 제치고 1등을 했고, 그 무대에서 사회를 보던 SM 엔터테인먼트의 이수만은 그의 끼를 알아보고 SM의 연습생으로 발탁되어, SM에서 가계약을 하고 5년 정도 연습생으로 속해 있었다. 하지만 뚜렷한 비전을 갖지 못했던 그는 숭의초등학교 3학년 때 절친한 친구의 집에서 우탱클랜 등의 흑인음악을 처음 접하고 큰 충격을 받고 힙합 장르에 관심을 갖게 되었다"
        lbl.font = .customFont(font: .SFPro, ofSize: 14, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 3
        lbl.isUserInteractionEnabled = true // 터치 이벤트 가능하도록 설정
    }
    
    // 컬렉션뷰
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then { view in
        view.backgroundColor = .clear
        view.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        
        view.register(VerticalCell.self, forCellWithReuseIdentifier: VerticalCell.id)
        view.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
        view.register(MusicVideoCell.self, forCellWithReuseIdentifier: MusicVideoCell.id)
        view.register(CircleCell.self, forCellWithReuseIdentifier: CircleCell.id)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
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
            make.trailing.equalTo(playButton.snp.leading)
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
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(2000)
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
        
        return header
    }
}
