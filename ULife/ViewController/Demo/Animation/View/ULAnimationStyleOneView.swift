//
//  ULAnimationStyleOneView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/4.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
import SnapKit

class ULAnimationStyleOneView: ULAnimationStyleBaseView {

    private let animationButtonOne = ULAnimationButtonOne()
    
    private let animationButtonTwo = ULAnimationButtonTwo()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Load_UI
    private func loadUI(){
    
        animationButtonOne.backgroundColor = UIColor.white
        animationButtonOne.addTarget(self, action: #selector(buttonOne_Pressed), for: .touchUpInside)
        addSubview(animationButtonOne)
        
        animationButtonTwo.backgroundColor = UIColor.white
        animationButtonTwo.addTarget(self, action: #selector(buttonTwo_Pressed), for: .touchUpInside)
        addSubview(animationButtonTwo)
    }
    
    //MARK: - Layout
    private func layout(){
        
        animationButtonOne.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-150)
            make.width.equalTo(54)
            make.height.equalTo(54)
        }
        animationButtonTwo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(animationButtonOne.snp.bottom).offset(20)
            make.width.equalTo(36)
            make.height.equalTo(32)
        }
    }
    
    //MARK: - UIButton_Actions
    @objc private func buttonOne_Pressed(){
        animationButtonOne.showMenu = !animationButtonOne.showMenu
    }
    @objc private func buttonTwo_Pressed(){
        animationButtonTwo.showMenu = !animationButtonTwo.showMenu
    }
}

/// 样式一
class ULAnimationButtonOne: UIButton {
    
    private let shortPath : CGPath = {
    
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: 2, y: 2))
        path.addLine(to: CGPoint.init(x: 28, y: 2))
        return path
    }()
    
    private let outline : CGPath = {
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 10, y: 27))
        path.addCurve(to: CGPoint(x: 40, y: 27), control1: CGPoint(x: 12, y: 27), control2: CGPoint(x: 28.02, y: 27))
        path.addCurve(to: CGPoint(x: 27, y: 02), control1: CGPoint(x: 55.92, y: 27), control2: CGPoint(x: 50.47, y: 2))
        path.addCurve(to: CGPoint(x: 2, y: 27), control1: CGPoint(x: 13.16, y: 2), control2: CGPoint(x: 2, y: 13.16))
        path.addCurve(to: CGPoint(x: 27, y: 52), control1: CGPoint(x: 2, y: 40.84), control2: CGPoint(x: 13.16, y: 52))
        path.addCurve(to: CGPoint(x: 52, y: 27), control1: CGPoint(x: 40.84, y: 52), control2: CGPoint(x: 52, y: 40.84))
        path.addCurve(to: CGPoint(x: 27, y: 2), control1: CGPoint(x: 52, y: 13.16), control2: CGPoint(x: 42.39, y: 2))
        path.addCurve(to: CGPoint(x: 2, y: 27), control1: CGPoint(x: 13.16, y: 2), control2: CGPoint(x: 2, y: 13.16))
        return path
    }()
    
    var topLayer : CAShapeLayer! = CAShapeLayer()
    var bottomLayer : CAShapeLayer! = CAShapeLayer()
    var middleLayer : CAShapeLayer! = CAShapeLayer()
    
    let hamburgerStrokeStart : CGFloat = 0.028
    let hamburgerStrokeEnd : CGFloat = 0.111
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topLayer.path = shortPath
        bottomLayer.path = shortPath
        middleLayer.path = outline
        
        for layer in [topLayer,bottomLayer,middleLayer] {
            layer?.fillColor = nil
            layer?.strokeColor = UIColor.ul_random().cgColor
            layer?.lineWidth = 4
            layer?.miterLimit = 4
            layer?.lineCap = kCALineCapRound
            layer?.masksToBounds = true
            
            let strokePath = CGPath(__byStroking:(layer?.path!)!, transform: nil, lineWidth: 4, lineCap: .round, lineJoin: .miter, miterLimit: 4)
            layer!.bounds = (strokePath?.boundingBoxOfPath)!
            self.layer.addSublayer(layer!)
        }
        
        topLayer.anchorPoint = CGPoint(x: 28.0 / 30.0, y: 0.5)
        topLayer.position = CGPoint(x: 40, y: 18)
        bottomLayer.anchorPoint = CGPoint(x: 28.0 / 30.0, y: 0.5)
        bottomLayer.position = CGPoint(x:40, y:36)
        middleLayer.position = CGPoint(x:27,y:27)
        middleLayer.strokeStart = hamburgerStrokeStart
        middleLayer.strokeEnd = hamburgerStrokeEnd
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let menuStrokeStart : CGFloat = 0.325
    let menuStrokeEnd : CGFloat = 0.9
    
    var showMenu : Bool = false {
        didSet {

            let strokeStart = CABasicAnimation.init(keyPath: "strokeStart");
            let strokeEnd = CABasicAnimation.init(keyPath: "strokeEnd")
            
            if showMenu {
                strokeStart.toValue = menuStrokeStart
                strokeStart.duration = 0.5
                strokeStart.timingFunction = CAMediaTimingFunction.init(controlPoints: 0.25, -0.4, 0.5, 1);
                
                strokeEnd.toValue = menuStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
            }else{
                strokeStart.toValue = hamburgerStrokeStart
                strokeStart.duration = 0.5
                strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0, 0.5, 1.2)
                strokeStart.beginTime = CACurrentMediaTime() + 0.1
                strokeStart.fillMode = kCAFillModeBackwards
                
                strokeEnd.toValue = hamburgerStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.3, 0.5, 0.9)
            }
            
            middleLayer.ul_applyAnimation(strokeStart)
            middleLayer.ul_applyAnimation(strokeEnd)
            
            let topTransform = CABasicAnimation.init(keyPath: "transform")
            topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
            topTransform.duration = 0.4
            topTransform.fillMode = kCAFillModeBackwards
            
            let bottomTransform = topTransform.copy() as! CABasicAnimation
            
            if self.showMenu {
            
                let translation = CATransform3DMakeTranslation(-4, 0, 0)
                
                topTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, -0.7853975, 0, 0, 1))
                topTransform.beginTime = CACurrentMediaTime() + 0.25
                
                bottomTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, 0.7853975, 0, 0, 1))
                bottomTransform.beginTime = CACurrentMediaTime() + 0.25
            }else{
                topTransform.toValue = NSValue(caTransform3D: CATransform3DIdentity)
                topTransform.beginTime = CACurrentMediaTime() + 0.05
                
                bottomTransform.toValue = NSValue(caTransform3D: CATransform3DIdentity)
                bottomTransform.beginTime = CACurrentMediaTime() + 0.05
            }
            topLayer.ul_applyAnimation(topTransform)
            bottomLayer.ul_applyAnimation(bottomTransform)
        }
    }
}

