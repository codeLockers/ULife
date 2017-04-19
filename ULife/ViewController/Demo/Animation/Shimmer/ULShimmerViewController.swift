//
//  ULShimmerViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/4/17.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULShimmerViewController: ULBaseViewController {
    fileprivate let shimmeringView = ULShimmeringView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Load_UI
    private func loadUI() {
        self.view.backgroundColor = .black
        self.navigationItem.title = "Shimmer"
        self.shimmeringView.frame = CGRect.init(x: 0, y: 100, width: 300, height: 100)
        self.view.addSubview(self.shimmeringView)
        
        let label = UILabel()
        label.text = "Shimmer"
        label.font = UIFont.systemFont(ofSize: 60)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        self.shimmeringView.contentView = label
    }

}
