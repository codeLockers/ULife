//
//  ULWeatherDateView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/24.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWeatherDateView: UIView {

    fileprivate let dateLab : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        let date = Date()
        label.text = date.ul_dateString(type: .chinese) + " " + date.ul_chineseLongWeekday()
        return label
    }()
    
    fileprivate let festivalLab : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        let date = Date()
        let chineseYear = date.ul_chineseDate().year ?? ""
        let chineseMonth = date.ul_chineseDate().month ?? ""
        let chineseDay = date.ul_chineseDate().day ?? ""
        var festival = date.ul_chineseFestival() ?? ""
        let internationalFestival = date.ul_internationalFestival()
        if internationalFestival != nil {
            festival += internationalFestival!
        }
        label.text = chineseYear + chineseMonth + chineseDay + " " + festival
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Load_UI
    private func loadUI() {
        self.addSubview(self.dateLab)
        self.addSubview(self.festivalLab)
    }
    
    private func layout() {
        self.dateLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        self.festivalLab.snp.makeConstraints { (make) in
            make.left.equalTo(dateLab)
            make.bottom.equalToSuperview()
        }
    }
    
}
