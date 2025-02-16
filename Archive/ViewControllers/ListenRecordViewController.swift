//
//  ListenRecordViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/20/25.
//

import UIKit

class ListenRecordViewController: UIViewController {
    private let rootView = ListenRecordView()

    public var responseData: [RecentPlayMusicResponseDTO]? {
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
extension ListenRecordViewController : UICollectionViewDataSource {
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
        if let year = extractYear(from: responseData?[indexPath.row].createdAt ?? "2022") {
            cell.config(image: responseData?[indexPath.row].musicImage ?? "", songName: responseData?[indexPath.row].musicTitle ?? "", artist: responseData?[indexPath.row].artists.first?.artistName ?? "", year: Int(year) ?? 2022)
        }
        
        
       return cell
    }
}
