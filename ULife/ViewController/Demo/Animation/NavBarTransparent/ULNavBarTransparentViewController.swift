//
//  ULNavBarTransparentViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/3/17.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

/*
 * 参考 : http://www.jianshu.com/p/454b06590cf1
 */

import UIKit
import SnapKit

class ULNavBarTransparentViewController: ULBaseViewController {
    
    fileprivate let tableView : UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        layout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Load_UI
    private func loadUI(){
        view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        view.addSubview(tableView)
        
        let tableViewHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ULConstants.screen.width, height: 200))
        tableViewHeaderView.backgroundColor = UIColor.orange
        tableView.tableHeaderView = tableViewHeaderView
        
        automaticallyAdjustsScrollViewInsets = false
        //设置NavigationBar背景透明度
        navBarBgAlpha = 0.0
        navBarTintColor = UIColor.red
    }
    
    private func layout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ULNavBarTransparentViewController : UITableViewDelegate , UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        cell?.textLabel?.text = "第\(indexPath.row)行"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ULNavBarTransparentViewController(), animated: true)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = 200 - topLayoutGuide.length
        //navBar的alpha
        if contentOffsetY > showNavBarOffsetY {
            var newAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if newAlpha > 1 {
                newAlpha = 1
            }
            navBarBgAlpha = newAlpha
            if navBarBgAlpha > 0.8 {
                navBarTintColor = ULConstants.color.defaultNavigationBarTintColor
            }else{
                navBarTintColor = UIColor.red
            }
        }else{
            navBarBgAlpha = 0.0
            navBarTintColor = UIColor.red
        }
    }
}


//MARK: - ULNavBarTransparent
extension UIViewController{
    
    fileprivate struct AssociatedKeys {
        //导航栏透明度
        static var navBarBgAlpha = 1.0
        static var navBarTintColor = ULConstants.color.defaultNavigationBarTintColor
    }
    
