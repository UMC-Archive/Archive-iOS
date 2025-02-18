//
//  PreferGenreVC.swift
//  Archive
//

import UIKit
import Foundation

class PreferGenreVC: UIViewController {

    private let preferGenreView = PreferGenreView()
    private var selectedGenres: [ChooseGenreResponseDTO] = [] // 선택된 장르 목록
    private var allGenres: [ChooseGenreResponseDTO] = [] // 서버에서 받아온 장르 목록
    private let musicService = MusicService() // 음악 서비스 추가

    override func loadView() {
        self.view = preferGenreView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupCollectionView()
        setupActions()
        fetchGenres()
    }

    //  서버에서 장르 정보 가져오기
    private func fetchGenres() {
        musicService.chooseGenreInfo { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let genres):
                    if let genres = genres {
                        self.allGenres = genres
                        self.preferGenreView.GenreCollectionView.reloadData() // UI 갱신
                    }
                case .failure(let error):
                    print("장르 정보를 불러오는데 실패했습니다: \(error)")
                }
            }
        }
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
        print("Selected Genres: \(selectedGenres.map { $0.name })")
        UserSignupData.shared.selectedGenres = selectedGenres.compactMap { Int($0.id) } // ID만 저장
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

        let genre: ChooseGenreResponseDTO
        let isSelected: Bool

        if indexPath.row < selectedGenres.count {
            genre = selectedGenres[indexPath.row]
            isSelected = true
        } else {
            genre = allGenres[indexPath.row - selectedGenres.count]
            isSelected = false
        }

        cell.configure(imageURL: genre.image, name: genre.name, isSelected: isSelected)
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

class GenreCell: UICollectionViewCell {
    static let identifier = "GenreCell"
    private static var imageCache = NSCache<NSString, UIImage>() // 이미지 캐시

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

    func configure(imageURL: String, name: String, isSelected: Bool) {
        genreNameLabel.text = name
        overlayView.isHidden = isSelected

        if let cachedImage = GenreCell.imageCache.object(forKey: imageURL as NSString) {
            //  캐시된 이미지가 있으면 사용
            genreImageView.image = cachedImage
        } else {
            // 캐시된 이미지가 없으면 URL에서 다운로드
            downloadImage(from: imageURL)
        }
    }

    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print(" 잘못된 이미지 URL: \(urlString)")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                print(" 이미지 다운로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }

            //  이미지 캐시에 저장
            GenreCell.imageCache.setObject(image, forKey: urlString as NSString)

            DispatchQueue.main.async {
                self.genreImageView.image = image
            }
        }
        task.resume()
    }
}
