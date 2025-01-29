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
        rootView.button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        rootView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.XButton.addTarget(self, action: #selector(XButtonTapped), for: .touchUpInside)
    }
    
    private func setDataSourceAndDelegate(){
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
    }
    
    @objc func nextButtonTapped() {
        KeychainService.shared.save(account: .userInfo, service: .year, value: rootView.year.text ?? "2001")
        KeychainService.shared.save(account: .userInfo, service: .month, value: rootView.month.text ?? "11")
        
        let collectionView = rootView.collectionView
        
        // 현재 보이는 셀들의 Layout Attributes 가져오기
        let visibleCellsAttributes = collectionView.indexPathsForVisibleItems.compactMap { indexPath in
            collectionView.layoutAttributesForItem(at: indexPath)
        }
        
        // alpha == 1인 셀의 Attributes 찾기
        if let targetAttributes = visibleCellsAttributes.first(where: { $0.alpha == 1 }) {
            // 해당 셀의 IndexPath
            let indexPath = targetAttributes.indexPath
            
            // 데이터 가져오기
            if let cell = rootView.collectionView.cellForItem(at: indexPath) as? DatePickerWeekCell {
                let data = cell.week.text // 셀에서 데이터 가져오기
                
                // 로그 출력
                print("마지막 선택된 데이터: \(data)")
                KeychainService.shared.save(account: .userInfo, service: .week, value: data ?? "1st")
            }
        }
        
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func XButtonTapped(){
        navigationController?.popToRootViewController(animated: true)
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
