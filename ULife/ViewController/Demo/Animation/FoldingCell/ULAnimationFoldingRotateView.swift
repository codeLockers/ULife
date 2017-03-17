//
//  ULAnimationFoldingRotateView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/8.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULAnimationFoldingRotateView: UIView , CAAnimationDelegate{
    var hiddenAfterAnimation = false
    var backView: ULAnimationFoldingRotateView?
    
    func addBackView(_ height: CGFloat, color:UIColor) {
        let view                                       = ULAnimationFoldingRotateView(frame: CGRect.zero)
        view.backgroundColor                           = color
        view.layer.anchorPoint                         = CGPoint.init(x: 0.5, y: 1)
        view.layer.transform                           = view.transform3d()
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.layer.masksToBounds = true
        self.addSubview(view)
        backView = view
        
        backView?.snp.makeConstraints({ (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self).offset(height/2)
            make.height.equalTo(height)
        })
    }
    
    /// 设置ULAnimationFoldingCellRotateView的transform
    ///
    /// - Returns: CATransform
    func transform3d() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 2 / -2000 //负值才能有翻转的视觉效果
        return transform
    }
    
    /// 绕X轴旋转
    ///
    /// - Parameter angle: 旋转角度
    func rotateX(_ angle : CGFloat) {
        var allTransform = CATransform3DIdentity
        let rotateTransform = CATransform3DMakeRotation(angle, 1, 0, 0)
        allTransform = CATransform3DConcat(allTransform, rotateTransform)
        allTransform = CATransform3DConcat(allTransform, transform3d())
        self.layer.transform = allTransform
    }
    
    /// floding动画
    ///
    /// - Parameters:
    ///   - timing: 时间函数
    ///   - from: 起始值
    ///   - to:  终点值
    ///   - duration: 时长
    ///   - delay:  延迟
    ///   - hidden: 动画结束后是否隐藏
    func foldingAnimation(_ timing : String, from : CGFloat, to : CGFloat, duration : TimeInterval, delay : TimeInterval, hidden : Bool) {
        let rotateAnimation = CABasicAnimation.init(keyPath: "transform.rotation.x")
        rotateAnimation.fromValue = from
        rotateAnimation.toValue = to
        rotateAnimation.timingFunction = CAMediaTimingFunction.init(name: timing)
        rotateAnimation.duration = duration
        rotateAnimation.delegate = self
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.beginTime = CACurrentMediaTime() + delay
        
        self.hiddenAfterAnimation = hidden
        self.layer.add(rotateAnimation, forKey: "rotation.x")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        //光栅话,使用离屏渲染
        self.layer.shouldRasterize = true
        self.alpha = 1
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if hiddenAfterAnimation {
            self.alpha = 0
        }
        self.layer.removeAllAnimations()
        self.layer.shouldRasterize = false
        self.rotateX(0)
    }
}
