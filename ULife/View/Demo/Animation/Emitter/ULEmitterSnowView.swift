//
//  ULEmitterSnowView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULEmitterSnowView: ULDemoBaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.backgroundColor = .black
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint.init(x: ULConstants.screen.width / 2.0, y: 0)
        emitter.emitterSize = CGSize.init(width: ULConstants.screen.width / 2.0, height: 0)
        emitter.emitterMode = kCAEmitterLayerOutline
        emitter.emitterShape = kCAEmitterLayerLine
        
        let emitterCell = CAEmitterCell()
        emitterCell.birthRate = 1.0
        emitterCell.lifetime = 120
        emitterCell.velocity = -10
        emitterCell.velocityRange = 10
        emitterCell.yAcceleration = 2
        emitterCell.emissionRange = .pi / 2
        emitterCell.spinRange = .pi / 4
        emitterCell.contents = UIImage.init(named: "ul_emitter_snow")?.cgImage
        emitterCell.color = UIColor.ul_rgb(r: 0.6, g: 0.658, b: 0.743, a: 1).cgColor
        
        emitter.shadowOpacity = 1
        emitter.shadowColor = UIColor.white.cgColor
        emitter.shadowRadius = 0
        emitter.shadowOffset = CGSize.init(width: 0, height: 1)
        
        emitter.emitterCells = [emitterCell]
        self.layer.addSublayer(emitter)
    }
}
