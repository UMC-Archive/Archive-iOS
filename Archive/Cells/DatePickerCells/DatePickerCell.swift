//
//  DatePickerCell.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class DatePickerCell: UICollectionViewCell {
    static let datePickerIdentifier = "datePickerIdentifier"
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
    
    private let year = UILabel().then{
        $0.textColor = UIColor.white
        $0.font = UIFont.customFont(font: .SFPro, ofSize: 36, rawValue: 700)
    }
    
    private func setComponent(){
        addSubview(year)
        
        year.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(constant.cellSize)
            $0.width.equalTo(100)
        }
    }
    
    public func config(year: String){
        self.year.text = year
    }
}
