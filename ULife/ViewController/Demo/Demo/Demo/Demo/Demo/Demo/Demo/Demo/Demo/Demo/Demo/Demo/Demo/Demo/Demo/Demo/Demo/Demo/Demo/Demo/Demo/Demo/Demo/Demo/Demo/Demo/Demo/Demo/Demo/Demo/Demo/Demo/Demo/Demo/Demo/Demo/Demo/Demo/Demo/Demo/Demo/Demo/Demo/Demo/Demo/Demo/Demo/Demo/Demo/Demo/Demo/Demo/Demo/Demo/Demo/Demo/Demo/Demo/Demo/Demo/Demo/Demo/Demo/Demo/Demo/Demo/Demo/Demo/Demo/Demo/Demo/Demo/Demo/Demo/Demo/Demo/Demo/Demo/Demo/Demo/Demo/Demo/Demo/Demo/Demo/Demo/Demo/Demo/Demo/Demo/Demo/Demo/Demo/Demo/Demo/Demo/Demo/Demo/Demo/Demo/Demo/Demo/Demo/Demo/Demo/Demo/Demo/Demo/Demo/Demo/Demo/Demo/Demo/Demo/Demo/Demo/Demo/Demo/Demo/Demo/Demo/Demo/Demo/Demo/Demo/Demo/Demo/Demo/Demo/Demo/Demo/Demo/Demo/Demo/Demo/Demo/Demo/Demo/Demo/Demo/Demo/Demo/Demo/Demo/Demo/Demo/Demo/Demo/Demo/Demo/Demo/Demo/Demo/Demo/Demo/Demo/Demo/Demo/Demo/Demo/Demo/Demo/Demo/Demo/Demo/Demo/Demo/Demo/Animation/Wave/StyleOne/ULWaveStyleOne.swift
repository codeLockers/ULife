//
//  ULWaveStyleOne.swift
//  ULife
//
//  Created by codeLocker on 2017/3/28.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

enum ULWaveStyleOneFunctiontype {
    case sin
    case cos
}

class ULWaveStyleOne: UIView {
    //填充色
    var waveFillColor : UIColor = .red {
        didSet {
            self.waveLayer.fillColor = self.waveFillColor.cgColor
        }
    }
    //振幅
    var amplitude : CGFloat = 12
    //周期
    var period : CGFloat = 0.5/30.0
    //X轴位移
    var offsetX : CGFloat = 0
    //速度
    var speed : CGFloat = 0.1
    //宽度
    var width : CGFloat = ULConstants.screen.width
    //Y轴位移
    var offsetY : CGFloat = 100
    //波动函数
    var function : ULWaveStyleOneFunctiontype = .sin
    
    fileprivate let waveLayer = CAShapeLayer()
    fileprivate var displayLink : CADisplayLink?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpWave()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.displayLink?.invalidate()
    }
    
    private func setUpWave() {
        
        self.waveLayer.fillColor = self.waveFillColor.cgColor
        self.layer.addSublayer(waveLayer)
        
        displayLink = CADisplayLink.init(target: self, selector: #selector(displayWave))
        displayLink!.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    @objc private func displayWave() {
        
        offsetX += speed
        
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: 0, y: offsetY))
        var y : CGFloat = 0
        for i in 0...Int(width) {
            
            switch self.function {
            case .sin:
                y = amplitude*sin(period * CGFloat(i) + offsetX) + offsetY
            case .cos:
                y = amplitude*cos(period * CGFloat(i) + offsetX) + offsetY
            }
            path.addLine(to: CGPoint.init(x: CGFloat(i), y: y))
        }
        path.addLine(to: CGPoint.init(x: width, y: 0))
        path.addLine(to: CGPoint.init(x: 0, y: 0))
        path.closeSubpath()
        
        self.waveLayer.path = path
    }
}
