//
//  ULNotificationCenterManager+ULWeather.swift
//  ULife
//
//  Created by codeLocker on 2017/3/2.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation

extension ULNotificationCenterManager {

    func registerPushViewController(_ observer: Any, selector aSelector: Selector) {
        self.addObserver(observer, selector: aSelector, name: NSNotification.Name(rawValue: ULNotification.Weather.pushViewController))
    }
    
    func postPushViewController(_ object:Any?) {
        self.post(Notification.Name(rawValue: ULNotification.Weather.pushViewController), object: object)
    }
}
