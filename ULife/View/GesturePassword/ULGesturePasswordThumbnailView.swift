//
//  ULGesturePasswordThumbnailView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/5.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULGesturePasswordThumbnailView: UIView {

    fileprivate let itemMargin : CGFloat = 5.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Load_UI
    override func layoutSubviews() {
        let itemWidth = (self.ul_width - itemMargin * 2) / 3.0
        for i in 0..<9 {
            let item = UIView()
            item.backgroundColor = .black
            item.tag = i + 100
            item.frame = CGRect.init(x: (itemWidth + itemMargin) * CGFloat(i % 3), y: (itemWidth + itemMargin) * CGFloat(i / 3), width: itemWidth, height: itemWidth)
            item.layer.cornerRadius = itemWidth / 2.0
            self.addSubview(item)
        }
    }
    
    private func loadUI() {

    }
}

extension ULGesturePasswordThumbnailView {
    
    func fillPassword(_ password:String) {
        for character in password.characters {
            let str = String.init(character)
            let item = self.viewWithTag(Int(str)! + 100)
            item?.backgroundColor = .blue
        }
    }
}
