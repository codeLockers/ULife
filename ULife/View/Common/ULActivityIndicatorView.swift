//
//  ULActivityIndicatorView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULActivityIndicatorView: UIView {

    fileprivate let activeIndicator : UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
            indicator.hidesWhenStopped = true
            return indicator
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(activeIndicator)
        activeIndicator.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        self.activeIndicator.startAnimating()
    }
    
    func stopAnimating() {
        self.activeIndicator.stopAnimating()
    }
    
}
