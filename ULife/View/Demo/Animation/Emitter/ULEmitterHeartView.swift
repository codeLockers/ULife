//
//  ULEmitterHeartView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULEmitterHeartView: ULDemoBaseView {

    fileprivate let emitter  = CAEmitterLayer()
    
    fileprivate let heartBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .yellow
        btn.addTarget(self, action: #selector(heartBtn_Pressed), for: .touchUpInside)
        btn.setTitle("Heart", for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.addSubview(self.heartBtn)

        self.emitter.emitterPosition = CGPoint.init(x: 200, y: 200)
        self.emitter.emitterSize = CGSize.init(width: 150, height: 50)
        
        self.emitter.emitterMode = kCAEmitterLayerVolume
        self.emitter.emitterShape = kCAEmitterLayerRectangle
        self.emitter.renderMode = kCAEmitterLayerAdditive
        
        let emitterCell = CAEmitterCell()
        emitterCell.name = "heart"
        emitterCell.emissionLongitude = .pi / 2
        emitterCell.emissionRange = .pi * 0.55
        emitterCell.birthRate = 0
        emitterCell.lifetime = 10
        emitterCell.velocity = -120
        emitterCell.velocityRange = 60
        emitterCell.yAcceleration = 20
        emitterCell.contents = UIImage.init(named: "ul_emitter_heart")?.cgImage
        emitterCell.color = UIColor.ul_rgb(r: 0.5, g: 0, b: 0.5, a: 0.5).cgColor
        emitterCell.redRange = 0.3
        emitterCell.blueRange = 0.3
        emitterCell.alphaSpeed = -(0.5 / emitterCell.lifetime)
        emitterCell.scale = 0.15
        emitterCell.scaleSpeed = 0.5
        emitterCell.spinRange = 2 * .pi
        
        self.emitter.emitterCells = [emitterCell]
        self.layer .addSublayer(self.emitter)
    }
    
    private func layout() {
        self.heartBtn.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
    }
}

extension ULEmitterHeartView {

    @objc fileprivate func heartBtn_Pressed() {
        let aniamtion = CABasicAnimation.init(keyPath: "emitterCells.heart.birthRate")
        aniamtion.fromValue = 150
        aniamtion.toValue = 0
        aniamtion.duration = 5
        self.emitter.add(aniamtion, forKey: "heartsBurst")
    }
}