/// 样式二
class ULAnimationButtonTwo: UIButton {
    
    private let topLayer : CAShapeLayer = CAShapeLayer()
    private let middleLayer : CAShapeLayer = CAShapeLayer()
    private let bottomLayer : CAShapeLayer = CAShapeLayer()
    private let layerWidth : CGFloat = 30
    private let topYPosition : CGFloat = 6
    private let middleYPosition : CGFloat = 16
    private let bottomYPosition : CGFloat = 26
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 0, y: 0));
        path.addLine(to: CGPoint.init(x: layerWidth, y: 0))

        for layer in [topLayer,middleLayer,bottomLayer] {
            layer.path = path.cgPath
            layer.lineWidth = 4
            layer.strokeColor = UIColor.red.cgColor
            let strokePath = CGPath(__byStroking: layer.path!, transform: nil, lineWidth: layer.lineWidth, lineCap: .butt, lineJoin:.miter, miterLimit: layer.miterLimit)
            layer.bounds = (strokePath?.boundingBoxOfPath)!
            layer.actions = [
                "transform": NSNull(),
                "position": NSNull()
            ]
            self.layer.addSublayer(layer)
        }
        
        topLayer.position = CGPoint.init(x: layerWidth/2, y: topYPosition)
        middleLayer.position = CGPoint.init(x: layerWidth/2, y: middleYPosition)
        bottomLayer.position = CGPoint.init(x: layerWidth/2, y: bottomYPosition)
    }
    
    var showMenu : Bool = true {
        didSet{
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.4)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))
            
            let topRotation = CAKeyframeAnimation.init(keyPath: "transform")
            topRotation.values = topLayer.ul_rotationValuesFromTransform(topLayer.transform, endValue: showMenu ? CGFloat(-M_PI - M_PI_4) : CGFloat(M_PI + M_PI_4))
            topRotation.calculationMode = kCAAnimationCubic
            topRotation.keyTimes = [0.0,0.33,0.73,1.0]
            topLayer.ul_applyKeyframeValuesAnimation(topRotation)
            
            let verticalOffsetInRotatedState: CGFloat = -0.5
            
            let topPosition = CAKeyframeAnimation.init(keyPath: "position")
            //adjust
            let topPositionEndPoint = CGPoint.init(x: layerWidth/2, y: showMenu ? topYPosition : bottomYPosition + verticalOffsetInRotatedState)
            topPosition.path = topLayer.ul_quadBezierCurveFromPoint(topLayer.position,
                                                                    toPoint: topPositionEndPoint,
                                                                    controlPoint: CGPoint.init(x: layerWidth, y: bottomYPosition/2)).cgPath

            topLayer.ul_applyKeyframePathAniamtion(topPosition, endValue: NSValue.init(cgPoint: topPositionEndPoint))
            topLayer.strokeStart = showMenu ? 0 : 0.3

            let middleRotation = CAKeyframeAnimation.init(keyPath: "transform")
            middleRotation.values = middleLayer.ul_rotationValuesFromTransform(middleLayer.transform, endValue: showMenu ? CGFloat(-M_PI) :CGFloat(M_PI))
            middleLayer.ul_applyKeyframeValuesAnimation(middleRotation)
            middleLayer.strokeEnd = showMenu ? 1.0 : 0.85
            
            let bottomRotation = CAKeyframeAnimation.init(keyPath: "transform")
            bottomRotation.values = bottomLayer.ul_rotationValuesFromTransform(bottomLayer.transform, endValue: showMenu ? CGFloat(-M_PI_2 - M_PI_4) : CGFloat(M_PI_2 + M_PI_4))
            bottomRotation.calculationMode = kCAAnimationCubic
            bottomRotation.keyTimes = [0.0, 0.33, 0.63, 1.0]
            bottomLayer.ul_applyKeyframeValuesAnimation(bottomRotation)
            
            let bottomPosition = CAKeyframeAnimation.init(keyPath: "position")
            //adjust
            let bottomPositionEndPoint = CGPoint.init(x: layerWidth/2, y: showMenu ? bottomYPosition : topYPosition - verticalOffsetInRotatedState)
            bottomPosition.path = bottomLayer.ul_quadBezierCurveFromPoint(bottomLayer.position,
                                                                          toPoint: bottomPositionEndPoint,
                                                                          controlPoint: CGPoint.init(x: 0, y: bottomYPosition/2)).cgPath
            bottomLayer.ul_applyKeyframePathAniamtion(bottomPosition, endValue: NSValue.init(cgPoint: bottomPositionEndPoint))
            bottomLayer.strokeStart = showMenu ? 0 : 0.3
            CATransaction.commit()
        }
    }
    
}


