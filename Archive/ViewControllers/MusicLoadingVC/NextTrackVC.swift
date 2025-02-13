import UIKit

class NextTrackVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private let nextTrackView = NextTrackView()
    
    // API 연결 tracks 
    private let albumService = AlbumService()
    
    
    private let tracks: [(title: String, artist: String, year: String)] = [
        ("How Sweet", "NewJeans", "2024"),
        ("Attention", "NewJeans", "2022"),
        ("Ditto", "NewJeans", "2022"),
        ("OMG", "NewJeans", "2023"),
        ("ETA", "NewJeans", "2023"),
        ("Cool with you", "NewJeans", "2023"),
        ("Super Shy", "NewJeans", "2023")
    ]

    override func loadView() {
        view = nextTrackView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        nextTrackView.trackCollectionView.delegate = self
        nextTrackView.trackCollectionView.dataSource = self
        nextTrackView.trackCollectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)
    }

    // MARK: - UICollectionViewDelegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.identifier, for: indexPath) as? TrackCell else {
            fatalError("Unable to dequeue TrackCell")
        }
        let track = tracks[indexPath.item]
        cell.configure(title: track.title, artist: track.artist, year: track.year)
        return cell
    }
}



class TrackCell: UICollectionViewCell {
    static let identifier = "TrackCell"

    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(named: "placeholder") // 기본 이미지
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let moreButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .white
        return button
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
    
        contentView.addSubview(albumImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(moreButton)
    }

    private func setupConstraints() {
        // 앨범 이미지
        albumImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }

        // 제목
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumImageView.snp.trailing).offset(12)
            make.top.equalTo(albumImageView.snp.top).offset(2)
            make.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-8)
        }

        // 아티스트와 연도
        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumImageView.snp.trailing).offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-8)
        }

        // 점 세 개 버튼
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }


    func configure(title: String, artist: String, year: String) {
        titleLabel.text = title
        detailLabel.text = "\(artist) • \(year)"
    }
}

