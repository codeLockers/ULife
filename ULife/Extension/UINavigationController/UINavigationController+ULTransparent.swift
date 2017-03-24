//
//  UINavigationController+ULTransparent.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    open override class func initialize(){
        
        if self == UINavigationController.self {
            let needSwizzleSelectorArr = [
                ["ori":NSSelectorFromString("_updateInteractiveTransition:"),"swi":NSSelectorFromString("ul_updateInteractiveTransition:")],
                ["ori":#selector(popToViewController),"swi":#selector(ul_popToViewController)],
                ["ori":#selector(popToRootViewController),"swi":#selector(ul_popToRootViewControlerAnimated)],
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
        setNavigationBarBackground(alpha: viewController.ul_navBarBgAlpha)
        navigationBar.tintColor = viewController.ul_navBarTintColor
        return ul_popToViewController(viewController, animated: animated)
    }
    
    func ul_popToRootViewControlerAnimated(animated : Bool) -> [UIViewController]? {
        setNavigationBarBackground(alpha: (viewControllers.first?.ul_navBarBgAlpha)!)
        navigationBar.tintColor = viewControllers.first?.ul_navBarTintColor
        return ul_popToRootViewControlerAnimated(animated: animated)
    }
    
    /// 手势pop
    ///
    /// - Parameter percentComplete: 手势进度
    func ul_updateInteractiveTransition(_ percentComplete : CGFloat) {
        ul_updateInteractiveTransition(percentComplete)
        if let topVC = self.topViewController {
            if let coor = topVC.transitionCoordinator {
                //透明度
                let fromAlpha = coor.viewController(forKey: .from)?.ul_navBarBgAlpha
                let toAlpha = coor.viewController(forKey: .to)?.ul_navBarBgAlpha
                let nowAlpha = fromAlpha! + (toAlpha!-fromAlpha!)*percentComplete
                setNavigationBarBackground(alpha: nowAlpha)
                
                //tintColor
                let fromColor = coor.viewController(forKey: .from)?.ul_navBarTintColor
                let toColor = coor.viewController(forKey: .to)?.ul_navBarTintColor
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
    func setNavigationBarBackground(alpha:CGFloat){
        
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
        setNavigationBarBackground(alpha: (topViewController?.ul_navBarBgAlpha)!)
        navigationBar.tintColor = topViewController?.ul_navBarTintColor
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
                        self.dealInteractionChanges(context)
                    })
                }
            }
        }
    }
    
    private func dealInteractionChanges(_ context:UIViewControllerTransitionCoordinatorContext) {
        if context.isCancelled {
            //松开手势，pop操作终止
            let cancellDuration:TimeInterval = context.transitionDuration * Double( context.percentComplete)
            UIView.animate(withDuration: cancellDuration, animations: {
                
                let nowAlpha = (context.viewController(forKey: .from)?.ul_navBarBgAlpha)!
                self.setNavigationBarBackground(alpha: nowAlpha)
                
                self.navigationBar.tintColor = context.viewController(forKey: .from)?.ul_navBarTintColor
            })
        }else{
            //松开手势，pop操作完成
            let finishDuration:TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration, animations: {
                let nowAlpha = (context.viewController(forKey: .to)?.ul_navBarBgAlpha)!
                self.setNavigationBarBackground(alpha: nowAlpha)
                
                self.navigationBar.tintColor = context.viewController(forKey: .to)?.ul_navBarTintColor
            })
        }
    }
}
