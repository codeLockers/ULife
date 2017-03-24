//
//  UIImage+ULBitmap.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 保持图片比例,短边＝targerSize,另外一边可能超出
    ///
    /// - Parameter targetSize: 目标尺寸
    /// - Returns: 裁剪后的图片
    func ul_scaleAspect(minSize targetSize : CGSize) -> UIImage? {
        
        if self.size.equalTo(targetSize) || targetSize.equalTo(.zero){
            return self
        }
        //水平方向缩放因子
        let xFactor = targetSize.width / self.size.width
        //竖直方向缩放因子
        let yFactor = targetSize.height / self.size.height
        let scaleFactor = xFactor > yFactor ? xFactor : yFactor
        
        let scaleWidth = self.size.width * scaleFactor
        let scaleHeight = self.size.height * scaleFactor
        
        var anchorPoint : CGPoint = .zero
        if xFactor > yFactor {
            anchorPoint.y = (targetSize.height - scaleHeight) / 2.0
        }
        if xFactor < yFactor {
            anchorPoint.x = (targetSize.width - scaleWidth) / 2.0
        }
        //开始绘图
        UIGraphicsBeginImageContextWithOptions(targetSize, true, 0)
        var anchorRect : CGRect = .zero
        anchorRect.origin = anchorPoint
        anchorRect.size.width = scaleWidth
        anchorRect.size.height = scaleHeight
        
        self.draw(in: anchorRect)
        
        let image : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 裁剪Image
    ///
    /// - Parameter rect: 裁剪的区域
    /// - Returns: 裁剪后的图片
    func ul_crop(_ rect:CGRect?) -> UIImage? {
        
        guard let rect = rect else {
            return nil
        }
        let imageRef = self.cgImage?.cropping(to: rect)
        return UIImage.init(cgImage: imageRef!)
    }
}
