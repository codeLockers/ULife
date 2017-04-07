//
//  ULWaveStyleOneView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/28.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWaveStyleOneView: ULDemoBaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let wave1 = ULWaveStyleOne.init(frame: CGRect.init(x: 0, y: 0, width: ULConstants.screen.width, height: 220))
        wave1.waveFillColor = UIColor.ul_rgb(r: 255, g: 0, b: 0, a: 0.6)
        
        let wave2 = ULWaveStyleOne.init(frame: CGRect.init(x: 0, y: 0, width: ULConstants.screen.width, height: 220))
        wave2.waveFillColor = UIColor.ul_rgb(r: 0, g: 0, b: 255, a: 0.6)
        wave2.function = .cos
        
        self.addSubview(wave2)
        self.addSubview(wave1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
