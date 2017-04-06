//
//  ULGesturePasswordViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/4/5.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULGesturePasswordViewController: UIViewController {

    fileprivate let thumbnailView = ULGesturePasswordThumbnailView()
    fileprivate let promptLab : UILabel = {
        let label = UILabel()
        label.text = "设置手势密码"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    fileprivate let drawView = ULGesturePasswordDrawView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        layout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Load_UI
    private func loadUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "GesturePassword"
        self.view.addSubview(thumbnailView)
        self.view.addSubview(promptLab)
        drawView.delegate = self
        self.view.addSubview(drawView)
    }
    
    private func layout() {
        self.thumbnailView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30+64)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        self.promptLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.thumbnailView.snp.bottom).offset(10)
        }
        self.drawView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.promptLab.snp.bottom).offset(20)
            make.height.equalTo(self.drawView.snp.width)
        }
    }
    
}

extension ULGesturePasswordViewController : ULGesturePasswordDrawViewDelegate {
    
    func gesturePasswordDrawView(_ drawView: ULGesturePasswordDrawView, success password: String) {
        self.thumbnailView.fillPassword(password)
    }
}
