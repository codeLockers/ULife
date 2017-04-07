//
//  ULGesturePasswordDrawView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/5.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

@objc
protocol ULGesturePasswordDrawViewDelegate : NSObjectProtocol {
    @objc optional func gesturePasswordDrawView(_ drawView:ULGesturePasswordDrawView , success password:String)
}

class ULGesturePasswordDrawView: UIView {
    
    fileprivate let itemMargin : CGFloat = 10.0
    fileprivate var items = [ULGesturePasswordCircle]()
    fileprivate var selectedItems = [ULGesturePasswordCircle]()
    fileprivate var currentTouchPoint : CGPoint = CGPoint.zero
    
    weak var delegate : ULGesturePasswordDrawViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Load
    private func loadUI() {
        self.backgroundColor = .clear
        for i in 0..<9 {
            let item = ULGesturePasswordCircle()
            item.tag = i
            self.addSubview(item)
            self.items.append(item)
        }
    }
    
    override func layoutSubviews() {
        let itemWidth = (self.ul_width - itemMargin * 6) / 3.0
        for i in 0..<9 {
            let item = self.items[i]
            item.frame = CGRect.init(x: (itemWidth + 2 * itemMargin) * CGFloat(i%3) + itemMargin, y: (itemWidth + 2 * itemMargin) * CGFloat(i/3) + itemMargin, width: itemWidth, height: itemWidth)
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard self.selectedItems.count > 0 else {
            return
        }
        let color = (self.currentState() == .error || self.currentState() == .lastError) ? UIColor.red : UIColor.blue
        self.drawLine(inRect: rect, color: color)
    }
}

extension ULGesturePasswordDrawView {
    
    fileprivate func currentState() -> ULGesturePasswordCircleState {
        return self.items.first?.state ?? .normal
    }
    
    fileprivate func drawLine(inRect rect:CGRect, color:UIColor) {
        
        let context = UIGraphicsGetCurrentContext()
        //进行裁剪
        context?.addRect(rect)
        _ = self.items.map { (item) in
            context?.addEllipse(in: item.frame)
        }
        context?.clip(using: .evenOdd)
        //遍历数组中的item 并以此连接
        for item in self.selectedItems {
            let index = self.selectedItems.index(of: item)
            if index == 0 {
                context?.move(to: item.center)
            }else {
                context?.addLine(to: item.center)
            }
        }
        //连接最后一个按钮到手指的位置
        context?.addLine(to: self.currentTouchPoint)
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(2)
        color.set()
        context?.strokePath()
    }
    
    fileprivate func connectSkipItem() {
        
        guard self.selectedItems.count > 1 else {
            return
        }
        
        let lastItem = self.selectedItems.last
        let penultItem = self.selectedItems[self.selectedItems.count - 2]
        //两者中心点的位置
        let lastItem_x = lastItem?.center.x
        let lastItem_y = lastItem?.center.y
        let penultItem_x = penultItem.center.x
        let penultItem_y = penultItem.center.y
        //计算角度
        let angle = atan2f(Float(lastItem_y! - penultItem_y), Float(lastItem_x! - penultItem_x)) + .pi / 2.0
        penultItem.angle = angle
        //处理跳跃线段
        let point = CGPoint.init(x: (lastItem_x! + penultItem_x) / 2.0, y: (lastItem_y! + penultItem_y) / 2.0)
        _ = self.items.map({ (item) in
            if item.frame.contains(point) && !self.selectedItems.contains(item) {
                item.state = .selected
                item.angle = self.selectedItems[self.selectedItems.count - 2].angle
                self.selectedItems.insert(item, at: self.selectedItems.count - 1)
            }
        })
    }
    
    fileprivate func setLastSelectItemState(_ state:ULGesturePasswordCircleState) {
        self.selectedItems.last?.state = state
    }
    fileprivate func setAllSelectItemState(_ state:ULGesturePasswordCircleState) {
        _ = self.selectedItems.map { $0.state = state }
    }
    fileprivate func resetAllSelectItem() {
        _ = self.selectedItems.map { $0.state = .normal }
        self.selectedItems.removeAll()
        self.setNeedsDisplay()
    }
    
    /// 获取设置的密码
    fileprivate func getPassword() -> String {
        var password = ""
        _ = self.selectedItems.map({ (item) in
            password += "\(item.tag)"
        })
        return password
    }
}

extension ULGesturePasswordDrawView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point  = touch?.location(in: self)
        _ = self.items.filter({ (item) -> Bool in
            if item.frame.contains(point!) {
                item.state = .selected
                self.selectedItems.append(item)
                return true
            }
            return false
        })
        self.setLastSelectItemState(.lastSelected)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point  = touch?.location(in: self)
        _ = self.items.filter { (item) -> Bool in
            if item.frame.contains(point!) {
                if !self.selectedItems.contains(item) {
                    item.state = .selected
                    self.selectedItems.append(item)
                    self.connectSkipItem()
                    return true
                }
            }
            return false
        }
        self.currentTouchPoint = point!
        self.setAllSelectItemState(.selected)
        self.setLastSelectItemState(.lastSelected)
        self.setNeedsDisplay()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.gesturePasswordDrawView?(self, success: self.getPassword())
        self.resetAllSelectItem()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
    }
}
