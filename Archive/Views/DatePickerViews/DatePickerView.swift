//
//  DatePickerView.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class DatePickerView : UIView {
    private enum constant {//작은 디바이스 대응용 constraint
        static let pickerTop = UIScreen.main.isWiderThan375pt ? -70 : -103
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let blur = UIImageView().then{
        $0.image = UIImage(named: "PickerViewBlur")
    }
    public let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  CarouseLayoutVertical().then{
        $0.itemSize = CGSize(width: 91, height: 43)
        $0.scrollDirection = .vertical
    }).then{
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(DatePickerCell.self, forCellWithReuseIdentifier: "datePickerIdentifier")
        $0.showsVerticalScrollIndicator = false
    }
    public let month = UILabel().then{
        $0.text = "01"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 28, rawValue: 700)
        $0.textColor = UIColor.white_35
    }
    public let week = UILabel().then{
        $0.text = "1st"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 28, rawValue: 700)
        $0.textColor = UIColor.white_35
    }
    public let button = UIButton().then{
        $0.setTitle("이전", for: .normal)
        $0.backgroundColor = .black_100
    }
    
    
    private func setConstraint(){
        [
            blur,
            collectionView,
            month,
            week,
            button
        ].forEach{
            addSubview($0)
        }
        blur.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 553, height: 56))
        }
        collectionView.snp.makeConstraints{
            $0.height.equalTo(safeAreaLayoutGuide) //800
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(constant.pickerTop)
            $0.width.equalTo(150)
        }
        month.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-56)
            $0.centerY.equalToSuperview()
        }
        week.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        button.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-30)
            $0.size.equalTo(CGSize(width: 335, height: 70))
            $0.centerX.equalToSuperview()
        }
    }

}
