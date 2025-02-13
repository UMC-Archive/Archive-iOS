import UIKit
import SnapKit

class NextTrackView: UIView {
    // 앨범 이미지 및 정보
    lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "aespa") // 앨범 이미지
        return imageView
    }()

    lazy var songTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Title"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist Name"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    lazy var overlappingSquaresView = UIImageView().then { make in
          make.image = UIImage(systemName: "rectangle.on.rectangle")
          make.tintColor = .white
          make.contentMode = .scaleAspectFit
      }
    // 하단 선분
     lazy var bottomLine = UIView().then { make in
         make.backgroundColor = .gray
     }

    
    // 탭 바 (UISegmentedControl)
    lazy var tabBar: UISegmentedControl = {
        let items = ["다음 트랙", "가사", "추천 콘텐츠"]
        let segmentedControl = UISegmentedControl(items: items)
         segmentedControl.selectedSegmentIndex = 0 // "다음 트랙" 기본 선택

         // 배경 색상 및 선택된 색상 설정
         segmentedControl.backgroundColor = .black
         segmentedControl.selectedSegmentTintColor = .clear // 투명 배경

         // 선택된 텍스트 스타일
         segmentedControl.setTitleTextAttributes([
             .foregroundColor: UIColor.white, // 선택된 텍스트 흰색
             .font: UIFont.boldSystemFont(ofSize: 16) // 굵은 텍스트
         ], for: .selected)

         // 선택되지 않은 텍스트 스타일
         segmentedControl.setTitleTextAttributes([
             .foregroundColor: UIColor.gray, // 선택되지 않은 텍스트 회색
             .font: UIFont.systemFont(ofSize: 16) // 기본 텍스트
         ], for: .normal)

         // 경계선 제거
         segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
         segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

         return segmentedControl
    }()

    // 컬렉션 뷰
    lazy var trackCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(albumImageView)
        addSubview(songTitleLabel)
        addSubview(artistLabel)
        addSubview(playButton)
        addSubview(tabBar)
        addSubview(trackCollectionView)
        addSubview(bottomLine)
        addSubview(overlappingSquaresView)
    }

    private func setupConstraints() {
        albumImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(60)
        }

        songTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.top)
            make.leading.equalTo(albumImageView.snp.trailing).offset(10)
            make.trailing.equalTo(playButton.snp.leading).offset(-10)
        }

        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(songTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(songTitleLabel)
            make.trailing.equalTo(songTitleLabel)
        }

        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(albumImageView)
            make.trailing.equalToSuperview().offset(-40)
            make.width.height.equalTo(30)
        }
        overlappingSquaresView.snp.makeConstraints{make in
            make.centerY.equalTo(albumImageView)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(30)
        }
        
        
        bottomLine.snp.makeConstraints {make in
            make.top.equalTo(albumImageView.snp.bottom).offset(10)
            
            
        }
        tabBar.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
       
        trackCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