extension CALayer {

    func ul_applyAnimation(_ animation:CABasicAnimation) {
        let copy = animation.copy() as! CABasicAnimation
        
        if copy.fromValue == nil {
            copy.fromValue = presentation()!.value(forKey: copy.keyPath!)
        }
        add(copy, forKey: copy.keyPath)
        setValue(copy.toValue, forKey: copy.keyPath!)
    }
    
    func ul_rotationValuesFromTransform(_ transform:CATransform3D, endValue:CGFloat) -> [NSValue] {
        return (0..<4).map{ num in
            NSValue.init(caTransform3D: CATransform3DRotate(transform, endValue / CGFloat(3) * CGFloat(num), 0, 0, 1))
        }
    }
    
    func ul_applyKeyframeValuesAnimation(_ animation:CAKeyframeAnimation) {
        guard let copy = animation.copy() as? CAKeyframeAnimation ,
            let values = copy.values ,
            !values.isEmpty,
            let keypath = copy.keyPath else {
            return
        }
        add(copy, forKey: keypath)
        setValue(values[values.count - 1], forKey: keypath)
    }
    
    func ul_quadBezierCurveFromPoint(_ startPoint : CGPoint, toPoint : CGPoint, controlPoint : CGPoint) -> UIBezierPath {
        let quadPath = UIBezierPath()
        quadPath.move(to: startPoint)
        quadPath.addQuadCurve(to: toPoint, controlPoint: controlPoint)
        return quadPath
    }
    
    func ul_applyKeyframePathAniamtion(_ animation:CAKeyframeAnimation, endValue:NSValue){
    
        let copy = animation.copy() as! CAKeyframeAnimation
        add(copy, forKey: copy.keyPath)
        setValue(endValue, forKey: copy.keyPath!)
    }
}
