//
//  ULBaseLoadingView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/24.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULBaseLoadingView: UIView {

    class func show(in superView:UIView?) {
        
        guard let view = superView else {
            return
        }

        let loadingView = self.init()
        loadingView.frame = view.bounds
        loadingView.layout()
        view.addSubview(loadingView)
    }
    
    class func hide(from superView:UIView?) {

        guard let view = superView else {
            return
        }

        let loadingViews = view.subviews.filter({ $0 is ULBaseLoadingView })
        let _ = loadingViews.map { (loadingView) in
            let _ = loadingView.subviews.map({ $0.layer.removeAllAnimations() })
            loadingView.removeFromSuperview()
        }
    }
    
    func layout() {
        fatalError("需要被子类重写")
    }
    
}
