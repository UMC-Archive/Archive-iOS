import UIKit

class LyricsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let lyricsView = LyricsView() // LyricsView 추가
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

        setupCollectionView()
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

    func configure(text: String, isHighlighted: Bool) {
        label.text = text
        label.textColor = isHighlighted ? .white : .lightGray
        label.font = isHighlighted ? UIFont.boldSystemFont(ofSize: 18) : UIFont.systemFont(ofSize: 16)
    }
} 
