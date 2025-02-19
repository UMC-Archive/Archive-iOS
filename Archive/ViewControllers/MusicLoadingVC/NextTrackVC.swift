import UIKit
import Kingfisher

class NextTrackVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private let nextTrackView = NextTrackView()
    
    // API 연결 tracks
    private let albumService = AlbumService()
    
    private let musicService = MusicService()
    private var tracks: [SelectionResponseDTO] = []

    override func loadView() {
        view = nextTrackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupCollectionView()
        fetchNextTrack()
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
        cell.configure(dto: track)


        return cell
    }
    
        private func setupActions() {
            nextTrackView.tabBar.addTarget(self, action: #selector(tabBarValueChanged(_:)), for: .valueChanged)
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
//         navigationController?.pushViewController(lyricsVC, animated: true)
        present(lyricsVC, animated: true)
    }

    @objc private func goToRecommend() {
        print("추천 콘텐츠 화면으로 이동")
        // 추천 콘텐츠 뷰로 이동하는 로직
        let recommendVC = RecommendVC()
         navigationController?.pushViewController(recommendVC, animated: true)
    }


    private func setupCollectionView() {
        nextTrackView.trackCollectionView.delegate = self
        nextTrackView.trackCollectionView.dataSource = self
        nextTrackView.trackCollectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)
    }
    
    //  public func selection(completion: @escaping (Result<[SelectionResponseDTO]?, NetworkError>) -> Void){
    //  requestOptional(target: .selection, decodingType: [SelectionResponseDTO].self, completion: completion)
    //}
    
    
    private func fetchNextTrack(){
        musicService.selection{ [weak self] (result:
                                                Result<[SelectionResponseDTO]?, NetworkError>) in
            switch result {
            case .success(let selectionResponseDTO):
                guard let data = selectionResponseDTO else { return }
                
                // API 응답 데이터를 Track에 저장
                self?.tracks = data


                DispatchQueue.main.async{
                    self?.nextTrackView.trackCollectionView.reloadData()
                }
            case.failure(let error):
                print("error")
                
            }
            
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
        let touchView = UIView()
        
        private let moreButton : UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "etc"), for: .normal)
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
            contentView.addSubview(touchView)
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
            touchView.snp.makeConstraints{
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.equalTo(moreButton.snp.leading)
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
            let music = dto.music
                titleLabel.text = music.title
                detailLabel.text = "\(dto.artist) · \(music.releaseTime.prefixBeforeDash())"
                albumImageView.kf.setImage(with: URL(string: music.image))
        }

    }
    
}
