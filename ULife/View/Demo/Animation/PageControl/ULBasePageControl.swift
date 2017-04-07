//
//  ULBasePageControl.swift
//  ULife
//
//  Created by codeLocker on 2017/3/21.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULBasePageControl: UIControl {
    //item的数量
    open var numberOfPages : Int = 0 {
        didSet {
            updateNumberOfPages(numberOfPages)
            self.isHidden = hideForSiglePage && numberOfPages == 1
        }
    }
    //单个页面时是否隐藏
    open var hideForSiglePage : Bool = true {
        didSet {
            layout()
        }
    }
    //item的半径
    open var radius : CGFloat = 5 {
        didSet {
            layout()
            update(for: progress)
        }
    }
    //item之间的间隔
    open var padding : CGFloat = 5 {
        didSet {
            layout()
            update(for: progress)
        }
    }
    //item的背景色
    override open var tintColor : UIColor! {
        didSet {
            layout()
        }
    }
    //item的未选中状态下的透明度
    open var inactiveTransparency : CGFloat = 0.4
    
    //边框宽度
    open var borderWidth : CGFloat = 0 {
        didSet {
            layout()
        }
    }
    //进度
    open var progress : Double = 0 {
        didSet {
            update(for: progress)
        }
    }
    //当前页面下标
    open var currentPage: Int {
        return Int(round(progress))
    }
    
    func updateNumberOfPages(_ count:Int) {
        fatalError("需要被子类重写")
    }
    
    func layout() {
        fatalError("需要被子类重写")
    }
    
    func update(for progress:Double) {
        fatalError("需要被子类重写")
    }
}
