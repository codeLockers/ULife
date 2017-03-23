//
//  ULWeatherViewModel.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

let ULWeatherViewModel_CurrentRegion_Singal = "currentRegionSingal"

class ULWeatherViewModel: ULBaseViewModel {
    //外部KVO的属性
    dynamic var currentRegionSingal : String?
    var currentRegionLocation : CLLocation?
    var currentRegionRegeoCode : AMapLocationReGeocode?
    
    func currentRegion() {
        
        ULLocationManager.manger.location(success: { (location, regeocode) in
            self.currentRegionLocation = location
            self.currentRegionRegeoCode = regeocode
            self.currentRegionSingal = ULViewModelSingalType.success.rawValue
        }) { (error) in
            self.currentRegionSingal = ULViewModelSingalType.fail.rawValue
        }
    }
}
