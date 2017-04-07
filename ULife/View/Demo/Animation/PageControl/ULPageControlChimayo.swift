//
//  ULPageControlChimayo.swift
//  ULife
//
//  Created by codeLocker on 2017/3/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULPageControlChimayo: ULBasePageControl {

    fileprivate var diameter : CGFloat {
        return radius * 2
    }
    
    fileprivate var elements = [ULPageControlLayer]()
    
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
        elements.forEach { $0.removeFromSuperlayer() }
        elements = [ULPageControlLayer]()
        elements = (0..<count).map({ _ in
            let layer = ULPageControlLayer()
            self.layer.addSublayer(layer)
            return layer
        })
    }
    
    override func layout() {
        let floatCount = CGFloat(elements.count)
        let x = (self.ul_width - diameter * floatCount - self.padding * (floatCount - 1))/2.0
        let y = (self.ul_height - diameter)/2.0
        var frame = CGRect.init(x: x, y: y, width: diameter, height: diameter)
        
        elements.forEach { (layer) in
            layer.cornerRadius = self.radius
            layer.frame = frame
            layer.backgroundColor = self.tintColor.cgColor
            frame.origin.x += diameter + self.padding
        }
    }
    
    override func update(for progress: Double) {
        
        guard progress >= 0 && progress <= Double(self.numberOfPages - 1) else {
            return
        }
        //item的rect 内缩1个pt
        let rect = CGRect(x: 0, y: 0, width: self.diameter, height: self.diameter).insetBy(dx: 1, dy: 1)
        let left = floor(progress)
        let page = Int(progress)
        let move = rect.width / 2
        //随着滑动右侧空心圆填充的偏移量
        let rightInset = move * CGFloat(progress - left)
        let rightRect = rect.insetBy(dx: rightInset, dy: rightInset)
        //随着滑动左侧空心圆填充的偏移量
        let leftInset = (1 - CGFloat(progress - left)) * move
        let leftRect = rect.insetBy(dx: leftInset, dy: leftInset)
        
        let mask = { (index: Int, layer: ULPageControlLayer) in
            let mask = CAShapeLayer()
            mask.fillRule = kCAFillRuleEvenOdd
            let bounds = UIBezierPath(rect: layer.bounds)
            switch index {
            case page:
                bounds.append(UIBezierPath(ovalIn: leftRect))
            case page + 1:
                bounds.append(UIBezierPath(ovalIn: rightRect))
            default:
                bounds.append(UIBezierPath(ovalIn: rect))
            }
            mask.path = bounds.cgPath
            layer.mask = mask
        }
        
        for (index, layer) in elements.enumerated() {
            mask(index, layer)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: CGFloat(elements.count) * self.diameter + CGFloat(elements.count - 1) * self.padding, height: self.diameter)
    }
}
