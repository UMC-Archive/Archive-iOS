//
//  DatePickerMonthCell.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//


import UIKit

class DatePickerMonthCell: UICollectionViewCell {
    static let datePickerMonthIdentifier = "datePickerMonthIdentifier"
    private enum constant {//작은 디바이스 대응용 constraint
        static let cellSize = UIScreen.main.isWiderThan375pt ? 120: 200
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let month = UILabel().then{
        $0.textColor = UIColor.white
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 36, rawValue: 700)
        $0.textAlignment = .center
    }
    
    private func setComponent(){
        addSubview(month)
        
        month.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(constant.cellSize)
        }
    }
    
    public func config(month: String){
        self.month.text = month
    }
}
