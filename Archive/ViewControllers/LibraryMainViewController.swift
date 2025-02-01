//
//  LibraryMainViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/9/25.
//

import UIKit

class LibraryMainViewController: UIViewController {
    let rootView = LibraryMainView()
    
    private var segmentIndexNum: Int = 0
    private let libraryService = LibraryService()
    private var musicResponse: [LibraryMusicResponseDTO]?
    private var artistResponse : [LibraryArtistResponseDTO]?
    private var albumResponse : [LibraryAlbumResponseDTO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = rootView
        rootView.backgroundColor = .black
        self.navigationController?.navigationBar.isHidden = true
        datasourceSetting()
        hideAllCollectionViews()
        setupActions()
        showCollectionView(for: segmentIndexNum)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ㅣㅣㅣView has disappeared")
    }
    private func datasourceSetting() {
        rootView.playlistCollectionView.dataSource = self
        rootView.songCollectionView.dataSource = self
        rootView.albumCollectionView.dataSource = self
        rootView.artistCollectionView.dataSource = self
    }
    
    private func setupActions() {
        rootView.librarySegmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exploreIconTapped))
        rootView.exploreIcon.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.exploreIcon.addGestureRecognizer(tapGesture)
    }
    @objc func exploreIconTapped(){
        let viewController = DatePickerViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @objc private func segmentChanged() {
        segmentIndexNum = rootView.librarySegmentControl.selectedSegmentIndex
        let underbarWidth = rootView.librarySegmentControl.frame.width / 4
        let newLeading = CGFloat(segmentIndexNum) * underbarWidth
        
        
        // 언더바 이동 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.rootView.selectedUnderbar.snp.updateConstraints {
                $0.leading.equalTo(self.rootView.librarySegmentControl.snp.leading).offset(newLeading)
                $0.width.equalTo(underbarWidth)
            }
            print(self.segmentIndexNum)
            self.rootView.layoutIfNeeded()
        })
        hideAllCollectionViews()
        showCollectionView(for: segmentIndexNum)
    }
    
    private func hideAllCollectionViews() {
        rootView.playlistCollectionView.isHidden = true
        rootView.songCollectionView.isHidden = true
        rootView.albumCollectionView.isHidden = true
        rootView.artistCollectionView.isHidden = true
    }
    
    private func showCollectionView(for index: Int) {
           switch index {
           case 0:
               rootView.playlistCollectionView.isHidden = false
           case 1:
               rootView.songCollectionView.isHidden = false
           case 2:
               rootView.albumCollectionView.isHidden = false
           case 3:
               rootView.artistCollectionView.isHidden = false
           default:
               break
           }
           rootView.layoutIfNeeded()
       }
    func getMusicInfo(){
        libraryService.libraryMusicInfo(){[weak self] result in
            guard let self = self else { return }
            
            switch result {
                        // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
            case .success(let response): // response는 AlbumInfoReponseDTO 타입
                print("libraryMusic 성공 ")
                Task{
                    self.musicResponse = response
                    self.rootView.songCollectionView.reloadData()
                }
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description) // 얼럿 생성
                self.present(alert, animated: true) // 얼럿 띄우기
                print("실패: \(error.description)")
            }
        }
    }
    func getArtistInfo(){
        libraryService.libraryArtistInfo(){[weak self] result in
            guard let self = self else { return }
            
            switch result {
                        // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
            case .success(let response): // response는 AlbumInfoReponseDTO 타입
                print("libraryAtrist성공 ")
                Task{
                    self.artistResponse = response
                    self.rootView.artistCollectionView.reloadData()
                }
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description) // 얼럿 생성
                self.present(alert, animated: true) // 얼럿 띄우기
                print("실패: \(error.description)")
            }
        }
    }
    func getAlbumInfo(){
        libraryService.libraryAlbumInfo(){[weak self] result in
            guard let self = self else { return }
            
            switch result {
                        // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
            case .success(let response): // response는 AlbumInfoReponseDTO 타입
                print("libraryAlbum성공 ")
                           
                Task{
                    self.albumResponse = response
                    self.rootView.albumCollectionView.reloadData()
                }
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description) // 얼럿 생성
                self.present(alert, animated: true) // 얼럿 띄우기
                print("실패: \(error.description)")
            }
        }
    }
}

extension LibraryMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case rootView.playlistCollectionView:
            return PlayListDummy.dummy().count
            
        case rootView.songCollectionView:
            getMusicInfo()
            return musicResponse?.count ?? 0
            
        case rootView.albumCollectionView:
            getAlbumInfo()
            return albumResponse?.count ?? 0
            
            
        case rootView.artistCollectionView:
            getArtistInfo()
            return artistResponse?.count ?? 0
            
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case rootView.playlistCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlayListCollectionViewCell.playListCollectionViewIdentifier,
                for: indexPath
            ) as? PlayListCollectionViewCell else {
                fatalError("Failed to dequeue PlayListCollectionViewCell")
            }
            let dummy = PlayListDummy.dummy()
            cell.config(image: dummy[indexPath.row].albumImage)
            return cell

        case rootView.songCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LibrarySongCollectionViewCell.librarySongCollectionViewIdentifier,
                for: indexPath
            ) as? LibrarySongCollectionViewCell else {
                fatalError("Failed to dequeue LibrarySongCollectionViewCell")
            }
//            let dummy = SongCollectionViewModel.dummy()
//            cell.config(
//                image: dummy[indexPath.row].albumImage,
//                songName: dummy[indexPath.row].songName,
//                artist: dummy[indexPath.row].artist,
//                year: dummy[indexPath.row].year
//            )
            cell.config(
                imageUrl: musicResponse?[indexPath.row].image ?? "",
                songName: musicResponse?[indexPath.row].title ?? "",
                artist: musicResponse?[indexPath.row].artist ?? "",
                year: String(musicResponse?[indexPath.row].releaseTime ?? 0 ) ?? ""
            )

            return cell
            
        case rootView.albumCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AlbumCollectionViewCell.albumCollectionViewIdentifier,
                for: indexPath
            ) as? AlbumCollectionViewCell else {
                fatalError("Failed to dequeue albumCollectionViewCell")
            }
//            let dummy = AlbumModel.dummy()
//            cell.config(
//                image: dummy[indexPath.row].albumImage,
//                albumName: dummy[indexPath.row].albumName
//            )
            cell.config(
                image: albumResponse?[indexPath.row].image ?? "",
                albumName: albumResponse?[indexPath.row].title ?? "",
                artist: albumResponse?[indexPath.row].artist ?? ""
                
            )
            return cell
            
        case rootView.artistCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArtistCollectionViewCell.artistCollectionViewIdentifier,
                for: indexPath
            ) as? ArtistCollectionViewCell else {
                fatalError("Failed to dequeue genreCollectionViewCell")
            }
            let dummy = GenreModel.dummy()
//            cell.config(
//                image: dummy[indexPath.row].albumImage,
//                artistName: dummy[indexPath.row].artist
//            )
            cell.config(
                image: artistResponse?[indexPath.row].image ?? "",
                artistName: artistResponse?[indexPath.row].name ?? ""
            )
            return cell
        default:
            fatalError("Unknown UICollectionView")
        }
    }
}


