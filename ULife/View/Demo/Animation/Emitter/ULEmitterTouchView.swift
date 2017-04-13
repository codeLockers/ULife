//
//  ULEmitterTouchView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULEmitterTouchView: ULDemoBaseView {

    fileprivate let emitter = CAEmitterLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.backgroundColor = .black
        
        self.emitter.emitterPosition = CGPoint.init(x: ULConstants.screen.width / 2.0, y: ULConstants.screen.height / 2.0)
        self.emitter.emitterSize = CGSize.init(width: 50, height: 0)
        self.emitter.emitterMode	= kCAEmitterLayerOutline;
        self.emitter.emitterShape	= kCAEmitterLayerCircle;
        self.emitter.renderMode		= kCAEmitterLayerBackToFront;
        
        let ringCell = CAEmitterCell()
        ringCell.name = "ring"
        ringCell.birthRate = 0
        ringCell.velocity = 250
        ringCell.scale = 0.5
        ringCell.scaleSpeed = -0.2
        ringCell.greenSpeed = -0.2
        ringCell.redSpeed = -0.5
        ringCell.blueSpeed = -0.5
        ringCell.lifetime = 2
        ringCell.color = UIColor.white.cgColor
        ringCell.contents = UIImage.init(named: "ul_emitter_triangle")?.cgImage
        
        self.emitter.emitterCells = [ringCell]
        self.layer.addSublayer(self.emitter);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        
        let aniamtion = CABasicAnimation.init(keyPath: "emitterCells.ring.birthRate")
        aniamtion.fromValue = 125
        aniamtion.toValue = 0
        aniamtion.duration = 0.5
        
        self.emitter.add(aniamtion, forKey: "aniamtion")
        self.emitter.emitterPosition = point!;
    }

}
