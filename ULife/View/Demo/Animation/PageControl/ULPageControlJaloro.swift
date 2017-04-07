//
//  ULPageControlJaloro.swift
//  ULife
//
//  Created by codeLocker on 2017/3/21.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULPageControlJaloro: ULBasePageControl {
    //item的宽度
    open var elememtWidth : CGFloat = 20 {
        didSet {
            layout()
        }
    }
    //item的高度
    open var elementHeigth : CGFloat = 6 {
        didSet {
            layout()
        }
    }
    //静态item
    fileprivate var inactive = [ULPageControlLayer]()
    //动态item
    fileprivate var active = ULPageControlLayer()
    
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
    }
    
    override func layout() {
        
        let floatCount = CGFloat(inactive.count)
        let x = (self.ul_width - self.elememtWidth*floatCount - self.padding*(floatCount-1))/2.0
        let y = (self.ul_height - self.elementHeigth)/2.0
        var frame = CGRect.init(x: x, y: y, width: elememtWidth, height: elementHeigth)
        
        active.backgroundColor = self.tintColor.cgColor
        active.cornerRadius = radius
        active.frame = frame
        
        inactive.forEach { (layer) in
            layer.backgroundColor = self.tintColor.withAlphaComponent(self.inactiveTransparency).cgColor
            if self.borderWidth > 0 {
                layer.borderWidth = self.borderWidth
                layer.borderColor = self.tintColor.cgColor
            }
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += elememtWidth + self.padding
        }
    }
    
    override func update(for progress: Double) {
        
        guard let min = inactive.first?.frame , let max = inactive.last?.frame , progress >= 0 && progress <= Double(self.numberOfPages - 1) else {
            return
        }
        let dist = max.origin.x - min.origin.x
        let percent = CGFloat(progress / Double(self.numberOfPages - 1))
        
        let offset = percent * dist
        active.frame.origin.x = min.origin.x + offset
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: CGFloat(inactive.count) * self.elememtWidth + CGFloat(inactive.count - 1) * self.padding, height: self.elementHeigth)
    }
}
