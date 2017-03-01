//
//  ULWeatherViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/2/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green

        self.navigationItem.title = "Weather"

//        self.view.isUserInteractionEnabled = true
        
        let btn = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = UIColor.yellow
        btn .addTarget(self, action: #selector(push_method), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ssssssss")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func push_method() {
        
        print("ssss")
        
        self.navigationController?.pushViewController(ULTestViewController(), animated: true)
    }
}
