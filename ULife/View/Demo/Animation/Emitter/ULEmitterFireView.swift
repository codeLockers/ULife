//
//  ULEmitterFireView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULEmitterFireView: ULDemoBaseView {

    fileprivate let fireEmitter = CAEmitterLayer()
    fileprivate let smokeEmitter = CAEmitterLayer()
    
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
        
        self.fireEmitter.emitterPosition = CGPoint.init(x: ULConstants.screen.width / 2.0, y: ULConstants.screen.height / 2.0)
        self.fireEmitter.emitterSize = CGSize.init(width: ULConstants.screen.width / 2.0, height: 0)
        self.fireEmitter.emitterShape = kCAEmitterLayerLine
        self.fireEmitter.renderMode = kCAEmitterLayerAdditive
        
        let fireCell = CAEmitterCell()
        fireCell.name = "fire"
        fireCell.birthRate = 100;
        fireCell.emissionLongitude = .pi;
        fireCell.velocity = -80;
        fireCell.velocityRange = 30;
        fireCell.emissionRange = 1.1;
        fireCell.yAcceleration = -200;
        fireCell.scaleSpeed = 0.3;
        fireCell.lifetime = 50;
        fireCell.lifetimeRange = (50.0 * 0.35);
        fireCell.color = UIColor.ul_rgb(r: 0.8, g: 0.4, b: 0.2, a: 0.1).cgColor
        fireCell.contents = UIImage.init(named: "ul_emitter_fire")?.cgImage
        
        self.fireEmitter.emitterCells = [fireCell]
        self.layer.addSublayer(self.fireEmitter)

        self.smokeEmitter.emitterPosition = CGPoint.init(x: ULConstants.screen.width / 2.0, y: ULConstants.screen.height / 2.0)
        self.smokeEmitter.emitterMode	= kCAEmitterLayerPoints;
        
        let smokeCell = CAEmitterCell()
        smokeCell.name = "smoke"
        smokeCell.birthRate			= 11;
        smokeCell.emissionLongitude = (.pi / -2)
        smokeCell.lifetime			= 10;
        smokeCell.velocity			= -40;
        smokeCell.velocityRange		= 20;
        smokeCell.emissionRange		= .pi / 4;
        smokeCell.spin				= 1;
        smokeCell.spinRange			= 6;
        smokeCell.yAcceleration		= -160;
        smokeCell.contents			= UIImage.init(named: "ul_emitter_smoke")?.cgImage
        smokeCell.scale				= 0.1;
        smokeCell.alphaSpeed		= -0.12;
        smokeCell.scaleSpeed		= 0.7;
        
        self.smokeEmitter.emitterCells = [smokeCell]
        self.layer.addSublayer(self.smokeEmitter)
        
        self.setFireAmount(zeroToOne: 0.9)
    }
    
    private func setFireAmount(zeroToOne : CGFloat) {
    
        self.fireEmitter.setValue(zeroToOne * 500, forKey: "emitterCells.fire.birthRate")
        self.fireEmitter.setValue(zeroToOne, forKey: "emitterCells.fire.lifetime")
        self.fireEmitter.setValue(zeroToOne * 0.35, forKey: "emitterCells.fire.lifetimeRange")
        self.fireEmitter.emitterSize = CGSize.init(width: 50 * zeroToOne, height: 0)
        self.smokeEmitter.setValue(zeroToOne * 4, forKey: "emitterCells.smoke.lifetime")
        self.smokeEmitter.setValue(UIColor.ul_rgb(r: 1, g: 1, b: 1, a: zeroToOne*0.3).cgColor, forKey: "emitterCells.smoke.color")
    }
}
