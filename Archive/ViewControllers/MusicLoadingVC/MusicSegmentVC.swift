import UIKit
import Kingfisher

class MusicSegmentVC: UIViewController {

    private let segmentView = MusicSegmentView()
    private let musicService = MusicService()
    private let albumService = AlbumService()
    public var segmentIndexNum: Int

    private var lyrics: [String] = []
    private var nextTracks: [SelectionResponseDTO] = []
    private var recommendAlbums: [AlbumRecommendAlbumResponseDTO] = []
    private var recommendMusic: [RecommendMusicResponseDTO] = []

    override func loadView() {
        self.view = segmentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentActions()
        setupCollectionView()
        setupInitialView(index: segmentIndexNum)

        fetchLyrics()
        fetchNextTracks()
        fetchRecommendAlbums()
        fetchRecommendMusic()
        print(segmentIndexNum)
    }
    init(segmentIndexNum: Int) {
        self.segmentIndexNum = segmentIndexNum
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSegmentActions() {
        segmentView.tabBar.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    @objc private func segmentChanged() {
        var index = segmentView.tabBar.selectedSegmentIndex

        let underbarWidth = segmentView.tabBar.frame.width / 3
        let newLeading = CGFloat(index) * underbarWidth
        
        
        // 언더바 이동 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.segmentView.selectedUnderbar.snp.updateConstraints {
                $0.leading.equalTo(self.segmentView.tabBar.snp.leading).offset(newLeading)
                $0.width.equalTo(underbarWidth)
            }
            print(self.segmentIndexNum)
            self.segmentView.layoutIfNeeded()
        })
        setupInitialView(index: index)

    }


    private func setupInitialView(index: Int) {
        var index = index
        switch index {
        case 0:
            segmentView.nextTrackCollectionView.isHidden = false
            segmentView.lyricsCollectionView.isHidden = true
            segmentView.recommendContentView.isHidden = true
        case 1:
            segmentView.nextTrackCollectionView.isHidden = true
            segmentView.lyricsCollectionView.isHidden = false
            segmentView.recommendContentView.isHidden = true
        case 2:
            segmentView.nextTrackCollectionView.isHidden = true
            segmentView.lyricsCollectionView.isHidden = true
            segmentView.recommendContentView.isHidden = false
        default:
            break
        }
    }

    private func setupCollectionView() {
        segmentView.nextTrackCollectionView.delegate = self
        segmentView.nextTrackCollectionView.dataSource = self
        segmentView.nextTrackCollectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)

        segmentView.lyricsCollectionView.delegate = self
        segmentView.lyricsCollectionView.dataSource = self
        segmentView.lyricsCollectionView.register(LyricsCell.self, forCellWithReuseIdentifier: LyricsCell.identifier)

        segmentView.albumCollectionView.delegate = self
        segmentView.albumCollectionView.dataSource = self
        segmentView.albumCollectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)

        segmentView.albumRecommendCollectionView.delegate = self
        segmentView.albumRecommendCollectionView.dataSource = self
        segmentView.albumRecommendCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.identifier)
    }

    private func fetchLyrics() {
        lyrics = [
            "Stormy night", "Stormy night", "Stormy night",
            "Cloudy sky", "In a moment you and I", "One more chance",
            "너와 나 다시 한 번 만나게", "서로에게 향하게", "My feeling’s getting deeper"
        ]
        segmentView.lyricsCollectionView.reloadData()
    }

    private func fetchNextTracks() {
        musicService.selection { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                self?.nextTracks = data
                DispatchQueue.main.async {
                    self?.segmentView.nextTrackCollectionView.reloadData()
                }
            case .failure(let error):
                print("다음 트랙 에러: \(error)")
            }
        }
    }

    private func fetchRecommendAlbums() {
        albumService.albumRecommendAlbum { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                self?.recommendAlbums = data
                DispatchQueue.main.async {
                    self?.segmentView.albumCollectionView.reloadData()
                }
            case .failure(let error):
                print("추천 앨범 에러: \(error)")
            }
        }
    }

    private func fetchRecommendMusic() {
        musicService.homeRecommendMusic { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                self?.recommendMusic = data
                DispatchQueue.main.async {
                    self?.segmentView.albumRecommendCollectionView.reloadData()
                }
            case .failure(let error):
                print("추천 음악 에러: \(error)")
            }
        }
    }
}

extension MusicSegmentVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == segmentView.nextTrackCollectionView {
            return nextTracks.count
        } else if collectionView == segmentView.lyricsCollectionView {
            return lyrics.count
        } else if collectionView == segmentView.albumCollectionView {
            return recommendAlbums.count
        } else if collectionView == segmentView.albumRecommendCollectionView {
            return recommendMusic.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == segmentView.nextTrackCollectionView || collectionView == segmentView.albumCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.identifier, for: indexPath) as? TrackCell else {
                fatalError("TrackCell 에러")
            }
            if collectionView == segmentView.nextTrackCollectionView {
                let trackData = nextTracks[indexPath.item]
                cell.configure(dto: trackData)
            } else {
                let trackData = recommendAlbums[indexPath.item]
                cell.configure(dto: trackData)
            }

            return cell

        } else if collectionView == segmentView.lyricsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LyricsCell.identifier, for: indexPath) as? LyricsCell else {
                fatalError("LyricsCell 에러")
            }
            let isHighlighted = indexPath.item == lyrics.count / 2
            cell.configure(text: lyrics[indexPath.item], isHighlighted: isHighlighted)
            return cell

        } else if collectionView == segmentView.albumRecommendCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else {
                fatalError("AlbumCell 에러")
            }
            cell.configure(dto: recommendMusic[indexPath.item])
            return cell
        }

        return UICollectionViewCell()
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
        label.font = UIFont.systemFont(ofSize: 13)
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
    
    
    func configure(dto: SelectionResponseDTO) {
        titleLabel.text = dto.music.title
        detailLabel.text = "\(dto.artist) · \(dto.music.releaseTime.prefixBeforeDash())"
        albumImageView.kf.setImage(with: URL(string: dto.music.image))
    }

    func configure(dto: AlbumRecommendAlbumResponseDTO) {
        titleLabel.text = dto.album.title
        detailLabel.text = "\(dto.artist) · \(dto.album.releaseTime.prefixBeforeDash())"
        albumImageView.kf.setImage(with: URL(string: dto.album.image))
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


