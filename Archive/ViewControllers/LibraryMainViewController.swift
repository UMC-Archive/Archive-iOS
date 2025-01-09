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
        rootView.playlistCollectionView.dataSource = self
        setupActions()
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
            self.rootView.layoutIfNeeded()
        })
        hideAllCollectionViews()
        showCollectionView(for: segmentIndexNum)
    }
    private func hideAllCollectionViews() {
          rootView.playlistCollectionView.isHidden = true
          // 다른 컬렉션뷰도 필요시 추가로 숨길 수 있습니다.
      }
    private func showCollectionView(for index: Int) {
           switch index {
           case 0:
               rootView.playlistCollectionView.isHidden = false
           default:
               break
           }
           rootView.layoutIfNeeded()
       }
}

extension LibraryMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dummyCount : Int
        switch (segmentIndexNum){
            
        case 0:
            dummyCount = PlayListDummy.dummy().count
        case 1:
            dummyCount = 0
        case 2:
            dummyCount = 0
        case 3:
            dummyCount = 0
        case 4:
            dummyCount = 0
        default:
            dummyCount = 0
        }
        return dummyCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch (segmentIndexNum){
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayListCollectionViewCell.playListCollectionViewIdentifier, for: indexPath) as? PlayListCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let dummy = PlayListDummy.dummy()
            
            cell.config(image: dummy[indexPath.row].albumImage)
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
}

