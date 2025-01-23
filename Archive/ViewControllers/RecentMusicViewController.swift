//
//  RecentMusicViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class RecentMusicViewController: UIViewController {
    private let rootView = RecentMusicView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = rootView
        view.backgroundColor = .white
        setDataSource()
        controlTapped()
    }
    
    private func setDataSource(){
        rootView.collectionView.dataSource = self
    }
    
    private func controlTapped(){
        rootView.navigationView.popButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecentMusicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GenreModel.dummy().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCollectionViewCell.genreCollectionViewIdentifier,
            for: indexPath
        ) as? GenreCollectionViewCell else {
            fatalError("Failed to dequeue genreCollectionViewCell")
        }
        let dummy = GenreModel.dummy()
        
        cell.config(image: dummy[indexPath.row].albumImage, songName: dummy[indexPath.row].songName, artist: dummy[indexPath.row].artist, year: dummy[indexPath.row].year)
        
       return cell
    }
}
