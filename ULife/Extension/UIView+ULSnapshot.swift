//
//  UIView+ULSnapshot.swift
//  ULife
//
//  Created by codeLocker on 2017/3/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

extension UIView {
    
    func ul_takeSnapshot(_ frame:CGRect) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        //坐标轴翻转
        context?.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
