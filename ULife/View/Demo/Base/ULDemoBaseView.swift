//
//  ULDemoBaseView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/4.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol ULDemoBaseViewDelegate : NSObjectProtocol {
    @objc optional func demoBaseViewCloseButtonPressed(_ animationView : ULDemoBaseView)
}

class ULDemoBaseView: UIView {

    fileprivate let closeBtn : UIButton = UIButton()

    let startBtn : UIButton = UIButton()
    
    weak var delegate : ULDemoBaseViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MAKR: - Load_UI
    private func loadUI(){
        
        backgroundColor = UIColor.white
        closeBtn.backgroundColor = UIColor.ul_random()
        closeBtn.setTitle("CLOSE", for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtn_Pressed), for: .touchUpInside)
        self.addSubview(closeBtn)
        
        startBtn.backgroundColor = UIColor.ul_random()
        startBtn.setTitle("START", for: .normal)
        startBtn.addTarget(self, action: #selector(startBtn_Pressed), for: .touchUpInside)
        self.addSubview(startBtn)
    }
    
    private func layout(){
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        startBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(closeBtn.snp.top)
            make.height.equalTo(closeBtn)
        }
    }
    
    //MARK: - UIButton_Methods
    @objc private func closeBtn_Pressed(){
        self.delegate?.demoBaseViewCloseButtonPressed?(self)
    }
    
    @objc func startBtn_Pressed(_ sender:UIButton) {
        
    }
}
