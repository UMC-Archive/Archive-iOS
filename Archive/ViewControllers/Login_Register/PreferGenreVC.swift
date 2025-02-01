//
//  PreferGenreVC.swift
//  Archive
//

import UIKit

class PreferGenreVC: UIViewController {

    private let preferGenreView = PreferGenreView()
    private var selectedGenres: [String] = [] // 선택된 장르 목록
    private var allGenres = ["Pop", "Hip-Hop", "Jazz", "Rock", "Classical", "EDM", "R&B", "Indie"]

    override func loadView() {
        self.view = preferGenreView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActions()
    }

    // UICollectionView 설정
    private func setupCollectionView() {
        preferGenreView.GenreCollectionView.delegate = self
        preferGenreView.GenreCollectionView.dataSource = self
        preferGenreView.GenreCollectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        preferGenreView.GenreCollectionView.allowsMultipleSelection = true
    }

    // 버튼 액션 설정
    private func setupActions() {
        preferGenreView.nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
    }

    @objc private func handleNext() {
        print("Selected Genres: \(selectedGenres)")
        // 다음 화면 전환
        UserSignupData.shared.selectedGenres = selectedGenres
        let preferArtistVC = PreferArtistVC()
        navigationController?.pushViewController(preferArtistVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PreferGenreVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedGenres.count + allGenres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.identifier, for: indexPath) as? GenreCell else {
            fatalError("Unable to dequeue GenreCell")
        }

        let genreName: String
        let isSelected: Bool

        if indexPath.row < selectedGenres.count {
            genreName = selectedGenres[indexPath.row]
            isSelected = true
        } else {
            genreName = allGenres[indexPath.row - selectedGenres.count]
            isSelected = false
        }

        cell.configure(imageName: genreName, name: genreName, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= selectedGenres.count {
            let genre = allGenres.remove(at: indexPath.row - selectedGenres.count)
            selectedGenres.insert(genre, at: 0)
            collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row < selectedGenres.count {
            let genre = selectedGenres.remove(at: indexPath.row)
            allGenres.insert(genre, at: 0)
            collectionView.reloadData()
        }
    }
}

// MARK: - GenreCell
class GenreCell: UICollectionViewCell {
    static let identifier = "GenreCell"

    private var genreImageView = UIImageView().then { make in
        make.contentMode = .scaleAspectFill
        make.layer.cornerRadius = 12 // 모서리 둥글게
        make.clipsToBounds = true
    }

    private var genreNameLabel = UILabel().then { make in
        make.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        make.textColor = .white
        make.textAlignment = .center
    }

    private var overlayView = UIView().then { make in
        make.backgroundColor = UIColor(white: 0, alpha: 0.4) // 어둡게 보이는 오버레이
        make.isHidden = true // 기본적으로 숨김
        make.layer.cornerRadius = 12
        make.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(genreImageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(genreNameLabel)
    }

    private func setupConstraints() {
        genreImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        genreNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            genreImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            genreImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genreImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            genreImageView.heightAnchor.constraint(equalToConstant: 100),

            overlayView.topAnchor.constraint(equalTo: genreImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: genreImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: genreImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: genreImageView.bottomAnchor),

            genreNameLabel.topAnchor.constraint(equalTo: genreImageView.bottomAnchor, constant: 5),
            genreNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genreNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(imageName: String, name: String, isSelected: Bool) {
        genreImageView.image = UIImage(named: imageName)
        genreNameLabel.text = name

        // 선택되지 않은 상태에서는 어두운 오버레이를 보이게
        overlayView.isHidden = isSelected
    }
}

