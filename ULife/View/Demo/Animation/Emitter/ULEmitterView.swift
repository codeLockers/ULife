//
//  ULEmitterView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

enum ULEmitterViewPosition : CGFloat {
    case center = 0.0
    case left = 1.0
    case right = 2.0
}

class ULEmitterView: UIView {

    var images : [UIImage]?
    var positionType : ULEmitterViewPosition = .left
    var itemSize = CGSize.init(width: 36, height: 36)
    var emitterCount = 0
    var timer : Timer?
    var itemReusePool = Set<CALayer>()
    var itemDisplayPool = [CALayer]()
    var isPaused = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }

}

extension ULEmitterView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.fireEmitterCount(10)
    }
    
    fileprivate func fireEmitterCount(_ count:Int) {
        self.emitterCount += count
        self.createTimer()
    }
    
    func pause() {
        
        self.isPaused = true
        let pauseTime = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.layer.speed = 0
        self.layer.timeOffset = pauseTime
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func resume() {
        if !self.isPaused {
            return
        }
        let pausedTime = self.layer.timeOffset
        self.layer.speed = 1.0;
        self.layer.timeOffset = 0.0;
        self.layer.beginTime = 0.0;
        let timeSincePause = self.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.layer.beginTime = timeSincePause;
        self.isPaused = false;
        self.createTimer()
    }
    
}

extension ULEmitterView : CAAnimationDelegate {
    
    fileprivate func createTimer() {
        self.timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    @objc fileprivate func fire() {
        if self.emitterCount <= 0 {
            return
        }
        
        self.emitterCount -= 1
        
        let layer = self.dequeueReuseItem()
        self.layer.addSublayer(layer!)
        self.itemDisplayPool.append(layer!)
        
        let position : CGFloat = CGFloat(arc4random_uniform(3));
        let path = self.path(position: ULEmitterViewPosition(rawValue: position) ?? .left)
        
        if path == nil {
            return
        }
        let aniamtionDuratuion : CFTimeInterval = 7

        let positionAniamation = CAKeyframeAnimation.init(keyPath: "position")
        positionAniamation.path = path?.cgPath
        positionAniamation.duration = aniamtionDuratuion
        
        let rotateAniamation = CAKeyframeAnimation.init(keyPath: "transform.rotation.z")
        let scaleRotate : CGFloat = CGFloat((1 + arc4random() % 6) / 10)
        rotateAniamation.values = [0, (.pi / 4) * position * scaleRotate, -(.pi / 4) * position * scaleRotate]
        rotateAniamation.duration = aniamtionDuratuion
        
        let alphaAniamtion = CABasicAnimation.init(keyPath: "opacity")
        alphaAniamtion.fromValue = 0.9
        alphaAniamtion.toValue = 0
        alphaAniamtion.duration = aniamtionDuratuion
        
        let scaleAniamtion = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAniamtion.fromValue = 0
        scaleAniamtion.toValue = 1
        scaleAniamtion.duration = 0.2

        let aniamtionGroup = CAAnimationGroup()
        aniamtionGroup.repeatCount = 1
        aniamtionGroup.isRemovedOnCompletion = false
        aniamtionGroup.duration = aniamtionDuratuion
        aniamtionGroup.fillMode = kCAFillModeForwards
        aniamtionGroup.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        aniamtionGroup.animations = [positionAniamation, rotateAniamation, alphaAniamtion, scaleAniamtion]
        aniamtionGroup.delegate = self;
        layer?.add(aniamtionGroup, forKey: "com.codeLocker")
    }
    
    fileprivate func dequeueReuseItem() -> CALayer? {
        
        var layer = self.itemReusePool.first
        if layer != nil {
            self.itemReusePool.remove(layer!)
            return layer
        }
        layer = CALayer()
        layer?.frame = CGRect.init(x: 0, y: 0, width: self.itemSize.width, height: self.itemSize.height)
        if self.images == nil || self.images?.count == 0 {
            return nil
        }
        let index = arc4random_uniform(UInt32(self.images!.count))
        let image : UIImage = self.images![Int(index)]
        layer?.contents = image.cgImage
        return layer
    }
    
    fileprivate func path(position:ULEmitterViewPosition) -> UIBezierPath? {
    
        var center_x : CGFloat = 0
        switch position {
        case .left:
            center_x = self.ul_width / 2.0
        case .center:
            center_x = self.ul_width / 2.0 - 15
            if center_x < 0 {
                center_x = self.ul_width / 2.0
            }
        case .right:
            center_x = self.ul_width / 2.0 + 15
            if center_x > self.ul_width {
                center_x = self.ul_width / 2.0
            }
        }
        
        var random : CGFloat = CGFloat(arc4random_uniform(4))
        let path = UIBezierPath()

        // startPoint
        let start_y = self.ul_height - random
        let start_x = center_x + random * position.rawValue
        path.move(to: CGPoint.init(x: start_x, y: start_y))
    
        // control point
        random = CGFloat((arc4random() % 91) + 10)
        var random_y : CGFloat = CGFloat((arc4random() % 91) + 15)
        
        let control1_x = center_x - (position.rawValue * random)
        let control1_y = self.ul_height * 0.5 + (random_y * position.rawValue)
        let control1_p = CGPoint.init(x: control1_x, y: control1_y)

        let control2_x = center_x + ((random - 12.0) * position.rawValue)
        let control2_y = control1_y;
        let control2_p = CGPoint.init(x: control2_x, y: control2_y)

        // endPoint
        random_y = CGFloat((arc4random() % 21) + 15)
        random = CGFloat((arc4random() % 15) + 15)
        let end_y = random_y + position.rawValue;
        let end_x = start_x + (random * position.rawValue);
        let end_p = CGPoint.init(x: end_x, y: end_y)
        
        path.addCurve(to: end_p, controlPoint1: control1_p, controlPoint2: control2_p)
        return path
    }
}
