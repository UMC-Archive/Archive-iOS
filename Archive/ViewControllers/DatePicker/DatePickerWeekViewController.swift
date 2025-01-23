//
//  DatePickerWeekViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//


import UIKit

class DatePickerWeekViewController : UIViewController {
    let rootView = DatePickerWeekView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = rootView
        view.backgroundColor = UIColor.black_100
        controlTapped()
        setDataSourceAndDelegate()
        self.navigationController?.navigationBar.isHidden = true
    }
    private func controlTapped(){
        rootView.button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setDataSourceAndDelegate(){
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DatePickerWeekViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatePickerWeekModel().week.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerWeekCell.datePickerWeekIdentifier, for: indexPath) as! DatePickerWeekCell
        let week = DatePickerWeekModel().week[indexPath.item]
        cell.config(week: week)// 연도 전달
        return cell
    }
}
