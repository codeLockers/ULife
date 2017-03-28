//
//  ULWeatherViewModel.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

let ULWeatherViewModel_CurrentRegion_Singal = "currentRegionSingal"
let ULWeatherViewModel_CurrentLiveWeather_Singal = "currentLiveWeatherSingal"
let ULWeatherViewModel_CurrentForecasWeather_Singal = "currentForecastWeatherSingal"

class ULWeatherViewModel: ULBaseViewModel {
    //外部KVO的属性
    //定位
    dynamic var currentRegionSingal : String?
    var currentRegionLocation : CLLocation?
    var currentRegionRegeoCode : AMapLocationReGeocode?
    
    //天气
    dynamic var currentLiveWeatherSingal : String?
    var currentLiveWeather : AMapLocalWeatherLive?
    dynamic var currentForecastWeatherSingal : String?
    var currentForecastWeathers : [AMapLocalDayWeatherForecast]?
    
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
    func liveWeather(_ citycode:String?) {
        ULWeatherManager.manager.liveWeather(citycode, success: { (lives) in
            
            guard let lives = lives, lives.count > 0 else {
                self.currentLiveWeather = nil
                self.currentLiveWeatherSingal = ULViewModelSingalType.fail.rawValue
                return
            }
            
            let live = lives.first as? AMapLocalWeatherLive
            self.currentLiveWeather = live
            self.currentLiveWeatherSingal = ULViewModelSingalType.success.rawValue
            
        }) { (error) in
            self.currentLiveWeather = nil
            self.currentLiveWeatherSingal = ULViewModelSingalType.fail.rawValue
        }
    }
    
    // 获取当前预报天气
    ///
    /// - Parameter citycode: 城市编码
    func forecastWeather(_ cityCode:String?) {
        ULWeatherManager.manager.forecastWeather(cityCode, success: { (forecasts) in
            
            guard let forecasts = forecasts, forecasts.count > 0 else {
                self.currentForecastWeathers = nil
                self.currentForecastWeatherSingal = ULViewModelSingalType.fail.rawValue
                return
            }
            
            let casts = forecasts.flatMap({ $0 as? AMapLocalDayWeatherForecast})
            guard casts.count > 0 else {
                self.currentForecastWeathers = nil
                self.currentForecastWeatherSingal = ULViewModelSingalType.fail.rawValue
                return
            }
            self.currentForecastWeathers = casts
            self.currentForecastWeatherSingal = ULViewModelSingalType.success.rawValue
            
        }) { (error) in
            self.currentForecastWeathers = nil
            self.currentForecastWeatherSingal = ULViewModelSingalType.fail.rawValue
        }
    }
}
