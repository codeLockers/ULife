//
//  ULTransitionStyleOneAnimation.swift
//  ULife
//
//  Created by codeLocker on 2017/3/24.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULTransitionStyleOneAnimation: NSObject {

    func beginAniamtion(colectionView:UICollectionView?, indexPath:IndexPath?, fromViewController:UIViewController?, toViewController:UIViewController?, completeBlock:@escaping() -> Void) -> ((UIViewController) -> Void)? {
        
        guard let collectionView = colectionView,
              let indexPath = indexPath,
              let fromViewController = fromViewController,
              let toViewController = toViewController else {
            return nil
        }
        
        //获取点击的cell的imageView
        let cell = collectionView.cellForItem(at: indexPath) as! ULTransitionStyleOneCollectionViewCell
        let imageView : UIImageView = cell.imageView
        
        // 先计算点击的那个 item 的那张图片的 frame 转换为窗口坐标以后的值 (相对坐标系为 : 窗口坐标) to = nil : 目标窗口为UIWindow
        guard let tapImageViewFrame = imageView.superview?.convert(imageView.frame, to: nil) else {
            return nil
        }
        // 计算将窗口截图裁剪为需要做动画的图片的裁剪点(imageView 上下各有一个裁剪点)(相对坐标系为 : 窗口坐标)
        let upTailorY = tapImageViewFrame.origin.y
        let downTailorY = upTailorY + tapImageViewFrame.size.height
        // 计算做动画的 ImageView 的初始 frame (相对坐标系为 : 窗口坐标)
        let upAnimationImageViewFrame_start = CGRect.init(x: 0, y: 0, width: ULConstants.screen.width, height: upTailorY)
        let downAnimationImageViewFrame_start = CGRect.init(x: 0, y: downTailorY, width: ULConstants.screen.width, height: ULConstants.screen.height - downTailorY)
        // 计算做动画的 ImageView 的终点 frame (相对坐标系为 : 窗口坐标)
        let upAnimationImageViewFrame_end = CGRect.init(x: 0, y: -upTailorY, width: ULConstants.screen.width, height: -upTailorY)
        let downAnimationImageViewFrame_end = CGRect.init(x: 0, y: ULConstants.screen.height, width: ULConstants.screen.width, height: ULConstants.screen.height - downTailorY)
        // 将当前窗口进行截图
        guard let snapImage = fromViewController.view.ul_takeSnapshot(fromViewController.view.frame) else {
            return nil
        }
        // 根据裁剪点分别裁剪图片, 待做动画的时候使用
        let scale = UIScreen.main.scale
        let upAnimationImage = snapImage.ul_crop(CGRect.init(x: 0, y: 0, width: snapImage.size.width*scale, height: upTailorY*scale))
        let downAnimationImage = snapImage.ul_crop(CGRect.init(x: 0, y: downTailorY*scale, width: snapImage.size.width*scale, height: (snapImage.size.height - downTailorY)*scale))
        //在Window上添加AniamtionView的ContainerView
        let animationContaienrView = UIView.init(frame: fromViewController.view.window!.bounds)
        animationContaienrView.backgroundColor = UIColor.white
        fromViewController.view.window?.addSubview(animationContaienrView)
        // 添加做动画需要的上下两个 ImageView, 以及点击的那个 item 的 ImageView 到窗口.
        let upAnimationImageView = UIImageView()
        upAnimationImageView.frame = upAnimationImageViewFrame_start
        upAnimationImageView.image = upAnimationImage
        animationContaienrView.addSubview(upAnimationImageView)

        let downAnimationImageView = UIImageView()
        downAnimationImageView.frame = downAnimationImageViewFrame_start
        downAnimationImageView.image = downAnimationImage
        animationContaienrView.addSubview(downAnimationImageView)
        // 处理 collectionView 每个可见 cell, 创建一个做动画的 ImageView 添加到窗口
        let (animationImageViews, animationFrames_starts) = self.addAnimationImageViews(collectionView, animationContaienrView: animationContaienrView)
        //根据点击的那个 cell 的目标位置推断出临近可见 cell 的目标位置 (相对坐标系为 : 窗口坐标)
        let animationFrames_ends = self.calculateAnimationImageViewEndFrame(startFrames: animationFrames_starts, tapImageViewFrame: tapImageViewFrame)
        
        UIView.animate(withDuration: 0.5, animations: {
            // 当前 View 变透明
            fromViewController.view.isHidden = true;
//            fromViewController.navigationController?.navigationBar.isHidden = true

            upAnimationImageView.frame = upAnimationImageViewFrame_end
            downAnimationImageView.frame = downAnimationImageViewFrame_end

            // collectionView 每个 cell 的照片动画
            for rect in animationFrames_starts{

                let index : Int = animationFrames_starts.index(of: rect)!
                let imageView = animationImageViews[index]
                let endFrame = animationFrames_ends[index]
                imageView.frame = endFrame
            }
            
        }) { (isfinish) in
            
            fromViewController.navigationController?.pushViewController(toViewController, animated: false)
            completeBlock()
            upAnimationImageView.image = nil
            upAnimationImageView.removeFromSuperview()

            downAnimationImageView.image = nil
            downAnimationImageView.removeFromSuperview()

            for imageView in animationImageViews{
                imageView.image = nil
                imageView.removeFromSuperview()
            }
            
            animationContaienrView.removeFromSuperview()
            fromViewController.view.isHidden = false
        }

        
        return self.closeAnimation(upAnimationImage!,
                                   upAnimationImageViewFrame_start: upAnimationImageViewFrame_start,
                                   upAnimationImageViewFrame_end: upAnimationImageViewFrame_end,
                                   downAniamtionImage: downAnimationImage!,
                                   downAniamtionImageFrame_start: downAnimationImageViewFrame_start,
                                   downAnimationImageViewFrame_end: downAnimationImageViewFrame_end,
                                   visiableCells: collectionView.visibleCells as! Array<ULTransitionStyleOneCollectionViewCell>,
                                   animationFrames_ends: animationFrames_ends,
                                   animationFrames_starts: animationFrames_starts,
                                   fromViewController: fromViewController,
                                   toViewController: toViewController)

    }
    
    func closeAnimation(_ upAnimationImage:UIImage,
                        upAnimationImageViewFrame_start:CGRect,
                        upAnimationImageViewFrame_end:CGRect,
                        downAniamtionImage:UIImage,
                        downAniamtionImageFrame_start:CGRect,
                        downAnimationImageViewFrame_end:CGRect,
                        visiableCells:Array<ULTransitionStyleOneCollectionViewCell>,
                        animationFrames_ends:[CGRect],
                        animationFrames_starts:[CGRect],
                        fromViewController:UIViewController,
                        toViewController:UIViewController) -> (UIViewController) -> Void{
        
        // 保存关闭动画为 block
        let closeBlock : (_ vc:UIViewController) -> Void = {vc in
            
            // 添加做动画需要的上下两个 ImageView, 以及点击的那个 item 的 ImageView 到窗口.
            let upAnimationImageView = UIImageView()
            upAnimationImageView.frame = upAnimationImageViewFrame_end
            upAnimationImageView.image = upAnimationImage
            vc.view.window?.addSubview(upAnimationImageView)
            
            let downAnimationImageView = UIImageView()
            downAnimationImageView.frame = downAnimationImageViewFrame_end
            downAnimationImageView.image = downAniamtionImage
            vc.view.window?.addSubview(downAnimationImageView)
            
            // collectionView 每个 cell 的照片动画
            var animationImageViews = [UIImageView]()
            
            for cell in visiableCells {
                
                let imageView = UIImageView()
                animationImageViews.append(imageView)
                let index : Int = visiableCells.index(of: cell)!
                
                imageView.frame = animationFrames_ends[index]
                imageView.image = cell.imageView.image
                
                vc.view.window?.addSubview(imageView)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                
                upAnimationImageView.frame = upAnimationImageViewFrame_start
                downAnimationImageView.frame = downAniamtionImageFrame_start
                
                // collectionView 每个 cell 的照片动画
                for imageView in animationImageViews{
                    
                    let index:Int = animationImageViews.index(of: imageView)!
                    imageView.frame = animationFrames_starts[index]
                }
                
            }, completion: { (finish) in
                
                upAnimationImageView.image = nil
                upAnimationImageView.removeFromSuperview()
                
                downAnimationImageView.image = nil
                downAnimationImageView.removeFromSuperview()
                
                for imageView in animationImageViews{
                    
                    imageView.image = nil
                    imageView.removeFromSuperview()
                }
                let _ = toViewController.navigationController?.popViewController(animated: false)
                fromViewController.navigationController?.navigationBar.isHidden = false
                
            })
        }
        return closeBlock
    }

    /// 执行动画的cell周边所有可见cell 创建AnimationImageView
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - viewController: fromController
    /// - Returns: (所有可见的cell的AnimationImageView,所有cell的其实坐标)
    func addAnimationImageViews(_ collectionView:UICollectionView, animationContaienrView:UIView) -> ([UIImageView],[CGRect]) {
        // 处理 collectionView 每个可见 cell, 创建一个做动画的 ImageView 添加到窗口
        let cells = collectionView.visibleCells as! [ULTransitionStyleOneCollectionViewCell]
        var animationImageViews : [UIImageView] = []
        var animationFrames_starts : [CGRect] = []
    
        for cell in cells {
            // 先添加可见 cell 个数的动画 imageView 到窗口
            // 计算每张图片的 frame 转换为窗口的 frame (相对坐标系为 : 窗口坐标)
            let imageView = cell.imageView
            let rect = imageView.superview?.convert(imageView.frame, to: nil)
            animationFrames_starts.append(rect!)
    
            let animationImageView = UIImageView()
            animationImageView.image = imageView.image
            animationImageView.frame = rect!
            animationContaienrView.addSubview(animationImageView)
            animationImageViews.append(animationImageView)
        }
        return (animationImageViews, animationFrames_starts)
    }
    
    /// 根据点击的cell的位置计算出临近可见cell的目标位置
    ///
    /// - Parameters:
    ///   - animationFrames_starts: 所有可见cell的起始位置
    ///   - tapImageViewFrame: 点击的cell的位置
    /// - Returns: 可见cell的目标位置
    func calculateAnimationImageViewEndFrame(startFrames animationFrames_starts:[CGRect] ,tapImageViewFrame:CGRect) -> [CGRect] {
    
        // 根据点击的那个 cell 的目标位置推断出临近可见 cell 的目标位置 (相对坐标系为 : 窗口坐标)
        let tapAniamtionImageViewFrame_end = CGRect.init(x: 0, y: 0, width: ULConstants.screen.width, height: ULConstants.screen.width*2/3.0)
        var animationFrames_ends : [CGRect] = []
    
        for rect in animationFrames_starts {
    
            var targetRect = tapAniamtionImageViewFrame_end
            // 在点击 cell 的左侧
            if rect.origin.x < tapImageViewFrame.origin.x {
                let detla = tapImageViewFrame.origin.x - rect.origin.x
                targetRect.origin.x = -(detla * ULConstants.screen.width)/tapImageViewFrame.size.width
            }
            else if rect.origin.x < tapImageViewFrame.origin.x{
    
            }else if rect.origin.x > tapImageViewFrame.origin.x {
    
                let detla = rect.origin.x - tapImageViewFrame.origin.x
                targetRect.origin.x = (detla*ULConstants.screen.width)/tapImageViewFrame.size.width
            }
            animationFrames_ends.append(targetRect)
        }
        return animationFrames_ends
    }
}
