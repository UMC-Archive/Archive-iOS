//
//  RecapCollectionViewViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class RecapCollectionViewViewController: UIViewController, UIGestureRecognizerDelegate {
    private let rootView = RecapCollectionViewView()
    private let libraryService = LibraryService()
    public var responseData: [RecapResponseDTO]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                print("📌 responseData 변경됨: \(self?.responseData?.count ?? 0)개") // 디버깅 로그
                self?.rootView.collectionView.reloadData()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = rootView
        view.backgroundColor = .white
        setDataSource()
        controlTapped()
        
//        rootView.collectionView.reloadData()
    }
    
    private func setDataSource(){
        rootView.collectionView.dataSource = self
    }
    
    private func controlTapped(){
        rootView.navigationView.popButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let overflowElseTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        overflowElseTapGesture.cancelsTouchesInView = false
        overflowElseTapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        rootView.addGestureRecognizer(overflowElseTapGesture)
    }
    @objc private func touchUpInsideOverflowButton(_ gesture: UITapGestureRecognizer) {
        print("---")
        
        switch gesture.view?.superview {
        case let cell as GenreCollectionViewCell:
            // 첫 번째 superview로 셀 찾기
            cell.overflowView.isHidden.toggle()
        default:
            break
        }
    }
    // overflow 버튼 영역 외부 터치 실행될 메서드
    @objc private func dismissOverflowView(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: rootView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in rootView.collectionView.visibleCells {
            if let verticalCell = cell as? GenreCollectionViewCell {
                if !verticalCell.overflowView.frame.contains(touchLocation) {
                    verticalCell.overflowView.isHidden = true
                }
            }
        }
    }

    
    @objc func backButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func goToLibrary(_ sender: CustomTapGesture) {
        guard let musicId = sender.musicId else {
            print("nil")
            return }
        print("-------musicId\(musicId)")
        
        libraryService.musicPost(musicId: musicId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("postMusicInfo() 성공")
                print(response)
                Task{
                    print("-----------------musicPost 성공")
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                print("-----------fail")
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    // 노래 재생 제스처
    @objc private func musicPlayingGesture(_ sender: CustomTapGesture) {
        guard let musicId = sender.musicId,
              let musicTitle = sender.musicTitle,
              let musicImageURL = sender.musicImageURL,
              let artist = sender.artist
        else { return }
        
        KeychainService.shared.save(account: .musicInfo, service: .musicId, value: musicId)
        KeychainService.shared.save(account: .musicInfo, service: .musicTitle, value: musicTitle)
        KeychainService.shared.save(account: .musicInfo, service: .musicImageURL, value: musicImageURL)
        KeychainService.shared.save(account: .musicInfo, service: .artist, value: artist)
        (self.tabBarController as? TabBarViewController)?.setFloatingView()
    }
    // 아티스트 버튼
    @objc private func tapArtistLabelGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else {return }
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    // 앨범 버튼
    @objc private func tapGoToAlbumGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        print("TapAlbumImageGesture: \(album), \(artist)")
        let nextVC = AlbumViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension RecapCollectionViewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCollectionViewCell.genreCollectionViewIdentifier,
            for: indexPath
        ) as? GenreCollectionViewCell else {
            fatalError("Failed to dequeue GenreCollectionViewCell")
        }
        cell.config(image: responseData?[indexPath.row].image ?? "CDSample", songName: responseData?[indexPath.row].title ?? "", artist: responseData?[indexPath.row].artists ?? "", year: responseData?[indexPath.row].releaseYear ?? 0)
        
        let songEtcTapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpInsideOverflowButton(_:)))
        cell.etcImage.addGestureRecognizer(songEtcTapGesture)
        songEtcTapGesture.delegate = self
        cell.etcImage.isUserInteractionEnabled = true
        cell.setOverflowView(type: .other)
        
        let songGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(goToLibrary))
        songGoToLibraryGesture.musicId = responseData?[indexPath.row].id ?? "0"
        cell.overflowView.libraryButton.addGestureRecognizer(songGoToLibraryGesture)
        
        // 앨범 으로 이동 제스처
        let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
        tapAlbumGesture.artist = responseData?[indexPath.row].artists
        tapAlbumGesture.album = responseData?[indexPath.row].albumTitle
        cell.overflowView.goToAlbumButton.isUserInteractionEnabled = true
        cell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
        
        // 노래 재생 제스처
        let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
        musicGesture.musicTitle = responseData?[indexPath.row].title
        musicGesture.musicId = responseData?[indexPath.row].id
        musicGesture.musicImageURL = responseData?[indexPath.row].image
        musicGesture.artist = responseData?[indexPath.row].artists
        cell.touchView.isUserInteractionEnabled = true
        cell.touchView.addGestureRecognizer(musicGesture)
        
        
        // 아티스트 탭 제스처
        let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
        tapArtistGesture.artist = responseData?[indexPath.row].artists
        tapArtistGesture.album = responseData?[indexPath.row].albumTitle
        cell.artistYearLabel.isUserInteractionEnabled = true
        cell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
        
        
        
        return cell
    }
}
