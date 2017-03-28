//
//  ULBaseNavigationController.swift
//  ULife
//
//  Created by codeLocker on 2017/2/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULBaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        loadUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        navigationBar.barTintColor = ULConstants.color.defaultNavigationBarBackgroundColor
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.init(name: "DancingScript-Bold", size: 30)!]
        ul_hideBottomLine()
    }
}
