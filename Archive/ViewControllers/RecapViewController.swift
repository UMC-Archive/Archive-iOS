//
//  RecapViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/14/25.
//

import UIKit

class RecapViewController: UIViewController {
    private let dummyData = MusicDummyModel.dummy()
    let cellSize = CGSize(width: 258, height: 258)
    var minItemSpacing: CGFloat = 1
    let cellCount = 3
    var previousIndex = 0
    
    
    let gradient = CAGradientLayer()
    
    private let rootView = RecapView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = rootView
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        // 뷰가 로드된 직후 1번 인덱스로 이동
        DispatchQueue.main.async {
            let recapIndexPath = IndexPath(item: 1, section: 0)
            let genreIndexPath = IndexPath(item: 2, section: 0)
            self.rootView.recapCollectionView.scrollToItem(at: recapIndexPath, at: .centeredHorizontally, animated: false)
            self.rootView.genreCollectionView.scrollToItem(at: genreIndexPath, at: .centeredHorizontally, animated: false)
        }
        
        buildGradient()
        setDelegateAndDataSource()
        controlTapped()
        
        self.view.layoutIfNeeded()
        
    }
    
    private func controlTapped(){
        rootView.navigationView.popButton.addTarget(self, action: #selector(recapButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerButtonTapped))
        rootView.headerButton.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.headerButton.addGestureRecognizer(tapGesture)
        
    }
    @objc func recapButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func headerButtonTapped() {
        let viewController = RecapCollectionViewViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setDelegateAndDataSource() {
        rootView.recapCollectionView.dataSource = self
        rootView.recapCollectionView.delegate = self
        rootView.genreCollectionView.dataSource = self
        rootView.genreCollectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // rootView의 크기가 업데이트된 후 gradient의 프레임을 설정
        gradient.frame = rootView.CDView.bounds
    }
    
    func buildGradient() {
        
        gradient.type = .conic
        gradient.colors = [
            UIColor.dance_100?.cgColor ?? UIColor.red,
            UIColor.hiphop_100?.cgColor,
            UIColor.RnB_100?.cgColor,
            UIColor.dance_100?.cgColor
        ]
        gradient.locations = [0.0, 0.17, 0.5, 0.84, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5) // 중심점
        gradient.endPoint = CGPoint(x: 01.0, y: 1.0)   // conic 그라데이션은 중심을 공유
        
        
        rootView.CDView.layer.addSublayer(gradient)
    }
    
}

extension RecapViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case rootView.recapCollectionView :
            return 3
        case rootView.genreCollectionView :
            return 5
        case rootView.collectionView :
            return MusicDummyModel.dummy().count
        default :
            fatalError("Unknown collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case rootView.recapCollectionView:
            guard let cell = rootView.recapCollectionView.dequeueReusableCell(withReuseIdentifier: "recapCollectionViewIdentifier", for: indexPath) as? RecapCollectionViewCell else {
                fatalError("Failed to dequeue RecapCollectionViewCell")
            }
//            let dummy = RecapModel.dummy()
            cell.config(data: dummyData[indexPath.row])
//            if indexPath.row == 0{
////                cell.config(image: dummy[1].CDImage)
//                cell.config(data: dummyData[indexPath.row])
//            }else if indexPath.row == 1{
////                cell.config(image: dummy[0].CDImage)
//            }else{
////                cell.config(image: dummy[indexPath.row].CDImage)
//            }
            return cell
        case rootView.genreCollectionView:
            guard let cell = rootView.genreCollectionView.dequeueReusableCell(withReuseIdentifier: "genreRecommendedCollectionViewIdentifier", for: indexPath)as? GenreRecommendedCollectionViewCell else {
                fatalError("Failed to dequeue genreRecommendedCollectionViewCell")
            }
            let dummy = GenreRecommendedModel.dummy()
            
            if indexPath.row == 2 {
                cell.config(image: dummy[1].AlbumImage)
            }else{
                cell.config(image: dummy[indexPath.row].AlbumImage)
            }
            return cell
        case rootView.collectionView:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: "MusicVerticalCell", for: indexPath)as? MusicVerticalCell else {
                fatalError("Failed to dequeue CollectionViewCell")
            }
            let dummy = MusicDummyModel.dummy()
            cell.config(albumURL: dummy[indexPath.row].albumURL, musicTitle: dummy[indexPath.row].musicTitle, artist: dummy[indexPath.row].artist, year: String(dummy[indexPath.row].year))
            return cell
        default:
            fatalError("Unknown collection view")
        }
    }
}
        


