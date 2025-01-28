//
//  DatePickerMonthViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class DatePickerMonthViewController : UIViewController {
    let rootView = DatePickerMonthView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = rootView
        view.backgroundColor = UIColor.black_100
        controlTapped()
        setDataSourceAndDelegate()
        self.navigationController?.navigationBar.isHidden = true
    }
    private func controlTapped(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(weekTapped))
        rootView.week.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.week.addGestureRecognizer(tapGesture)
        
        rootView.button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    @objc func weekTapped() {
        let viewController = DatePickerWeekViewController()
        print("'")
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setDataSourceAndDelegate(){
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
    }
    
}

extension DatePickerMonthViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatePickerMonthModel().month.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerMonthCell.datePickerMonthIdentifier, for: indexPath) as! DatePickerMonthCell
        let month = DatePickerMonthModel().month[indexPath.item]
        cell.config(month: month)// 연도 전달
        return cell
    }
}
