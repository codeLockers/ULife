//
//  ULShimmeringLayer.swift
//  ULife
//
//  Created by codeLocker on 2017/4/17.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit


enum ULShimmeringDirection {
    case up
    case left
    case right
    case down
}

class ULShimmeringLayer: CALayer {
    
    var shimmering : Bool = true//是否开启闪烁
    var shimmeringPauseDuration : TimeInterval = 1//闪烁时间周期
    var shimmeringAnimationOpacity : CGFloat = 0.5 //闪烁时的透明度
    var shimmeringOpacity : CGFloat = 1.0//闪烁前的透明度
    var shimmeringSpeed : CGFloat = 230 //闪烁的速度
    var shimmeringHighlightLength : CGFloat = 1 //闪烁时高亮的区间范围
    var shimmeringDirection : ULShimmeringDirection = .right //闪烁的方向
    var shimmeringBeginFadeDuration : TimeInterval = 0.1//闪烁起始fade时间
    var shimmeringEndFadeDuration : TimeInterval = 0.3 //闪烁结束fade时间

    var maskLayer : ULShimmeringMaskLayer?

    var subLayers : [CALayer]?
    
    var tmpContentLayer : CALayer?
    
    
    var contentLayer : CALayer? {
        set {
            if newValue == nil {
                return
            }
            self.maskLayer = nil
            self.tmpContentLayer = newValue
            self.subLayers = contentLayer == nil ? [newValue!] : nil
            self.updateShimmering()
        }
        get {
            return self.tmpContentLayer
        }
    }
    
    override init() {
        super.init()
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.contentLayer?.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        self.contentLayer?.bounds = self.bounds
        self.contentLayer?.position = CGPoint.init(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        
        if self.maskLayer != nil {
            self.updateMaskLayout()
        }
    }
}

extension ULShimmeringLayer {
    fileprivate func updateShimmering() {
        //create mask if need
        self.createMaskIfNeeded()
        
        guard let maskLayer = self.maskLayer , self.shimmering , let contentLayer = self.contentLayer else {
            return
        }
        
        self.layoutIfNeeded()
        //关闭animation动画效果，开启隐式动画
        let disableActions = CATransaction.disableActions()
        
        var fadeOutAnimation : CABasicAnimation?
        if self.shimmeringBeginFadeDuration > 0.0 && !disableActions{
            fadeOutAnimation = self.fade_animation(layer: maskLayer, opacity: 0, duration: self.shimmeringBeginFadeDuration)
            if fadeOutAnimation == nil {
                return
            }
            maskLayer.fadeLayer.add(fadeOutAnimation!, forKey: "fade")
        }else {
        }
        
        var slideAnimation = maskLayer.animation(forKey: "slide")
        var length : CGFloat = 0.0
        switch self.shimmeringDirection {
        case .down:
            fallthrough
        case .up:
            length = contentLayer.bounds.height
        case .left:
            fallthrough
        case .right:
            length = contentLayer.bounds.width
        }
        let animationDuration = (length / self.shimmeringSpeed) + CGFloat(self.shimmeringPauseDuration)
        
        if slideAnimation != nil {
            maskLayer.add(self.slide_animation_repeat(aniamtion: slideAnimation!, duration: TimeInterval(animationDuration), direction: self.shimmeringDirection), forKey: "slide");
        }else {
            slideAnimation = self.silde_animation(duration: TimeInterval(animationDuration), direction: self.shimmeringDirection)
            slideAnimation?.fillMode = kCAFillModeForwards
            slideAnimation?.isRemovedOnCompletion = false
            slideAnimation?.beginTime = CACurrentMediaTime() + fadeOutAnimation!.duration
            maskLayer.add(slideAnimation!, forKey: "slide")
        }
    }
    
    fileprivate func createMaskIfNeeded() {
        if self.shimmering && self.maskLayer == nil{
            self.maskLayer = ULShimmeringMaskLayer()
            self.maskLayer?.delegate = self
            self.contentLayer?.mask = self.maskLayer
            self.updateMaskColor()
            self.updateMaskLayout()
        }
    }
    
