//
//  ULNotificationCenterManager+ULSidebar.swift
//  ULife
//
//  Created by codeLocker on 2017/3/2.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation
extension ULNotificationCenterManager {
    
    func registerDisableSidebar(_ observer: Any, selector aSelector: Selector) {
        self.addObserver(observer, selector: aSelector, name: NSNotification.Name(rawValue: ULNotification.Sidebar.disableSidebar))
    }
    func registerEnableSidebar(_ observer: Any, selector aSelector: Selector) {
        self.addObserver(observer, selector: aSelector, name: NSNotification.Name(rawValue: ULNotification.Sidebar.enableSidebar))
    }
    
    func postDisableSidebar() {
        self.post(Notification.Name(rawValue: ULNotification.Sidebar.disableSidebar), object: nil)
    }
    
    func postEnableSidebar() {
        self.post(Notification.Name(rawValue: ULNotification.Sidebar.enableSidebar), object: nil)
    }
}
