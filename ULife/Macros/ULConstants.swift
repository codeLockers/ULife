//
//  ULConstants.swift
//  ULife
//
//  Created by codeLocker on 2017/2/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

struct ULConstants {
    struct screen {
        /** 屏幕的宽*/
        static let width : CGFloat = UIScreen.main.bounds.width
        /** 屏幕的高*/
        static let height : CGFloat = UIScreen.main.bounds.height
        /** 屏幕的bounces*/
        static let bounces : CGRect = UIScreen.main.bounds
    }
    
    struct color {
        /** 导航栏默认barTint色*/
        static let defaultNavigationBarBackgroundColor : UIColor = UIColor.ul_rgb(r: 114, g: 164, b: 211, a: 1)
        /** 导航栏默认tint色*/
        static let defaultNavigationBarTintColor : UIColor = UIColor.white
    }
    
    struct venderKeys {
        static let gaodeKey : String = "7cb67be28ddd2afa3904f8ca900267d5"
    }
}

