//
//  ULPageControlPaprika.swift
//  ULife
//
//  Created by codeLocker on 2017/3/21.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULPageControlPaprika: ULBasePageControl {
    //直径
    fileprivate var diameter : CGFloat {
        return radius * 2
    }
    
    fileprivate var elements = [ULPageControlLayer]()
    
    fileprivate var frames = [CGRect]()
    fileprivate var min : CGRect?
    fileprivate var max : CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Override_Methods
    override func updateNumberOfPages(_ count: Int) {
        elements.forEach { $0.removeFromSuperlayer() }
        elements = [ULPageControlLayer]()
        elements = (0..<numberOfPages).map({ _ in
            let layer = ULPageControlLayer()
            self.layer.addSublayer(layer)
            return layer
        })
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    override func layout() {
        let floatCount = CGFloat(elements.count)
        let x = (self.ul_width - diameter * floatCount - self.padding * (floatCount - 1))/2.0
        let y = (self.ul_height - diameter)/2.0
        var frame = CGRect.init(x: x, y: y, width: diameter, height: diameter)
        
        elements.forEach { (layer) in
            layer.backgroundColor = self.tintColor.withAlphaComponent(self.inactiveTransparency).cgColor
            if self.borderWidth > 0 {
                layer.borderWidth = self.borderWidth
                layer.borderColor = self.tintColor.cgColor
            }
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += self.diameter + self.padding
        }
        
        if let active = elements.first {
            active.backgroundColor = self.tintColor.cgColor
        }
        
        min = elements.first?.frame
        max = elements.last?.frame
        self.frames = elements.map{ $0.frame }
    }
    
    override func update(for progress:Double) {
    
        guard let min = self.min , let max = self.max else {
            return
        }
        
        var progress = progress
        
        if progress < 0 {
            progress = 0
        }
        
        let total = Double(self.numberOfPages - 1)
        if progress > total {
            progress = total
        }
        
        let page = Int(progress)
        for (index, _) in self.frames.enumerated() {
            
            if page > index {
                
            }else if page < index {
            
            }
        }
        //每次item交换位置的时候，更新item的新的frame
        for (index, _) in self.frames.enumerated() {
            if page > index {
                self.elements[index+1].frame = self.frames[index]
            } else if page < index {
                self.elements[index].frame = self.frames[index]
            }
        }
        
        let dist = max.origin.x - min.origin.x
        let percent = CGFloat(progress / total)
        let offset = dist * percent
        
        guard let active = elements.first else {
            return
        }
        let x = min.origin.x + offset
        //每个item圆心之间的距离
        let spacePerItem = self.padding + self.diameter
        //旋转半径
        let r = spacePerItem/2.0
        //旋转方向
        let yDirection : CGFloat = page%2 == 1 ? 1 : -1
        //x坐标
        active.frame.origin.x = x
        //x轴相对于起始位置的位移
        let xBetweenPoints = x - CGFloat(page)*spacePerItem - min.origin.x
        //y轴坐标
        let y = sqrt(pow(Double(r), 2) - pow(fabs(Double(r)-Double(xBetweenPoints)),2))
        active.frame.origin.y = y.isNaN ? 0 : CGFloat(y)*yDirection + min.origin.y
        //是否是最后一个
        let index = page + 1
        guard elements.indices.contains(index) else {
            return
        }
        let element = elements[index]
        guard frames.indices.contains(page), frames.indices.contains(page + 1) else { return }

        let prev = frames[page]
        let current = frames[page + 1]
        element.frame = prev
        element.frame.origin.x += current.origin.x - active.frame.origin.x
        element.frame.origin.y = 2*min.origin.y - active.frame.origin.y
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: CGFloat(elements.count) * self.diameter + CGFloat(elements.count - 1) * self.padding, height: self.diameter)
    }
}
