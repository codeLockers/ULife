//
//  ULNotificationCenterManager.swift
//  ULife
//
//  Created by codeLocker on 2017/3/2.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

struct ULNotification {
    struct Weather {
        //Weather页面push页面通知
        static let pushViewController : String = "ULNotification_Weather_PushViewController"
     }
    struct Sidebar {
        ///侧边栏页面禁用侧边栏
        static let disableSidebar : String = "ULNotification_Weather_DisableSidebar"
        ///侧边栏页面启动侧边栏
        static let enableSidebar : String = "ULNotification_Weather_EnableSidebar"
    }
}

class ULNotificationCenterManager: NSObject {
    
    /// 单例
    static let manger = ULNotificationCenterManager()
    
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: nil)
    }
    
    func post(_ aName:NSNotification.Name!, object:Any?) {
        NotificationCenter.default.post(name: aName, object: object)
    }
    
    func removeObserver(_ observer: NSObject) {
        NotificationCenter.default.removeObserver(observer)
    }
}
