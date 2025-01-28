//
//  DatePickerViewController2.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class DatePickerViewController : UIViewController {
    let rootView = DatePickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = rootView
        
        view.backgroundColor = UIColor.black_100
        controlTapped()
        setDataSourceAndDelegate()
        self.navigationController?.navigationBar.isHidden = true

    }
    private func controlTapped(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(monthTapped))
        rootView.month.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.month.addGestureRecognizer(tapGesture)
        rootView.button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func monthTapped() {
        let viewController = DatePickerMonthViewController()
        print("'")
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setDataSourceAndDelegate(){
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
    }
    
}

extension DatePickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatePickerModel().years.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerCell.datePickerIdentifier, for: indexPath) as! DatePickerCell
        let year = DatePickerModel().years[indexPath.item]
        cell.config(year: year) // 연도 전달
        return cell
    }
}
