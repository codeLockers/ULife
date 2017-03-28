//
//  UIView+ULHud.swift
//  ULife
//
//  Created by codeLocker on 2017/3/28.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIView {

    func ul_hint(_ content:String?) {
    
        guard let content = content else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .text
        hud.label.text = content
        hud.label.font = UIFont.systemFont(ofSize: 15)
        hud.contentColor = .white
        hud.removeFromSuperViewOnHide = true
        hud.offset = CGPoint.init(x: 0, y: ULConstants.screen.height - 100)
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.9)
        hud.hide(animated: true, afterDelay: 1.5)
    }
}
