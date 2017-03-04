//
//  ULBaseViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/3/2.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置返回键标题
        (navigationController as? ULBaseNavigationController)?.ul_set(backItemTitle: "", viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
