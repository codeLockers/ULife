//
//  UIViewController+ULTransparent.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    fileprivate struct AssociatedKeys {
        //导航栏透明度
        static var ul_navBarBgAlpha = 1.0
        static var ul_navBarTintColor = ULConstants.color.defaultNavigationBarTintColor
    }
    
    open var ul_navBarBgAlpha : CGFloat{
        get{
            //获取alpha
            let alpha = objc_getAssociatedObject(self, &AssociatedKeys.ul_navBarBgAlpha) as? CGFloat
            if alpha == nil {
                return 1.0
            }
            return alpha!
        }
        set {
            //设置alpha
            var alpha = newValue
            if alpha > 1 {
                alpha = 1
            }
            if alpha < 0 {
                alpha = 0
            }
            objc_setAssociatedObject(self, &AssociatedKeys.ul_navBarBgAlpha, alpha, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.setNavigationBarBackground(alpha: alpha)
        }
    }
    
    open var ul_navBarTintColor : UIColor {
        get {
            let tintColor = objc_getAssociatedObject(self, &AssociatedKeys.ul_navBarTintColor) as? UIColor
            if tintColor == nil{
                return ULConstants.color.defaultNavigationBarTintColor
            }
            return tintColor!
        }
        set {
            navigationController?.navigationBar.tintColor = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.ul_navBarTintColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
