//
//  ULEmitterButton.swift
//  ULife
//
//  Created by codeLocker on 2017/4/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

enum ULEmitterButtonEffectType {
    case emitter
    case wave
}

class ULEmitterButton: UIButton {

//    fileprivate lazy var keypaths : [String]? = {
//        let array = [String]()
//        return array
//    }()
    
    var emitter : [UIImage?]? = nil {
        
        didSet {
            let images = emitter.flatMap({$0}) as! [UIImage]?
            if images == nil || images!.count == 0 {
                return
            }
            var emitterCells = [CAEmitterCell]()
            for image in images! {
//                let index = images!.index(of: image)
                let emitterCell = CAEmitterCell()
//                emitterCell.name = "xuzhang"
                emitterCell.alphaRange = 0.10;
                emitterCell.alphaSpeed = -1.0;
                emitterCell.lifetime = 0.7;
                emitterCell.lifetimeRange = 0.3;
                emitterCell.velocity = 40.00;
                emitterCell.velocityRange = 5.00;
                emitterCell.scale = 0.1;
                emitterCell.scaleRange = 0.02;
                emitterCell.birthRate = 0;
                emitterCell.contents = image.cgImage
                emitterCells.append(emitterCell)
//                self.keypaths?.append("emitterCells.xuzhang.birthRate")
            }
            self.emitterLayer?.emitterCells = emitterCells
        }
    }
    
    override var isSelected : Bool {
        didSet {
            self.emitterAniamtion()
        }
    }

    
    fileprivate var emitterLayer : CAEmitterLayer?
    fileprivate var effectType : ULEmitterButtonEffectType = .emitter
    
    init(effectType:ULEmitterButtonEffectType, frame:CGRect) {
        super.init(frame: frame)
        self.effectType = effectType
        switch effectType {
        case .emitter:
            self.loadEmitterLayer()
//        case .wave:
            
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ULEmitterButton {
    fileprivate func loadEmitterLayer() {
        self.emitterLayer = CAEmitterLayer()
        self.emitterLayer!.name = "emitterLayer"
        self.emitterLayer!.emitterShape = kCAEmitterLayerCircle;
        self.emitterLayer!.emitterMode = kCAEmitterLayerOutline;
        self.emitterLayer!.renderMode = kCAEmitterLayerOldestLast;
        self.emitterLayer!.masksToBounds = false;
        self.emitterLayer!.zPosition = -1;
        self.emitterLayer!.position = CGPoint.init(x: self.ul_width/2.0, y: self.ul_height/2.0);
        self.layer.addSublayer(self.emitterLayer!)
    }
    
    fileprivate func emitterAniamtion() {
        let aniamtion = CAKeyframeAnimation.init(keyPath: "transform.scale")
        aniamtion.duration = 0.25
        aniamtion.calculationMode = kCAAnimationCubic
        if self.isSelected {
            aniamtion.values = [1.1,1.3,1.5,1.2,1]
            switch self.effectType {
            case .emitter:
                self.startEmitter()
            default:
                break
            }
        }else {
            aniamtion.values = [0.8,0.6,0.8,1]
        }
        self.layer.add(aniamtion, forKey: "transform.scale")
    }
    
    fileprivate func startEmitter() {
        guard let emitterCells = self.emitterLayer!.emitterCells, emitterCells.count > 0 else {
            return
        }
//        for emitterCell in emitterCells {
//            emitterCell.birthRate = 1500
//            self.emitterLayer?.beginTime = CACurrentMediaTime()
//            self.emitterLayer?.emitterCells = [emitterCell]
//        }
//        self.emitterLayer?.emitterCells?.append(contentsOf: <#T##Sequence#>)
        
//        self.emitterLayer?.emitterCells
//        self.emitterLayer?.setValue(1500, forKey: "emitterCells.xuzhang.birthRate")
        
//        self.perform(#selector(stopEmitter), with: nil, afterDelay: 0.1)
    }
    
    @objc fileprivate func stopEmitter() {
        guard let emitterCells = self.emitterLayer!.emitterCells, emitterCells.count > 0 else {
            return
        }
        for emitterCell in emitterCells {
            emitterCell.birthRate = 0
        }
    }
}
