//
//  ULPageControlFresno.swift
//  ULife
//
//  Created by codeLocker on 2017/3/21.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULPageControlFresno: ULBasePageControl {

    fileprivate var diameter : CGFloat {
        return radius * 2
    }
    
    fileprivate var elements = [ULPageControlLayer]()
    fileprivate var min : CGRect?
    fileprivate var max : CGRect?
    fileprivate var frames = [CGRect]()

    override func updateNumberOfPages(_ count: Int) {
        elements.forEach { $0.removeFromSuperlayer() }
        elements = [ULPageControlLayer]()
        elements = (0..<count).map({ _ in
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
        let x = (self.ul_width - floatCount * diameter - self.padding * (floatCount - 1))/2.0
        let y = (self.ul_height - diameter)/2.0
        var frame = CGRect.init(x: x, y: y, width: diameter, height: diameter)
        
        elements.forEach { (layer) in
            layer.backgroundColor = self.tintColor.withAlphaComponent(self.inactiveTransparency).cgColor
            if self.borderWidth > 0 {
                layer.borderWidth = borderWidth
                layer.borderColor = self.tintColor.cgColor
            }
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += self.padding + diameter
        }
        
        if let active = elements.first{
            active.backgroundColor = self.tintColor.cgColor
            active.borderWidth = 0
        }
        
        min = elements.first?.frame
        max = elements.last?.frame
        
        self.frames = elements.map{ $0.frame }
    }
    
    override func update(for progress: Double) {
        guard let min = self.min,
            let max = self.max,
            progress >= 0 && progress <= Double(numberOfPages - 1) else {
                return
        }
        
        let total = Double(numberOfPages - 1)
        let dist = max.origin.x - min.origin.x
        let percent = CGFloat(progress / total)
        let page = Int(progress)
        
        for (index, _) in self.frames.enumerated() {
            if page > index {
                self.elements[index+1].frame = self.frames[index]
            } else if page < index {
                self.elements[index].frame = self.frames[index]
            }
        }
        
        let offset = dist * percent
        guard let active = elements.first else { return }
        active.frame.origin.x = min.origin.x + offset
        
        let index = page + 1
        guard elements.indices.contains(index) else { return }
        let element = elements[index]
        guard frames.indices.contains(index - 1), frames.indices.contains(index) else { return }
        
        let prev = frames[index - 1]
        let current = frames[index]
        
        let elementTotal: CGFloat = current.origin.x - prev.origin.x
        let elementProgress: CGFloat = current.origin.x - active.frame.origin.x
        let elementPercent = (elementTotal - elementProgress) / elementTotal
        
        // x: input, a: input min, b: input max, c: output min, d: output max
        // returns mapped value x from (a,b) to (c, d)
        let linearTransform = { (x: CGFloat, a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat) -> CGFloat in
            return (x - a) / (b - a) * (d - c) + c
        }
        
        element.frame = prev
        element.frame.origin.x = linearTransform(elementPercent, 1.0, 0.0, prev.origin.x, current.origin.x)
        
        if elementPercent <= 0.5 {
            let originY = linearTransform(elementPercent, 0.0, 0.5, 0, self.radius + self.padding)
            element.frame.origin.y = (page % 2 == 0 ? originY : -originY) + min.origin.y
        } else {
            let originY = linearTransform(elementPercent, 0.5, 1.0, self.radius + self.padding, 0)
            element.frame.origin.y = (page % 2 == 0 ? originY : -originY) + min.origin.y
        }
        active.frame.origin.y = 2*min.origin.y - element.frame.origin.y

    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: CGFloat(elements.count) * self.diameter + CGFloat(elements.count - 1) * self.padding, height: self.diameter)
    }
}
