//
//  AlbumView.swift
//  Archive
//
//  Created by 손현빈 on 2/18/25.
//
import UIKit
import SnapKit
class ForYouAlbumRecommendView : UIView {
    
    lazy var leftArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        button.tintColor = .white
        return button
    }()
    lazy var titleLabel = UILabel().then { make in
        make.textColor = .white
        make.text = "당신을 위한 앨범 추천"
        make.font = .customFont(font: .SFPro, ofSize: 21,rawValue : 700)
        make.textAlignment = .center
    }
    lazy var ForYouRecommendAlbumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 206) // 셀 크기
        layout.minimumInteritemSpacing = 15 // 열 간 간격
        layout.minimumLineSpacing = 15 // 행 간 간격
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15) // 섹션 여백
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews(){
        addSubview(ForYouRecommendAlbumCollectionView)
        addSubview(leftArrowButton)
        addSubview(titleLabel)
        
    }
    private func setupConstraints(){
        leftArrowButton.snp.makeConstraints{make in
            make.top.equalTo(safeAreaLayoutGuide).offset(46)
            make.leading.equalToSuperview().offset(19)
            
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(46)
            make.leading.equalTo(leftArrowButton).offset(20)
        }
        ForYouRecommendAlbumCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(FloatingViewHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}


class ForYouRecommendAlbumCell : UICollectionViewCell {
    static let identifier = "ForYouRecommendAlbumCell"
    public let imageView = AlbumImageView()
    public let titleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    public let artistLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 16, rawValue: 400)
        lbl.textColor = .white_70
        lbl.numberOfLines = 1
        lbl.isUserInteractionEnabled = true
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubView()
        setUI()
    }
   
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = ""
        artistLabel.text = ""
        self.gestureRecognizers = nil
    }
    
       private func setSubView() {
           [
               imageView,
               titleLabel,
               artistLabel
           ].forEach{self.addSubview($0)}
       }
    private func setUI(){
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.width.equalTo(160)
        }
        
        // 타이틀
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.leading.equalTo(imageView)
        }
        
        // 아티스트
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
        }
    }
    func configure(dto: AlbumRecommendAlbumResponseDTO) {
        let album = dto.album
        titleLabel.text = album.title
        titleLabel.lineBreakMode = .byTruncatingTail // 말줄임표 설정
          titleLabel.numberOfLines = 1 // 한 줄만 표시

        artistLabel.text = dto.artist
        imageView.kf.setImage(with: URL(string: album.image))
    }

    
  
}
