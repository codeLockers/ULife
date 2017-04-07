//
//  ULPageControlAji.swift
//  ULife
//
//  Created by codeLocker on 2017/3/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULPageControlAji: ULBasePageControl {

    fileprivate var diameter: CGFloat {
        return radius * 2
    }
    
    fileprivate var inactive = [ULPageControlLayer]()
    fileprivate var active = ULPageControlLayer()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func updateNumberOfPages(_ count: Int) {
        inactive.forEach() { $0.removeFromSuperlayer() }
        inactive = [ULPageControlLayer]()
        inactive = (0..<count).map {_ in
            let layer = ULPageControlLayer()
            self.layer.addSublayer(layer)
            return layer
        }
        
        self.layer.addSublayer(active)
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    override func layout() {
        
        let floatCount = CGFloat(inactive.count)
        let x = (self.frame.size.width - self.diameter*floatCount - self.padding*(floatCount-1))*0.5
        let y = (self.frame.size.height - self.diameter)*0.5
        var frame = CGRect(x: x, y: y, width: self.diameter, height: self.diameter)
        
        active.cornerRadius = self.radius
        active.backgroundColor = self.tintColor.cgColor
        active.frame = frame
        
        inactive.forEach() { layer in
            layer.backgroundColor = self.tintColor.withAlphaComponent(self.inactiveTransparency).cgColor
            if self.borderWidth > 0 {
                layer.borderWidth = self.borderWidth
                layer.borderColor = self.tintColor.cgColor
            }
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += self.diameter + self.padding
        }
    }
    
    override func update(for progress: Double) {
        guard let min = inactive.first?.frame,
            let max = inactive.last?.frame,
            progress >= 0 && progress <= Double(numberOfPages - 1) else {
                return
        }
        
        let total = Double(numberOfPages - 1)
        let dist = max.origin.x - min.origin.x
        let percent = CGFloat(progress / total)
        
        let offset = dist * percent
        active.frame.origin.x = min.origin.x + offset
    }
    
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(inactive.count) * self.diameter + CGFloat(inactive.count - 1) * self.padding,
                      height: self.diameter)
    }
}
