//
//  ULPageControlJalapeno.swift
//  ULife
//
//  Created by codeLocker on 2017/3/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULPageControlJalapeno: ULBasePageControl {

    fileprivate var diameter : CGFloat {
        return radius * 2
    }
    
    internal var lastPage:Int = 0
    
    fileprivate var inactive = [ULPageControlLayer]()
    
    fileprivate lazy var active : ULPageControlLayer = { [unowned self] in
        let layer = ULPageControlLayer()
        layer.fillColor = self.tintColor.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layout()
        update(for: progress)
    }
    
    override func updateNumberOfPages(_ count: Int) {
        
        inactive.forEach{ $0.removeFromSuperlayer() }
        inactive = [ULPageControlLayer]()
        inactive = (0..<count).map({ _ in
            let layer = ULPageControlLayer()
            self.layer.addSublayer(layer)
            return layer
        })
        
        self.layer.addSublayer(active)
        
    }
    
    override func layout() {
        let floatCount = CGFloat(inactive.count)
        let x = (self.ul_width - self.diameter * floatCount - self.padding * (floatCount - 1))/2.0
        let y = (self.ul_height - self.diameter)/2.0
        var frame = CGRect.init(x: x, y: y, width: self.diameter, height: self.diameter)
        
        inactive.forEach { (layer) in
            layer.backgroundColor = self.tintColor.withAlphaComponent(self.inactiveTransparency).cgColor
            if borderWidth > 0 {
                layer.borderWidth = self.borderWidth
                layer.borderColor = self.tintColor.cgColor
            }
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += self.diameter + self.padding
        }
        self.active.fillColor = self.tintColor.cgColor
    }
    
    override func update(for progress: Double) {
        
        guard progress >= 0 && progress <= Double(numberOfPages - 1),
            let firstFrame = self.inactive.first?.frame else {
                return
        }
        //第一个元素的x坐标
        let left = firstFrame.origin.x
        //每次滑动一页item的X偏移量=diameter+padding
        let normalized = progress * Double(diameter + padding)
        //当前页
        let currentPage = Int(progress)
        let stepSize = (diameter + padding)
        //item的minX的数值,只有在整页变化是才变化
        var leftX = CGFloat(currentPage)*stepSize+left
        //item的maxX的数组，跟随滑动进度变化
        var rightX = CGFloat(normalized)+left
        //在每一个item之间的相对progress
        let stepProgress = progress - Double(currentPage)
        
        if abs(self.lastPage - currentPage) > 1 {
            self.lastPage = self.lastPage + (self.lastPage < currentPage ? 1 : -1)
        }
        
        var middleX = CGFloat(normalized)
        if stepProgress > 0.5 {
            if self.lastPage > currentPage {
                rightX = CGFloat(self.lastPage)*stepSize + left
                leftX = leftX + ((CGFloat(stepProgress)-0.5)*stepSize*2)
                middleX = leftX
            } else {
                leftX = leftX + ((CGFloat(stepProgress)-0.5)*stepSize*2)
                rightX = CGFloat(self.currentPage)*stepSize + left
                middleX = rightX
            }
        } else if self.lastPage > currentPage {
            rightX = CGFloat(self.lastPage)*stepSize - ((0.5-CGFloat(stepProgress))*stepSize*2) + left
            middleX = leftX
        } else {
            rightX = rightX + (CGFloat(stepProgress)*stepSize)
            middleX = rightX
        }
        
        let top = (self.frame.size.height - self.diameter)*0.5
        
        let points:[CGPoint] = [
            CGPoint(x:leftX, y:radius + top),
            CGPoint(x:middleX+radius, y:top),
            CGPoint(x:rightX+radius*2, y:radius + top),
            CGPoint(x:middleX+radius, y:radius*2 + top)
        ]
        
        let offset: CGFloat = radius*0.55
        
        let path = UIBezierPath()
        path.move(to: points[0])
        path.addCurve(to: points[1], controlPoint1: CGPoint(x:points[0].x, y: points[0].y-offset), controlPoint2: CGPoint(x:points[1].x-offset, y: points[1].y))
        path.addCurve(to: points[2], controlPoint1: CGPoint(x:points[1].x+offset, y: points[1].y), controlPoint2: CGPoint(x:points[2].x, y: points[2].y-offset))
        path.addCurve(to: points[3], controlPoint1: CGPoint(x:points[2].x, y: points[2].y+offset), controlPoint2: CGPoint(x:points[3].x+offset, y: points[3].y))
        path.addCurve(to: points[0], controlPoint1: CGPoint(x:points[3].x-offset, y: points[3].y), controlPoint2: CGPoint(x:points[0].x, y: points[0].y+offset))
        self.active.path = path.cgPath
        //浮点数取余
        if progress.truncatingRemainder(dividingBy: 1) == 0 {
            self.lastPage = Int(progress)
        }

    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: CGFloat(inactive.count) * self.diameter + CGFloat(inactive.count - 1) * self.padding, height: self.diameter)
    }
}
