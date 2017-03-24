//
//  ULWeatherRegionView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWeatherRegionView: UIView {

    fileprivate var loadingView : ULActivityIndicatorView?
    
    fileprivate let regionLab : UILabel = {
    
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    //MARK: Load_UI
    private func loadUI() {
        self.addSubview(regionLab)
    }
    
    private func layout() {
        regionLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
    }
}

extension ULWeatherRegionView {
    
    /// 更新地区
    ///
    /// - Parameter regeoCode: 地区反编码
    func updateRegion(_ regeoCode:AMapLocationReGeocode?) {
        if regeoCode == nil {
            return
        }
        let city = regeoCode!.city ?? ""
        let district = regeoCode!.district ?? ""
        let space = "  "
        let region = "\(city)\(space)\(district)"
        var attStr = NSMutableAttributedString.init(string: region)
        
        attStr = attStr.ul_setText(font: UIFont.boldSystemFont(ofSize: 30), inRange: NSRange.init(location: 0, length: city.characters.count))
        attStr = attStr.ul_setText(font: UIFont.boldSystemFont(ofSize: 17), inRange: NSRange.init(location: city.characters.count + space.characters.count, length: district.characters.count))
        self.regionLab.attributedText = attStr
    }
}
