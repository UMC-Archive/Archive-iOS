//
//  RecapCollectionViewViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class RecapCollectionViewViewController: UIViewController {
    private let rootView = RecentMusicView()
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
    }
    
    @objc func backButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecapCollectionViewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecapCollectionViewVerticalCell.recapCollectionViewVerticalCellIdentifier,
            for: indexPath
        ) as? RecapCollectionViewVerticalCell else {
            fatalError("Failed to dequeue RecapCollectionViewVerticalCell")
        }
        cell.config(image: responseData?[indexPath.row].image ?? "CDSample", songName: responseData?[indexPath.row].title ?? "", artist: responseData?[indexPath.row].artists ?? "", year: responseData?[indexPath.row].releaseYear ?? 0)
        
       return cell
    }
}
