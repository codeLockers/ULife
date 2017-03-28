//
//  UINavigationController+ULInterface.swift
//  ULife
//
//  Created by codeLocker on 2017/3/28.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    /// 隐藏NavigatorBar底部黑线
    func ul_hideBottomLine() {
        for subview in navigationBar.subviews {
            for hairline in subview.subviews {
                if hairline is UIImageView && hairline.bounds.height <= 1.0{
                    hairline.isHidden = true;
                }
            }
        }
    }
    
    /// 设置NavigationBar的返回键的标题
    ///
    /// - parameter backItemTitle:  标题
    /// - parameter viewController: 控制器
    func ul_set(backItemTitle title:String , viewController : UIViewController) {
        
        let backItem = UIBarButtonItem()
        backItem.title = title as String
        viewController.navigationItem.backBarButtonItem = backItem
    }
    
    func ul_setRightItem(style:UIBarButtonSystemItem, delegate:UIViewController, action:Selector) {
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: style, target: delegate, action: action)
        delegate.navigationItem.rightBarButtonItem = rightItem
    }
}
