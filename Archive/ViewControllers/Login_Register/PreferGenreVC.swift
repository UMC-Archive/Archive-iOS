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
        updateNextButtonState()
    }
    private func updateNextButtonState() {
        let isEnabled = selectedGenres.count >= 3
        
        preferGenreView.nextButton.isEnabled = true
    }
    @objc private func leftButtonTapped(){
        print("눌림!")
        let moveVC = ProfileSelectVC()
        navigationController?.pushViewController(moveVC,animated: true)
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
        preferGenreView.leftArrowButton.addTarget(self,action: #selector(leftButtonTapped),for: .touchUpInside)
  
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func handleNext() {
        if selectedGenres.count < 3 {
               showAlert(message: "장르를 3개 이상 선택해주세요.")
               return
           }
           
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
            updateNextButtonState()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row < selectedGenres.count {
            let genre = selectedGenres.remove(at: indexPath.row)
            allGenres.insert(genre, at: 0)
            collectionView.reloadData()
            updateNextButtonState()
        }
    }
}
