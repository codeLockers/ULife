//
//  CGPoint+ULCalculate.swift
//  ULife
//
//  Created by codeLocker on 2017/4/10.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation

extension CGPoint {
    func ul_distance(to point:CGPoint?) -> CGFloat? {
        
        guard let point = point else {
            return nil
        }
        let distance_x = point.x - self.x
        let distance_y = point.y - self.y
        
        return CGFloat(sqrtf(powf(Float(distance_x), 2) + powf(Float(distance_y), 2)))
    }
    
    func ul_angle(between point:CGPoint?, peak:CGPoint?) -> Float? {
        guard let point = point, let peak = peak else {
            return nil
        }
        let distance_x = self.x - point.x
        let distance_y = self.y - peak.y
        
        var angle : Float?
        
        if distance_x >= 0 && distance_y < 0{
            //第一象限
            angle = atan(fabsf(Float(distance_x)) / fabsf(Float(distance_y)))
        }else if distance_x > 0 && distance_y >= 0{
            //第二象限
            angle = atan(fabsf(Float(distance_y)) / fabsf(Float(distance_x))) + .pi / 2
        }else if distance_x <= 0 && distance_y > 0{
            //第三象限
            angle = atan(fabsf(Float(distance_x)) / fabsf(Float(distance_y))) + .pi
        }else if distance_x < 0 && distance_y <= 0{
            //第四象限
            angle = atan(fabsf(Float(distance_y)) / fabsf(Float(distance_x))) + (.pi / 2) * 3
        }
        return angle
    }
}
