//
//  ULWeatherViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/2/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWeatherViewController: ULBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red

        self.navigationItem.title = "Weather"
        
        ULNotificationCenterManager.manger.registerPushViewController(self, selector: #selector(pushViewControler))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ULNotificationCenterManager.manger.postEnableSidebar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        ULNotificationCenterManager.manger.removeObserver(self)
    }
    
    //MARK: - Private_Methods
    @objc
    func pushViewControler(_ notification:NSNotification?) {
        
        let vc = notification?.object
        if vc is UIViewController {
            self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
            ULNotificationCenterManager.manger.postDisableSidebar()
        }
    }

    
}
