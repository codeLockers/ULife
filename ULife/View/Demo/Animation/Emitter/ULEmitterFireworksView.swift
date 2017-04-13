//
//  ULEmitterFireworksView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULEmitterFireworksView: ULDemoBaseView {

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
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint.init(x: ULConstants.screen.width / 2.0, y: ULConstants.screen.height / 2.0 + 200)
        emitter.emitterSize	= CGSize.init(width: ULConstants.screen.width / 2.0, height: 0)
        emitter.emitterMode	= kCAEmitterLayerOutline;
        emitter.emitterShape	= kCAEmitterLayerLine;
        emitter.renderMode		= kCAEmitterLayerAdditive;

        let rocketCell = CAEmitterCell()
        rocketCell.birthRate = 1.0
        rocketCell.emissionRange = 0.25 * .pi  // some variation in angle
        rocketCell.velocity	= 380
        rocketCell.velocityRange = 100
        rocketCell.yAcceleration = 75
        rocketCell.lifetime	= 1.02	// we cannot set the birthrate < 1.0 for the burst
        
        rocketCell.contents	= UIImage.init(named: "ul_emitter_ring")?.cgImage
        rocketCell.scale = 0.2
        rocketCell.color = UIColor.red.cgColor
        rocketCell.greenRange = 1.0	// different colors
        rocketCell.redRange	= 1.0
        rocketCell.blueRange = 1.0
        rocketCell.spinRange = .pi		// slow spin
        

        let burstCell = CAEmitterCell()
        burstCell.birthRate	= 1.0;		// at the end of travel
        burstCell.velocity = 0;
        burstCell.scale = 2.5;
        burstCell.redSpeed = -1.5;		// shifting
        burstCell.blueSpeed = 1.5;		// shifting
        burstCell.greenSpeed = 1.0;		// shifting
        burstCell.lifetime = 0.35;
        
        let sparkCell = CAEmitterCell()
        sparkCell.birthRate	= 400
        sparkCell.velocity = 125
        sparkCell.emissionRange = 2 * .pi	// 360 deg
        sparkCell.yAcceleration = 75		// gravity
        sparkCell.lifetime = 3
        sparkCell.contents = UIImage.init(named: "ul_emitter_star")?.cgImage
        sparkCell.scaleSpeed = -0.2
        sparkCell.greenSpeed = -0.1
        sparkCell.redSpeed = 0.4
        sparkCell.blueSpeed = -0.1
        sparkCell.alphaSpeed = -0.25
        sparkCell.spin = 2 * .pi
        sparkCell.spinRange = 2 * .pi
        
        // putting it together
        emitter.emitterCells	= [rocketCell]
        rocketCell.emitterCells = [burstCell]
        burstCell.emitterCells = [sparkCell]
        self.layer.addSublayer(emitter)
    }
}
