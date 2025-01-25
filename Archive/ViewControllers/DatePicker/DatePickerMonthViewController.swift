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
        
        rootView.button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        rootView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.XButton.addTarget(self, action: #selector(XButtonTapped), for: .touchUpInside)
    }
    @objc func weekTapped() {
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
            if let cell = rootView.collectionView.cellForItem(at: indexPath) as? DatePickerMonthCell {
                let data = cell.month.text // 셀에서 데이터 가져오기
                
                // 로그 출력
                print("선택된 데이터: \(data)")
                
                // 데이터 전달을 위해 새로운 ViewController 생성
                let viewController = DatePickerWeekViewController()
                viewController.rootView.month.text = data // 전달할 데이터 설정
                
                // 다음 화면으로 Push
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            print("alpha가 1인 셀을 찾을 수 없습니다.")
        }
    }
    @objc func nextButtonTapped() {
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
            if let cell = rootView.collectionView.cellForItem(at: indexPath) as? DatePickerMonthCell {
                let data = cell.month.text // 셀에서 데이터 가져오기
                
                // 로그 출력
                print("선택된 데이터: \(data)")
                
                // 데이터 전달을 위해 새로운 ViewController 생성
                let viewController = DatePickerWeekViewController()
                viewController.rootView.month.text = data // 전달할 데이터 설정
                viewController.rootView.year.text = rootView.year.text
                
                // 다음 화면으로 Push
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            print("alpha가 1인 셀을 찾을 수 없습니다.")
        }
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func XButtonTapped(){
        navigationController?.popToRootViewController(animated: true)
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
