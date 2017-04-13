//
//  ULEmitterLikeView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULEmitterLikeView: ULDemoBaseView {

    fileprivate lazy var emitterView : ULEmitterView = {
    
        let view = ULEmitterView()
        view.positionType = .left
        view.images = (0..<21).map({ i in
            return UIImage.init(named: "ul_emitter_heart_\(i)")!
        })
        view.frame = CGRect.init(x: 10, y: 0, width: ULConstants.screen.width / 3.0, height: 400)
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Load_UI
    private func loadUI() {
        self.backgroundColor = .black
        self.addSubview(self.emitterView)
    }
}

extension ULEmitterLikeView {
    @objc internal func likeBtn_Pressed(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
    }
}
