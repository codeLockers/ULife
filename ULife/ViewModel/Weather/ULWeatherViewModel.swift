//
//  ULWeatherViewModel.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

let ULWeatherViewModel_CurrentRegion_Singal = "currentRegionSingal"
let ULWeatherViewModel_CurrentWeather_Singal = "currentWeatherSingal"

class ULWeatherViewModel: ULBaseViewModel {
    //外部KVO的属性
    //定位
    dynamic var currentRegionSingal : String?
    var currentRegionLocation : CLLocation?
    var currentRegionRegeoCode : AMapLocationReGeocode?
    
    //天气
    dynamic var currentWeatherSingal : String?
    var currentWeatherLive : AMapLocalWeatherLive?
    
    /// 获取当前地理位置
    func currentRegion() {
        
        ULLocationManager.manger.location(success: { (location, regeocode) in
            self.currentRegionLocation = location
            self.currentRegionRegeoCode = regeocode
            self.currentRegionSingal = ULViewModelSingalType.success.rawValue
        }) { (error) in
            self.currentRegionLocation = nil
            self.currentRegionRegeoCode = nil
            self.currentRegionSingal = ULViewModelSingalType.fail.rawValue
        }
    }
    
    /// 获取当前实时天气
    ///
    /// - Parameter citycode: 城市编码
    func liveWeather(_ citycode:String?) -> Void {
        ULWeatherManager.manager.liveWeather(citycode, success: { (lives) in
            
            guard let lives = lives, lives.count > 0 else {
                self.currentWeatherLive = nil
                self.currentWeatherSingal = ULViewModelSingalType.fail.rawValue
                return
            }
            
            let live = lives.first
            self.currentWeatherLive = live
            self.currentWeatherSingal = ULViewModelSingalType.success.rawValue
            
        }) { (error) in
            self.currentWeatherLive = nil
            self.currentWeatherSingal = ULViewModelSingalType.fail.rawValue
        }
    }
}
