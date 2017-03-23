//
//  ULLocationManager.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
class ULLocationManager: NSObject {
    
    /// 单例
    static let manger = ULLocationManager()
    
    fileprivate let locationManager : AMapLocationManager = {
        let locationManager = AMapLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.locationTimeout = 5
        locationManager.reGeocodeTimeout = 5
        return locationManager
    }()
    
    /// 注册定位服务
    func registerLocationService() {
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = ULConstants.venderKeys.gaodeKey
    }
    
    func location(success:@escaping (CLLocation? , AMapLocationReGeocode?)->Void, fail:@escaping (Error?) -> Void) {
        
        self.locationManager.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            error == nil ? success(location,regeocode) : fail(error)
        }
    }
}
