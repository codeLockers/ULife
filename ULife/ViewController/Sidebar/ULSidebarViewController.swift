//
//  ULSidebarViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/2/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULSidebarViewController: ULBaseViewController,UIScrollViewDelegate,ULSidebarDelegate{
    /** 侧边栏的宽度*/
    let sidebarWidth : CGFloat = 64
    
    //MARK: - Life_Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        ULNotificationCenterManager.manger.registerDisableSidebar(self,selector: #selector(diableSidebar))
        ULNotificationCenterManager.manger.registerEnableSidebar(self,selector: #selector(enableSidebar))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        ULNotificationCenterManager.manger.removeObserver(self)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let multiplier = scrollView.contentOffset.x / self.sidebar.bounds.width
        let fraction = 1.0 - multiplier
        self.sidebar.layer.transform = transformForFraction(fraction)
        self.sidebar.alpha = fraction
        
        scrollView.isPagingEnabled = scrollView.contentOffset.x < (scrollView.contentSize.width - scrollView.frame.width)
    }
    
    //MARK: - ULSidebarDelegate
    func sidebarDidSelectAtIndex(_ index: NSInteger) {
        //点击sidebar
        self.scrollView.setContentOffset(CGPoint.init(x: sidebarWidth, y: 0), animated: true)
        var vc : UIViewController?
        switch index {
        case 0:
            break
        case 1:
            break
        case 2:
            vc = ULDemoListViewController()
        default:
            break
        }
        ULNotificationCenterManager.manger.postPushViewController(vc)
    }
    
    //MARK: Private_Methods
    private func transformForFraction(_ fraction:CGFloat) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0 / 1000.0;
        let angle = Double(1.0 - fraction) * -M_PI_2
        let xOffset = self.sidebar.bounds.width * 0.5
        let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
        let translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
        return CATransform3DConcat(rotateTransform, translateTransform)
    }
    
    /// 禁用侧边栏
    @objc
    func diableSidebar() {
        self.scrollView.isScrollEnabled = false
    }
    
    /// 启用侧边栏
    @objc
    func enableSidebar() {
        self.scrollView.isScrollEnabled = true
    }
    
    //MARK:- Load_UI
    private func loadUI(){
    
        self.view.backgroundColor = UIColor.black

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.sidebar)
        
        let nav = ULBaseNavigationController.init(rootViewController: ULWeatherViewController())
        self.addChildViewController(nav)
        nav.view.frame = CGRect.init(x: self.sidebarWidth, y: 0, width: ULConstants.Screen.width, height: ULConstants.Screen.height)
        self.scrollView.addSubview(nav.view)
    }
    
    //MARK: - Setter && Getter
    private lazy var scrollView : UIScrollView! = {() -> UIScrollView in
        
        let scrollView = UIScrollView.init(frame:ULConstants.Screen.bounces)
        scrollView.contentSize = CGSize.init(width: ULConstants.Screen.width+self.sidebarWidth, height: ULConstants.Screen.height)
        scrollView.setContentOffset(CGPoint.init(x: self.sidebarWidth, y: 0), animated: false)
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private lazy var sidebar : ULSidebar! = { () -> ULSidebar in
    
        let sidebar = ULSidebar.init(frame: CGRect.init(x: 0, y: 0, width: self.sidebarWidth, height: ULConstants.Screen.height))
        sidebar.layer.anchorPoint = CGPoint.init(x: 1.0, y: 0.5)
        sidebar.delegate = self
        return sidebar
    }()
}
