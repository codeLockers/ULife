//
//  UIColor+ULGenerate.swift
//  ULife
//
//  Created by codeLocker on 2017/3/1.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 生成一个随机颜色
    ///
    /// - Returns: UIColor
    static func ul_random() -> UIColor {
        return self.ul_rgb(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)),a:1.0)
    }
    
    /// 根据RGBA生成颜色
    ///
    /// - parameter r: red
    /// - parameter g: green
    /// - parameter b: blue
    /// - parameter a: alpha
    ///
    /// - returns: UIColor
    static func ul_rgb(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}
