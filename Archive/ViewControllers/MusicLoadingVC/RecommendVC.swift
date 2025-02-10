import UIKit

class RecommendVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private let recommendView = RecommendView()
    
    private let recommendedAlbums: [(image: String, title: String, artist: String)] = [
        ("album1", "NewJeans 2nd EP", "NewJeans"),
        ("album2", "NewJeans 1st EP", "NewJeans"),
        ("album3", "NewJeans Special", "NewJeans")
    ]
    private let tracks: [(image: String, title: String, artist: String, year: String)] = [
        ("aespa", "How Sweet", "NewJeans", "2024"),
        ("aespa","Attention", "NewJeans", "2022"),
        ("aespa","Ditto", "NewJeans", "2022"),
        ("aespa","OMG", "NewJeans", "2023"),
        ("aespa","ETA", "NewJeans", "2023"),
        
    ]
    override func loadView() {
        self.view = recommendView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
      
        recommendView.configure(
            albumImage: UIImage(named: "aespa"),
            songTitle: "NOW OR NEVER",
            artistName: "ZERO BASE ONE"
        )
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
            cell.configure(imageName: track.image, title: track.title, artist: track.artist)
            return cell
        } else if collectionView == recommendView.albumRecommendCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else {
                fatalError("Unable to dequeue AlbumCell")
            }
            let album = recommendedAlbums[indexPath.item]
            cell.configure(imageName: album.image, title: album.title, artist: album.artist)
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
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        
        func configure(imageName: String, title: String, artist: String) {
            albumImageView.image = UIImage(named: imageName)
            titleLabel.text = title
            artistLabel.text = artist
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
        
        func configure(imageName: String, title: String, artist: String) {
            albumImageView.image = UIImage(named: imageName) // 전달된 이미지 이름으로 설정
            titleLabel.text = title // 전달된 제목 설정
            artistLabel.text = artist // 전달된 아티스트 설정
        }

    }
    
}