    open var navBarBgAlpha : CGFloat{
        get{
            //获取alpha
            let alpha = objc_getAssociatedObject(self, &AssociatedKeys.navBarBgAlpha) as? CGFloat
            if alpha == nil {
                return 1.0
            }
            return alpha!
        }
        set {
            //设置alpha
            var alpha = newValue
            if alpha > 1 {
                alpha = 1
            }
            if alpha < 0 {
                alpha = 0
            }
            objc_setAssociatedObject(self, &AssociatedKeys.navBarBgAlpha, alpha, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.setNavigationBarBackground(alpha: alpha)
        }
    }
    
    open var navBarTintColor : UIColor {
        get {
            let tintColor = objc_getAssociatedObject(self, &AssociatedKeys.navBarTintColor) as? UIColor
            if tintColor == nil{
                return ULConstants.color.defaultNavigationBarTintColor
            }
            return tintColor!
        }
        set {
            navigationController?.navigationBar.tintColor = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.navBarTintColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UINavigationController {
    
    open override class func initialize(){
        
        if self == UINavigationController.self {
            let needSwizzleSelectorArr = [
                                        ["ori":NSSelectorFromString("_updateInteractiveTransition:"),"swi":NSSelectorFromString("ul_updateInteractiveTransition:")],
                                            ["ori":#selector(popToViewController(_:animated:)),"swi":#selector(ul_popToViewController(_:animated:))],
                                            ["ori":#selector(popToRootViewController(animated:)),"swi":#selector(ul_popToRootViewControler(animated:))]
                                            ]
            for needSwizzleSelector in needSwizzleSelectorArr {
                let originalSelector = needSwizzleSelector["ori"]
                let swizzledSelector = needSwizzleSelector["swi"]
                let originalMethod = class_getInstanceMethod(self, originalSelector)
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    func ul_popToViewController(_ viewController : UIViewController , animated : Bool) -> [UIViewController]? {
        setNavigationBarBackground(alpha: viewController.navBarBgAlpha)
        navigationBar.tintColor = viewController.navBarTintColor
        return ul_popToViewController(viewController, animated: animated)
    }

    func ul_popToRootViewControler(animated : Bool) -> [UIViewController]? {
        setNavigationBarBackground(alpha: (viewControllers.first?.navBarBgAlpha)!)
        navigationBar.tintColor = viewControllers.first?.navBarTintColor
        return ul_popToRootViewControler(animated: animated)
    }
    
    /// 手势pop
    ///
    /// - Parameter percentComplete: 手势进度
    func ul_updateInteractiveTransition(_ percentComplete : CGFloat) {
        ul_updateInteractiveTransition(percentComplete)
        if let topVC = self.topViewController {
            if let coor = topVC.transitionCoordinator {
                //透明度
                let fromAlpha = coor.viewController(forKey: .from)?.navBarBgAlpha
                let toAlpha = coor.viewController(forKey: .to)?.navBarBgAlpha
                let nowAlpha = fromAlpha! + (toAlpha!-fromAlpha!)*percentComplete
                setNavigationBarBackground(alpha: nowAlpha)
                
                //tintColor
                let fromColor = coor.viewController(forKey: .from)?.navBarTintColor
                let toColor = coor.viewController(forKey: .to)?.navBarTintColor
                let nowColor = averageColor(fromColor: fromColor!, toColor: toColor!, percent: percentComplete)
                self.navigationBar.tintColor = nowColor
            }
        }
    }
    
    
    /// 计算两个色值之间的平均值
    ///
    /// - Parameters:
    ///   - fromColor: 起始值
    ///   - toColor: 目标值
    ///   - percent: 完成度
    /// - Returns: UIColor
    private func averageColor(fromColor:UIColor, toColor:UIColor, percent:CGFloat) -> UIColor {
        var fromRed :CGFloat = 0.0
        var fromGreen :CGFloat = 0.0
        var fromBlue :CGFloat = 0.0
        var fromAlpha :CGFloat = 0.0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed :CGFloat = 0.0
        var toGreen :CGFloat = 0.0
        var toBlue :CGFloat = 0.0
        var toAlpha :CGFloat = 0.0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed-fromRed)*percent
        let nowGreen = fromGreen + (toGreen-fromGreen)*percent
        let nowBlue = fromBlue + (toBlue-fromBlue)*percent
        let nowAlpha = fromAlpha + (toAlpha-fromAlpha)*percent

        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
    
    
    /// 设置NavigationBar的透明度
    ///
    /// - Parameter alpha: 透明值
    fileprivate func setNavigationBarBackground(alpha:CGFloat){
        
        let barBackgroundView = navigationBar.subviews[0]
        if let shadowView = barBackgroundView.value(forKey: "_shadowView") as? UIView {
            shadowView.alpha = alpha
        }
        if navigationBar.isTranslucent {
            if #available(iOS 10.0, *) {
                if navigationBar.backgroundImage(for: .default) == nil {
                    if let backgroundEffectView = barBackgroundView.value(forKey: "_backgroundEffectView") as? UIView {
                        backgroundEffectView.alpha = alpha
                        return
                    }
                }
            }else{
                if let adaptiveBackdrop = barBackgroundView.value(forKey: "_adaptiveBackdrop") as? UIView {
                    if let backdropEffectView = adaptiveBackdrop.value(forKey: "_backdropEffectView") as? UIView {
                        backdropEffectView.alpha = alpha
                        return
                    }
                }
            }
        }
        barBackgroundView.alpha = alpha
    }
}

extension UINavigationController : UINavigationControllerDelegate , UINavigationBarDelegate{
    
    //是否可以执行pop
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        if let topVc = topViewController {
            //转场动画协调器,使用手势pop的时候会创建transitionCoordinator
            if let coor = topVc.transitionCoordinator{
                if coor.initiallyInteractive {
                    return true
                }
            }
        }
        
        var popToVc : UIViewController?
        if viewControllers.count >= (navigationBar.items?.count)! {
            popToVc = viewControllers[viewControllers.count - 2]
        }
        if popToVc != nil {
            self.popToViewController(popToVc!, animated: true)
            return true
        }
        return false
    }
    //是否可以push
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        setNavigationBarBackground(alpha: (topViewController?.navBarBgAlpha)!)
        navigationBar.tintColor = topViewController?.navBarTintColor
        return true
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let topVC = navigationController.topViewController {
            if let coor = topVC.transitionCoordinator {
                if #available(iOS 10.0, *) {
                    //当转场变化时
                    coor.notifyWhenInteractionChanges({ (context) in
                        self.dealInteractionChanges(context)
                    })
                } else {
                    //当转场结束时
                    coor.notifyWhenInteractionEnds({ (context) in
                        self.dealInteractionChanges(
                }
            }
        }
    }
    
    private func dealInteractionChanges(_ context:UIViewControllerTransitionCoordinatorContext) {
        if context.isCancelled {
            //松开手势，pop操作终止
            let cancellDuration:TimeInterval = context.transitionDuration * Double( context.percentComplete)
            UIView.animate(withDuration: cancellDuration, animations: {
                
                let nowAlpha = (context.viewController(forKey: .from)?.navBarBgAlpha)!
                self.setNavigationBarBackground(alpha: nowAlpha)
                
                self.navigationBar.tintColor = context.viewController(forKey: .from)?.navBarTintColor
            })
        }else{
            //松开手势，pop操作完成
            let finishDuration:TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration, animations: {
                let nowAlpha = (context.viewController(forKey: .to)?.navBarBgAlpha)!
                self.setNavigationBarBackground(alpha: nowAlpha)
                
                self.navigationBar.tintColor = context.viewController(forKey: .to)?.navBarTintColor
            })
        }
    }
}
