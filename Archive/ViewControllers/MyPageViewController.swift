//
//  MyPageViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/14/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    let rootView = MyPageView()
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.view = rootView
        
        self.navigationController?.navigationBar.isHidden = true
        
        buildGradient()
        controlTapped()
        setDataSource()
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           // rootView의 크기가 업데이트된 후 gradient의 프레임을 설정
        gradient.frame = rootView.CDView.bounds
       }
    private func setDataSource(){
        rootView.recordCollectionView.dataSource = self
        rootView.recentCollectionView.dataSource = self
    }
    private func controlTapped(){
        rootView.goRecapButton.addTarget(self, action: #selector(recapButtonTapped), for: .touchUpInside)
        // headerButton에 UITapGestureRecognizer 추가
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerButtonTapped))
        rootView.headerButton.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.headerButton.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(headerButtonTapped2))
        rootView.headerButton2.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.headerButton2.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(arrowButtonTapped))
        rootView.arrowButton.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.arrowButton.addGestureRecognizer(tapGesture3)
        
        rootView.topView.exploreIconButton.addTarget(self, action: #selector(exploreIconTapped), for: .touchUpInside)
    }
    @objc func exploreIconTapped(){
        let viewController = DatePickerViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func recapButtonTapped(){
        let viewController = RecapViewController()
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    // 제스처에 대응하는 함수
    @objc private func headerButtonTapped() {
        let viewController = ListenRecordViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    // 제스처에 대응하는 함수
    @objc private func headerButtonTapped2() {
        let viewController = RecentMusicViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc private func arrowButtonTapped() {
        let viewController = ProfileChangeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func buildGradient() {
        
        gradient.type = .conic
        gradient.colors = [
            UIColor.dance_100?.cgColor ?? UIColor.red,
            UIColor.hiphop_100?.cgColor ?? UIColor.red,
            UIColor.RnB_100?.cgColor ?? UIColor.red,
            UIColor.dance_100?.cgColor ?? UIColor.red
        ]
        gradient.locations = [0.0, 0.17, 0.5, 0.84, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5) // 중심점
        gradient.endPoint = CGPoint(x: 01.0, y: 1.0)   // conic 그라데이션은 중심을 공유
        
        
        rootView.CDView.layer.addSublayer(gradient)
    }
}
extension MyPageViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case rootView.recordCollectionView :
            return ListenRecordModel.dummy().count
        case rootView.recentCollectionView :
            return ListenRecordModel.dummy().count
        default :
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case rootView.recordCollectionView :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listenRecordCollectionViewIdentifier", for: indexPath)as? ListenRecordCollectionViewCell else {
                fatalError("Failed to dequeue ListenRecordCollectionViewCell")
            }
            let dummy = ListenRecordModel.dummy()
            
            cell.config(image: dummy[indexPath.row].albumImage, albumName: dummy[indexPath.row].albumName)
            return cell
            
        case rootView.recentCollectionView :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listenRecordCollectionViewIdentifier", for: indexPath)as? ListenRecordCollectionViewCell else {
                fatalError("Failed to dequeue ListenRecordCollectionViewCell")
            }
            let dummy = ListenRecordModel.dummy()
            
            cell.config(image: dummy[indexPath.row].albumImage, albumName: dummy[indexPath.row].albumName)
            return cell
        default :
            fatalError("Unknown collection view")
            
        }
        
    }
    
    
}
