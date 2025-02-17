//
//  RecentMusicViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class RecentMusicViewController: UIViewController {
    private let rootView = RecentMusicView()
    public var responseData: [RecentMusicResponseDTO]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                print("📌 responseData 노래 변경됨: \(self?.responseData?.count ?? 0)개") // 디버깅 로그
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
        self.view.layoutIfNeeded()
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
    func extractYear(from dateString: String) -> String? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        if let date = formatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return String(year)
        }
        return nil
    }
}

extension RecentMusicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCollectionViewCell.genreCollectionViewIdentifier,
            for: indexPath
        ) as? GenreCollectionViewCell else {
            fatalError("Failed to dequeue genreCollectionViewCell")
        }
//        // releaseTime이 nil일 경우를 고려하여 기본값을 설정
//        let releaseTime = responseData?[indexPath.row].music.releaseTime ?? "2022"
//        guard let year = extractYear(from: releaseTime) else {
//            return UICollectionViewCell() // year 추출이 실패하면 기본 셀 반환
//        }
//        cell.config(image: responseData?[indexPath.row].music.image ?? "", songName: responseData?[indexPath.row].music.title ?? "", artist: responseData?[indexPath.row].music.artist.name ?? "", year: 2022)
//        
        return cell
    }
}
