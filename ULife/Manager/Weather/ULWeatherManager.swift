//
//  ULWeatherManager.swift
//  ULife
//
//  Created by codeLocker on 2017/3/27.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWeatherManager: NSObject {

    static let manager = ULWeatherManager()
    
    fileprivate let search = AMapSearchAPI()
    fileprivate var success : (([AMapLocalWeatherLive]?) -> Void)?
    fileprivate var fail : ((Error?) -> Void)?
    
    func liveWeather(_ cityCode:String?, success:@escaping([AMapLocalWeatherLive]?) -> Void, fail:@escaping(Error?) -> Void) {
        
        guard let cityCode = cityCode else {
            return
        }
        
        self.success = success
        self.fail = fail
        
        search?.delegate = self
        
        let request = AMapWeatherSearchRequest()
        request.city = cityCode
        request.type = .live
        search?.aMapWeatherSearch(request)
    }
}

extension ULWeatherManager: AMapSearchDelegate{
    
    func onWeatherSearchDone(_ request: AMapWeatherSearchRequest!, response: AMapWeatherSearchResponse!) {
        self.success?(response.lives)
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        self.fail?(error)
    }
}
