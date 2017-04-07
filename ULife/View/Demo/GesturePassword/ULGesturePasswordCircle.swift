//
//  ULGesturePasswordCircle.swift
//  ULife
//
//  Created by codeLocker on 2017/4/5.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

enum ULGesturePasswordCircleState {
    case normal /** 未选中状态*/
    case selected /** 选中状态*/
    case error /** 错误状态*/
    case lastSelected /** 最后一个选中状态,不显示三角箭头*/
    case lastError /** 最后一个错误状态,不显示三角箭头*/
}

class ULGesturePasswordCircle: UIView {

    var state : ULGesturePasswordCircleState = .normal {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var angle : Float = 0 {
        didSet {

            self.setNeedsDisplay()
        }
    }
    
    fileprivate let lineWidth : CGFloat = 1
    fileprivate let trangleLength : CGFloat = 10
    
    fileprivate var outCircleColor : UIColor {
        get {
            switch self.state {
            case .normal:
                return .black
            case .selected:
                fallthrough
            case .lastSelected:
                return .blue
            case .error:
                fallthrough
            case .lastError:
                return .red
            }
        }
    }
    
    fileprivate var inCircleColor : UIColor {
        get {
            switch self.state {
            case .normal:
                return .black
            case .selected:
                fallthrough
            case .lastSelected:
                return .blue
            case .error:
                fallthrough
            case .lastError:
                return .red
            }
        }
    }
    
    fileprivate var trangleColor : UIColor {
        get {
            switch self.state {
            case .normal:
                fallthrough
            case .lastSelected:
                return .clear
            case .selected:
                return .blue
            case .error:
                fallthrough
            case .lastError:
                return .red
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Load_UI
    private func loadUI() {
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        //平移坐标系
        let translateXY = rect.size.width * 0.5
        context?.translateBy(x: translateXY, y: translateXY)
        context?.rotate(by: CGFloat(self.angle))
        context?.translateBy(x: -translateXY, y: -translateXY)
        self.drawOutCircle(context!, rect: CGRect.init(x: lineWidth, y: lineWidth, width: rect.size.width - 2 * lineWidth, height: rect.size.height - 2 * lineWidth))
        self.drawInCircle(context!, proportion: 0.3, rect: rect)
        self.drawTrangle(context!, rect: rect)
    }
}

extension ULGesturePasswordCircle {
    
    fileprivate func drawOutCircle(_ context:CGContext, rect:CGRect) {
        context.setLineWidth(lineWidth)
        context.setStrokeColor(self.outCircleColor.cgColor)
        context.strokeEllipse(in: rect)
    }
    
    fileprivate func drawInCircle(_ context:CGContext, proportion:CGFloat, rect:CGRect) {
        context.setFillColor(self.inCircleColor.cgColor)
        let width = rect.size.width * proportion
        let height = rect.size.height * proportion
        let x = (rect.size.width - width) / 2.0
        let y = (rect.size.height - height) / 2.0
        context.fillEllipse(in: CGRect.init(x: x, y: y, width: width, height: height))
    }
    
    fileprivate func drawTrangle(_ context:CGContext, rect:CGRect) {
        let point = CGPoint.init(x: rect.size.width / 2.0, y: 20)
        context.move(to: CGPoint.init(x: point.x, y: point.y))
        context.addLine(to: CGPoint.init(x: point.x - trangleLength / 2.0, y: point.y + trangleLength / 2.0))
        context.addLine(to: CGPoint.init(x: point.x + trangleLength / 2.0, y: point.y + trangleLength / 2.0))
        context.closePath()
        context.setFillColor(self.trangleColor.cgColor)
        context.fillPath()
    }
}
