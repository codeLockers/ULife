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
        loadUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        navigationBar.barTintColor = UIColor.ul_rgb(r: 114, g: 164, b: 211, a: 1)
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.init(name: "DancingScript-Bold", size: 30)!]
        ul_hideBottomLine()
    }
}

extension ULBaseNavigationController {
    
   /// 隐藏NavigatorBar底部黑线
   fileprivate func ul_hideBottomLine() {
        for subview in navigationBar.subviews {
            for hairline in subview.subviews {
                if hairline is UIImageView && hairline.bounds.height <= 1.0{
                    hairline.isHidden = true;
                }
            }
        }
    }
    
    /// 设置NavigationBar的返回键的标题
    ///
    /// - parameter backItemTitle:  标题
    /// - parameter viewController: 控制器
    func ul_set(backItemTitle title:String , viewController : UIViewController) {
        
        let backItem = UIBarButtonItem()
        backItem.title = title as String
        viewController.navigationItem.backBarButtonItem = backItem
    }
}