    fileprivate func updateMaskColor() {
        guard let maskLayer = self.maskLayer else {
            return
        }
        let maskedColor = UIColor.init(white: 1, alpha: self.shimmeringOpacity)
        let unmaskedColor = UIColor.init(white: 1, alpha: self.shimmeringAnimationOpacity)
        maskLayer.colors = [unmaskedColor.cgColor,maskedColor.cgColor,unmaskedColor.cgColor]
    }
    
    fileprivate func updateMaskLayout() {
        
        guard let contentLayer = self.contentLayer , let maskLayer = self.maskLayer else {
            return
        }
        
        // Everything outside the mask layer is hidden, so we need to create a mask long enough for the shimmered layer to be always covered by the mask.
        var length : CGFloat = 0
        switch self.shimmeringDirection {
        case .down:
            fallthrough
        case .up:
            length = contentLayer.bounds.height 
        case .left:
            fallthrough
        case .right:
            length = contentLayer.bounds.width 
        }
        if length == CGFloat(0) {
            return
        }
        // extra distance for the gradient to travel during the pause.
        let extraDistance = length + self.shimmeringSpeed * CGFloat(self.shimmeringPauseDuration)
        let fullShimmerLength = length * 3.0 + extraDistance
        let travelDistance = length * 2.0 + extraDistance
        
        // position the gradient for the desired width
        let highlightOutsideLength = (1.0 - self.shimmeringHighlightLength) / 2.0
        maskLayer.locations = [NSNumber.init(value: Float(highlightOutsideLength)) , NSNumber.init(value: Float(0.5)) , NSNumber.init(value: Float(1.0 - highlightOutsideLength))]
        
        let startPoint = (length + extraDistance) / fullShimmerLength
        let endPoint = travelDistance / fullShimmerLength
        // position for the start of the animation
        maskLayer.anchorPoint = CGPoint.zero
        
        switch self.shimmeringDirection {
        case .down:
            fallthrough
        case .up:
            maskLayer.startPoint = CGPoint.init(x: 0, y: startPoint)
            maskLayer.endPoint = CGPoint.init(x: 0, y: endPoint)
            maskLayer.position = CGPoint.init(x: 0, y: -travelDistance)
            maskLayer.bounds = CGRect.init(x: 0, y: 0, width: contentLayer.bounds.width, height: fullShimmerLength)
        case .left:
            fallthrough
        case .right:
            maskLayer.startPoint = CGPoint.init(x: startPoint, y: 0)
            maskLayer.endPoint = CGPoint.init(x: endPoint, y: 0)
            maskLayer.position = CGPoint.init(x: -travelDistance, y: 0)
            maskLayer.bounds = CGRect.init(x: 0, y: 0, width:fullShimmerLength , height:contentLayer.bounds.height)
        }
    }
}

extension ULShimmeringLayer: CALayerDelegate, CAAnimationDelegate {

    fileprivate func fade_animation(layer:CALayer, opacity:CGFloat, duration:TimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "opacity")
        if layer.presentation() == nil {
            animation.fromValue = layer.opacity
        }else {
            animation.fromValue = layer.presentation()!.opacity
        }
        animation.toValue = opacity
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        animation.duration = duration
        
        return animation
    }
    
    fileprivate func silde_animation(duration: TimeInterval, direction: ULShimmeringDirection) -> CABasicAnimation{
        let animation = CABasicAnimation.init(keyPath: "position")
        animation.toValue = CGPoint.zero
        animation.duration = duration
        animation.repeatCount = Float.infinity
        if direction == .left || direction == .up {
            animation.speed = -fabsf(animation.speed)
        }
        return animation
    }

    fileprivate func slide_animation_repeat(aniamtion:CAAnimation, duration:TimeInterval, direction:ULShimmeringDirection) -> CAAnimation {
    
        let anim : CAAnimation = aniamtion.copy() as! CAAnimation
        anim.repeatCount = Float.infinity
        anim.duration = duration
        anim.speed = (direction == .right || direction == .down) ? fabsf(anim.speed) : -fabsf(anim.speed)
        return anim
    }
}

class ULShimmeringMaskLayer: CAGradientLayer {
    
    fileprivate let fadeLayer = CALayer()
    
    override init() {
        super.init()
        self.fadeLayer.backgroundColor = UIColor.white.cgColor
        self.addSublayer(self.fadeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.fadeLayer.bounds = self.bounds
        self.fadeLayer.position = CGPoint.init(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
    }
}


