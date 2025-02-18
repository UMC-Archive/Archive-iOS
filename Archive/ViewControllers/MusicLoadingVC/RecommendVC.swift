import UIKit

class RecommendVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private let recommendView = RecommendView()
    
    // 네트워크 요청을 담당하는 서비스 객체 추가
        private let musicService = MusicService()
        private let albumService = AlbumService()
        //  API에서 가져온 트랙 리스트 (하드코딩 제거)
    private var tracks: [AlbumRecommendAlbumResponseDTO] = []
    private var recommendedAlbums: [RecommendMusicResponseDTO] = []


 //   private let recommendedAlbums: [(image: String, title: String, artist: String)] = [
   //     ("album1", "NewJeans 2nd EP", "NewJeans"),
     //   ("album2", "NewJeans 1st EP", "NewJeans"),
      //  ("album3", "NewJeans Special", "NewJeans")
    //]
   //  private let tracks: [(image: String, title: String, artist: String, year: /String)] = [
      //  ("aespa", "How Sweet", "NewJeans", "2024"),
       // ("aespa","Attention", "NewJeans", "2022"),
        //("aespa","Ditto", "NewJeans", "2022"),
       // ("aespa","OMG", "NewJeans", "2023"),
       // ("aespa","ETA", "NewJeans", "2023"),
        
   // ]

    override func loadView() {
        self.view = recommendView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        // 추천 음악 가져오기
        setupActions()
        fetchRecommendMusic()
        fetchNextTrackMusic()
        recommendView.configure(
            albumImage: "",
            songTitle: "NOW OR NEVER",
            artistName: "ZERO BASE ONE"
        )
    }
    private func setupActions() {
        recommendView.tabBar.addTarget(self, action: #selector(tabBarValueChanged(_:)), for: .valueChanged)
    }

@objc private func tabBarValueChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
        print("다음 트랙 선택됨")
        goToNextTrack()
    case 1:
        print("가사 선택됨")
        goToLyrics()
    case 2:
        print("추천 콘텐츠 선택됨")
        goToRecommend()
    default:
        break
    }
}
@objc private func goToNextTrack() {
    print("다음 트랙으로 이동")
    // 다음 트랙 로직 실행
    let nextTrackVC = NextTrackVC()
    navigationController?.pushViewController(nextTrackVC, animated: true)
    
}

@objc private func goToLyrics() {
    print("가사 화면으로 이동")
    // 가사 뷰로 이동하는 로직 (예: 새 화면 push, present 등)
    let lyricsVC = LyricsVC()
     navigationController?.pushViewController(lyricsVC, animated: true)
}

@objc private func goToRecommend() {
    print("추천 콘텐츠 화면으로 이동")
    // 추천 콘텐츠 뷰로 이동하는 로직
    let recommendVC = RecommendVC()
     navigationController?.pushViewController(recommendVC, animated: true)
}

    private func fetchRecommendMusic() {
        musicService.homeRecommendMusic { [weak self] (result: Result<[RecommendMusicResponseDTO]?, NetworkError>) in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                
                // API 응답 데이터를 recommendedAlbums에 저장
                self?.recommendedAlbums = data

                // UI 업데이트 (메인 스레드에서 실행)
                DispatchQueue.main.async {
                    self?.recommendView.albumRecommendCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("❌ 추천 음악 API 오류: \(error)")
            }
        }
    }
// 다음 트랙 넣어주는 부분 
    private func fetchNextTrackMusic() {
        albumService.albumRecommendAlbum { [weak self] (result: Result<[AlbumRecommendAlbumResponseDTO]?, NetworkError>) in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                self?.tracks = data

                DispatchQueue.main.async {
                    self?.recommendView.albumCollectionView.reloadData()
                }
            case .failure(let error):
                print("❌ 다음 트랙 API 오류: \(error)")
            }
        }
    }
    
    private func setupCollectionView() {
        // 첫 번째 컬렉션 뷰 - TrackCell 등록
        recommendView.albumCollectionView.delegate = self
        recommendView.albumCollectionView.dataSource = self
        recommendView.albumCollectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)

        // 두 번째 컬렉션 뷰 - AlbumCell 등록
        recommendView.albumRecommendCollectionView.delegate = self
        recommendView.albumRecommendCollectionView.dataSource = self
        recommendView.albumRecommendCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.identifier)
    }

    
    // MARK: - UICollectionViewDelegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == recommendView.albumCollectionView {
            return tracks.count
        } else if collectionView == recommendView.albumRecommendCollectionView {
            return recommendedAlbums.count
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recommendView.albumCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.identifier, for: indexPath) as? TrackCell else {
                fatalError("Unable to dequeue TrackCell")
            }
            
            let track = tracks[indexPath.item]
            cell.configure(dto: track)
            return cell
        } else if collectionView == recommendView.albumRecommendCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else {
                fatalError("Unable to dequeue AlbumCell")
            }
            let album = recommendedAlbums[indexPath.item]
            cell.configure(dto: album)
            return cell
        }
        return UICollectionViewCell()
    }

    
    class TrackCell: UICollectionViewCell {
        static let identifier = "TrackCell"
        
        private let albumImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            return imageView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.textColor = .white
            return label
        }()
        
        private let artistLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .gray
            return label
        }()
        
        private let moreButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "ellipsis"), for: .normal) // 점 세 개 아이콘
            button.tintColor = .white
            return button
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupViews() {
            contentView.addSubview(albumImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(artistLabel)
            contentView.addSubview(moreButton)
        }
        
        private func setupConstraints() {
            albumImageView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            artistLabel.translatesAutoresizingMaskIntoConstraints = false
            moreButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // 앨범 이미지
                albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                albumImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                albumImageView.widthAnchor.constraint(equalToConstant: 40),
                albumImageView.heightAnchor.constraint(equalToConstant: 40),
                
                // 노래 제목
                titleLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                
                // 아티스트 이름
                artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                artistLabel.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -10),
                
                // 점 세 개 버튼
                moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                moreButton.widthAnchor.constraint(equalToConstant: 30),
                moreButton.heightAnchor.constraint(equalToConstant: 30),
            ])
        }
        func configure(dto: AlbumRecommendAlbumResponseDTO) {
            let album = dto.album
            titleLabel.text = album.title
            artistLabel.text = "\(dto.artist) · \(album.releaseTime.prefixBeforeDash())"
            albumImageView.kf.setImage(with: URL(string: album.image))
        }


    }

    
    
    class AlbumCell: UICollectionViewCell {
        static let identifier = "AlbumCell"
        
        private let albumImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            return imageView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.textColor = .white
            label.numberOfLines = 2
            label.textAlignment = .center
            return label
        }()
        
        private let artistLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            label.textColor = .gray
            label.textAlignment = .center
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .clear
            setupViews()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupViews() {
            contentView.addSubview(albumImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(artistLabel)
        }
        
        private func setupConstraints() {
            albumImageView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            artistLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // 앨범 이미지
                albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                albumImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                albumImageView.heightAnchor.constraint(equalTo: albumImageView.widthAnchor), // 정사각형
                
                // 제목
                titleLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 5),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                
                // 아티스트
                artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
                artistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                artistLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
            ])
        }
        
        func configure(dto: RecommendMusicResponseDTO) {
            let music = dto.music
            titleLabel.text = music.title
            titleLabel.lineBreakMode = .byTruncatingTail // 말줄임표 설정
              titleLabel.numberOfLines = 1 // 한 줄만 표시

            artistLabel.text = dto.artist
            albumImageView.kf.setImage(with: URL(string: music.image))
        }


    }
    
}
