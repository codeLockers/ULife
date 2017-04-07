//
//  ULPageControlPuya.swift
//  ULife
//
//  Created by codeLocker on 2017/3/21.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULPageControlPuya: ULBasePageControl {
    //item的直径
    fileprivate var diameter : CGFloat {
        return radius * 2
    }

    fileprivate var elements = [ULPageControlLayer]()
    fileprivate var min : CGRect?
    fileprivate var max : CGRect?
    fileprivate var frames = [CGRect]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override_Methods
    override func updateNumberOfPages(_ count: Int) {
        //移除原先的item
        elements.forEach(){ $0.removeFromSuperlayer()}
        elements = [ULPageControlLayer]()
        elements = (0..<count).map{ _ in
            let layer = ULPageControlLayer()
            self.layer.addSublayer(layer)
            return layer
        }
    }
    
    override func layoutSubviews() {
        layout()
        self.invalidateIntrinsicContentSize()
    }
    
    
    override func layout() {
        //number of item
        let floatCount = CGFloat(elements.count)
        //起始x坐标
        let x = (self.ul_width - self.diameter*floatCount - self.padding*(floatCount - 1))/2.0
        //起始y坐标
        let y = (self.ul_height - self.diameter)/2.0
        //第一个item的坐标
        var frame = CGRect.init(x: x, y: y, width: self.diameter, height: self.diameter)
        
        elements.forEach { (layer) in
            //设置每个item
            layer.backgroundColor = self.tintColor.withAlphaComponent(self.inactiveTransparency).cgColor
            if self.borderWidth > 0 {
                layer.borderColor = self.tintColor.cgColor
                layer.borderWidth = self.borderWidth
            }
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += self.diameter + self.padding
        }
        //第一个item为选中状态
        if let active = elements.first {
            active.backgroundColor = tintColor.cgColor
            active.borderWidth = 0
        }
        //第一item的frame
        self.min = elements.first?.frame
        //最后一个item的frame
        self.max = elements.last?.frame
        self.frames = elements.map{ $0.frame }
    }
    
    override func update(for progress:Double) {
        
        guard let min = self.min, let max = self.max, progress > 0 && progress <= Double(numberOfPages - 1) else {
            return
        }
        
        let total = Double(numberOfPages - 1)
        let dist = max.origin.x - min.origin.x
        let percent = CGFloat(progress / total)
        let page = Int(progress)
        //x轴的位移量
        let offset = dist * percent
        guard let active = elements.first else { return }
        active.frame.origin.x = min.origin.x + offset
        //下一个item
        let index = page + 1
        //下标范围
        guard elements.indices.contains(index) else { return }
        let element = elements[index]
        guard frames.indices.contains(page), frames.indices.contains(page + 1) else { return }

        let prev = frames[page]
        let current = frames[page + 1]
        element.frame = prev
        element.frame.origin.x += current.origin.x - active.frame.origin.x
    }
    
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(elements.count) * self.diameter + CGFloat(elements.count - 1) * self.padding,
                      height: self.diameter)
    }
}
