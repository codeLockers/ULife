//
//  ULShimmeringView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/17.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULShimmeringView: UIView {
    
    var contentView : UIView? {
        willSet {
            if self.contentView != newValue && newValue != nil {
                self.addSubview(newValue!)
                (self.layer as? ULShimmeringLayer)?.contentLayer = newValue!.layer
            }
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return ULShimmeringLayer.self
        }
    }
    
    override func layoutSubviews() {
        self.contentView?.frame = self.bounds
        super.layoutSubviews()
    }
    
}
