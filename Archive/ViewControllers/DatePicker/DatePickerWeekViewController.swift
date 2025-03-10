//
//  DatePickerWeekViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//


import UIKit

class DatePickerWeekViewController : UIViewController {
    let rootView = DatePickerWeekView()
    private let service = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = rootView
        view.backgroundColor = UIColor.black_100
        controlTapped()
        setDataSourceAndDelegate()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        (self.tabBarController as? TabBarViewController)?.floatingView.isHidden = false
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
        //        KeychainService.shared.save(account: .userInfo, service: .year, value: rootView.year.text ?? "2001")
        //        KeychainService.shared.save(account: .userInfo, service: .month, value: rootView.month.text ?? "11")
        
        
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
                

                
                let year = rootView.year.text ?? "0000"
                let month = rootView.month.text ?? "00"
                var week = 1
                switch data { //서버에 week정보를 날짜로 보내야해서 변경하는 로직
                case "1st":
                    week = 1
                case "2st":
                    week = 2
                case "3st":
                    week = 3
                case "4st":
                    week = 4
                default:
                    break
                   
                }
                let day = 1 + 7*(week - 1) //서버에 week정보를 날짜로 보내야해서 변경하는 로직
                
                let dateString = "\(year)-\(month)-\(day)"

                let requestDTO = PostHistoryRequestDTO(history: dateString)
                postHistory(date: requestDTO)
                
                // 키체인 저장
                KeychainService.shared.save(account: .userInfo, service: .timeHistory, value: "\(year)년 \(month)월 \(data ?? "")")
                
                async {
                    // 탭 전환
                    tabBarController?.selectedViewController = tabBarController?.viewControllers?[1]
                    
                    // 약간의 지연 후 내비게이션 스택 초기화
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
                
            }
        }
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func XButtonTapped(){
        self.tabBarController?.tabBar.isHidden = false
        (self.tabBarController as? TabBarViewController)?.floatingView.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
    private func postHistory(date: PostHistoryRequestDTO){
        service.postHistory(parameter: date){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):

                Task{

                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)

                self.present(alert, animated: true)
            }
        }
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
