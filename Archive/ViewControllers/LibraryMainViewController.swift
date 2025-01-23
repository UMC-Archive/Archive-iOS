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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = rootView
        rootView.backgroundColor = .black
        
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
        rootView.genreCollectionView.dataSource = self
        rootView.artistCollectionView.dataSource = self
    }
    
    private func setupActions() {
        rootView.librarySegmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        segmentIndexNum = rootView.librarySegmentControl.selectedSegmentIndex
        let underbarWidth = rootView.librarySegmentControl.frame.width / 5
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
        rootView.genreCollectionView.isHidden = true
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
               rootView.genreCollectionView.isHidden = false
           case 4:
               rootView.artistCollectionView.isHidden = false
           default:
               break
           }
           rootView.layoutIfNeeded()
       }
}

extension LibraryMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case rootView.playlistCollectionView:
            return PlayListDummy.dummy().count
            
        case rootView.songCollectionView:
            return SongCollectionViewModel.dummy().count
            
        case rootView.albumCollectionView:
            return AlbumModel.dummy().count
            
        case rootView.genreCollectionView:
            return GenreModel.dummy().count
            
        case rootView.artistCollectionView:
            return ArtistModel.dummy().count
            
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
            let dummy = SongCollectionViewModel.dummy()
            cell.config(
                image: dummy[indexPath.row].albumImage,
                songName: dummy[indexPath.row].songName,
                artist: dummy[indexPath.row].artist,
                year: dummy[indexPath.row].year
            )
            return cell
            
        case rootView.albumCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AlbumCollectionViewCell.albumCollectionViewIdentifier,
                for: indexPath
            ) as? AlbumCollectionViewCell else {
                fatalError("Failed to dequeue albumCollectionViewCell")
            }
            let dummy = AlbumModel.dummy()
            cell.config(
                image: dummy[indexPath.row].albumImage,
                albumName: dummy[indexPath.row].albumName
            )
            return cell
            
        case rootView.genreCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GenreCollectionViewCell.genreCollectionViewIdentifier,
                for: indexPath
            ) as? GenreCollectionViewCell else {
                fatalError("Failed to dequeue genreCollectionViewCell")
            }
            let dummy = GenreModel.dummy()
            cell.config(
                image: dummy[indexPath.row].albumImage,
                songName: dummy[indexPath.row].songName,
                artist: dummy[indexPath.row].artist,
                year: dummy[indexPath.row].year
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
            cell.config(
                image: dummy[indexPath.row].albumImage,
                artistName: dummy[indexPath.row].artist
            )
            return cell
        default:
            fatalError("Unknown UICollectionView")
        }
    }
}


