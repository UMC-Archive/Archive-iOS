//
//  DatePickerMonthView.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//


import UIKit

class DatePickerMonthView : UIView {
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
        $0.image = UIImage(named: "PickerViewBlurCenter")
    }
    public let backButton = UIButton().then{
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
    }
    public let XButton = UIButton().then{
        $0.setImage(UIImage(named: "XButton"), for: .normal)
    }
    public let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  CarouseLayoutVertical().then{
        $0.itemSize = CGSize(width: 91, height: 43)
        $0.scrollDirection = .vertical
    }).then{
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(DatePickerMonthCell.self, forCellWithReuseIdentifier: "datePickerMonthIdentifier")
        $0.showsVerticalScrollIndicator = false
    }
    public let year = UILabel().then{
        $0.text = "2000"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 28, rawValue: 700)
        $0.textColor = UIColor.white_35
    }
    public let week = UILabel().then{
        $0.text = "1st"
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 28, rawValue: 700)
        $0.textColor = UIColor.white_35
    }
    public let button = UIButton().then{
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .black_100
    }
    
    
    private func setConstraint(){
        [
            backButton,
            XButton,
            blur,
            collectionView,
            year,
            week,
            button
        ].forEach{
            addSubview($0)
        }
        backButton.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: 12, height: 20))
            $0.top.equalTo(safeAreaLayoutGuide).offset(26)
            $0.leading.equalToSuperview().offset(20)
        }
        XButton.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: 28, height: 28))
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
        }
        blur.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints{
            $0.height.equalTo(safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(constant.pickerTop)
            $0.width.equalTo(150)
        }
        year.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(61)
            $0.centerY.equalToSuperview()
        }
        week.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-75)
            $0.centerY.equalToSuperview()
        }
        button.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 335, height: 100))
            $0.centerX.equalToSuperview()
        }
    }

}
