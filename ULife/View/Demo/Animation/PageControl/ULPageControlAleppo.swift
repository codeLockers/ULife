//
//  ULPageControlAleppo.swift
//  ULife
//
//  Created by codeLocker on 2017/3/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULPageControlAleppo: ULBasePageControl {

    fileprivate var diameter : CGFloat {
        return radius * 2
    }
    
    fileprivate var inactive = [ULPageControlLayer]()
    
    fileprivate lazy var active : ULPageControlLayer = { [unowned self] in
    
        let layer = ULPageControlLayer()
        layer.frame = CGRect.init(origin: .zero, size: CGSize.init(width: self.diameter, height: self.diameter))
        layer.backgroundColor = self.tintColor.cgColor
        layer.cornerRadius = self.radius
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func layoutSubviews() {
        layout()
        update(for: progress)
    }
    
    override func layout() {
        
        let floatCount = CGFloat(self.numberOfPages)
        let x = (self.ul_width - diameter * floatCount - self.padding * (floatCount - 1))/2.0
        let y = (self.ul_height - self.diameter)/2.0
        var frame = CGRect.init(x: x, y: y, width: self.diameter, height: self.diameter)
        
        active.cornerRadius = self.radius
        active.backgroundColor = self.tintColor.cgColor
        active.frame = frame
        
        inactive.forEach { (layer) in
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
        guard progress >= 0 && progress <= Double(self.numberOfPages - 1) ,let firstFrame = self.inactive.first?.frame else {
            return
        }
        
        let normalized = progress * Double(diameter + padding)
        let distance = abs(round(progress) - progress)
        let mult = 1 + distance * 2

        var frame = active.frame
        frame.origin.x = CGFloat(normalized) + firstFrame.origin.x
        frame.size.width = frame.height * CGFloat(mult)
        active.frame = frame
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: CGFloat(inactive.count) * self.diameter + CGFloat(inactive.count - 1) * self.padding, height: self.diameter)
    }
}
