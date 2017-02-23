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
//        self.view.addGestureRecognizer(self.rightSwipeGesture)
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    //MARK: - Gesture_Methods
//    @objc func rightSwipe_Gesture() {
//        
//        self.navigationController?.view.frame = CGRect.init(x: 100, y: 0, width: ULConstants.Screen.width, height: ULConstants.Screen.height)
//        
//        self.view.addSubview(self.sideBar)
//    }
//    
//    //MARK: - Load_UI
//    
//    //MARK: - Setter && Getter
//    lazy var rightSwipeGesture : UITapGestureRecognizer = {
//        
//        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(ULWeatherViewController.rightSwipe_Gesture))
//        return gesture
//    }()
//    
//    lazy var sideBar : ULSidebar = {
//    
//        let sideBar = ULSidebar.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: ULConstants.Screen.height))
//        return sideBar
//    }()
}
