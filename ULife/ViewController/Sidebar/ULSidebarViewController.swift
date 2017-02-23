//
//  ULSidebarViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/2/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULSidebarViewController: UIViewController,UIScrollViewDelegate {
    /** 侧边栏的宽度*/
    let sidebarWidth : CGFloat = 64
    
    //MARK: - Life_Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let multiplier = scrollView.contentOffset.x / self.sidebar.bounds.width
        let fraction = 1.0 - multiplier
        self.sidebar.layer.transform = transformForFraction(fraction)
        self.sidebar.alpha = fraction
        
        scrollView.isPagingEnabled = scrollView.contentOffset.x < (scrollView.contentSize.width - scrollView.frame.width)
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
    
    //MARK:- Load_UI
    private func loadUI(){
    
        self.view.backgroundColor = UIColor.black

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.sidebar)

        let view = ULWeatherViewController().view!
        view.frame = CGRect.init(x: self.sidebarWidth, y: 0, width: ULConstants.Screen.width, height: ULConstants.Screen.height)
        
        self.scrollView.addSubview(view)
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
        return scrollView
    }()
    
    private lazy var sidebar : ULSidebar! = { () -> ULSidebar in
    
        let sidebar = ULSidebar.init(frame: CGRect.init(x: 0, y: 0, width: self.sidebarWidth, height: ULConstants.Screen.height))
        sidebar.layer.anchorPoint = CGPoint.init(x: 1.0, y: 0.5)
        return sidebar
    }()
}
