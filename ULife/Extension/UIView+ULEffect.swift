//
//  UIView+ULEffect.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    fileprivate struct AssociatedKeys {
        //导航栏透明度
        static var ul_motionEffect = "ul_motionEffect"
    }
    
    var effectGroup : UIMotionEffectGroup? {
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ul_motionEffect, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ul_motionEffect) as? UIMotionEffectGroup
        }
    }
    
    /// 设置Effect
    ///
    /// - Parameters:
    ///   - x: x轴偏移范围
    ///   - y: y轴偏移范围
    func setEffect(xValue x : CGFloat , yValue y : CGFloat) {
        
        guard x > 0 && y > 0 && self.effectGroup != nil else {
            return
        }
        let xAxis = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = -x
        xAxis.maximumRelativeValue = x
        
        let yAxis = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = -y
        yAxis.maximumRelativeValue = y
        
        self.removeMotionEffect(self.effectGroup!)
        self.effectGroup?.motionEffects = [xAxis,yAxis]
        self.addMotionEffect(self.effectGroup!)
    }
}
