import UIKit

class LyricsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let lyricsView = LyricsView() // LyricsView 추가
    private let musiceservice = MusicService()
    
    private let lyrics: [String] = [
        "Stormy night", "Stormy night", "Stormy night", "Stormy night", "Stormy night",
        "Cloudy sky", "In a moment you and I", "One more chance", "너와 나 다시 한 번 만나게",
        "서로에게 향하게", "My feeling’s getting deeper", "내 심박수를 믿어",
        "우리 인연은 깊어", "우리 인연은 깊어", "우리 인연은 깊어", "우리 인연은 깊어"
    ]

    override func loadView() {
        self.view = lyricsView // LyricsView를 메인 뷰로 설정
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupCollectionView()
    }
    private func setupActions() {
        lyricsView.tabBar.addTarget(self, action: #selector(tabBarValueChanged(_:)), for: .valueChanged)
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

    private func setupCollectionView() {
        lyricsView.lyricsCollectionView.delegate = self
        lyricsView.lyricsCollectionView.dataSource = self
        lyricsView.lyricsCollectionView.register(LyricsCell.self, forCellWithReuseIdentifier: LyricsCell.identifier)
    }

    // MARK: - UICollectionViewDelegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lyrics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LyricsCell.identifier, for: indexPath) as? LyricsCell else {
            fatalError("Unable to dequeue LyricsCell")
        }

        let lyric = lyrics[indexPath.item]
        let isHighlighted = indexPath.item == lyrics.count / 2 // 가운데 셀 하이라이트
        cell.configure(text: lyric, isHighlighted: isHighlighted)
        return cell
    }
}

// MARK: - LyricsCell
class LyricsCell: UICollectionViewCell {
    static let identifier = "LyricsCell"

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.label.text = nil
    }
    
    func configure(text: String, isHighlighted: Bool) {
        label.text = text
        label.textColor = isHighlighted ? .white : .lightGray
        label.font = isHighlighted ? UIFont.boldSystemFont(ofSize: 18) : UIFont.systemFont(ofSize: 16)
    }
}
