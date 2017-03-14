//
//  ULAnimationFoldingCellView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/8.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
import SnapKit

class ULAnimationFoldingView: ULAnimationBaseView {
    //第一部分视图
    fileprivate let foregroundView : ULAnimationFoldingRotateView = ULAnimationFoldingRotateView()
    //第二部分视图容器
    fileprivate let containerView : UIView = UIView()
    //第二部分视图容器的第一块视图
    fileprivate let firstView : UIView = UIView()
    //第二部分视图容器的第二块视图
    fileprivate let secondView : ULAnimationFoldingRotateView = ULAnimationFoldingRotateView()
    //第二部分视图容器的第三块视图
    fileprivate let thirdView : ULAnimationFoldingRotateView = ULAnimationFoldingRotateView()
    //第二部分视图容器的第四块视图
    fileprivate let forthView : ULAnimationFoldingRotateView = ULAnimationFoldingRotateView()

    //foregroundView距离顶部距离
    private var foregroundTopConstraint : ConstraintMakerEditable?
    //containerView距离顶部的距离
    private var containerTopConstraint : ConstraintMakerEditable?
    //动画容器视图
    private var animationView : UIView?
    //containerView容器中的item的数量
    private let itemCount : NSInteger = 4
    //所有rotateView的数据
    var animationItemViews: [ULAnimationFoldingRotateView]?

    enum ULAnimationFoldingViewType {
        case open   //展开动画
        case close  //关闭动画
    }
    
    //MARK: - Life_Circle
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Private_Methods
    /// 配置初始状态
    private func configDefaultState(){
        //设置foregroundView圆角
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        //隐藏containerView
        containerView.alpha = 0
        containerView.layer.cornerRadius = foregroundView.layer.cornerRadius
        containerView.layer.masksToBounds = true
        containerTopConstraint?.constraint.update(offset: 7)
        //设置foreground的锚点
        foregroundView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        //设置了锚点位置出现偏移，需要调整
        let heightConstraint : NSLayoutConstraint? = foregroundView.constraints.filter{ $0.firstAttribute == .height && $0.secondItem == nil}.first
        //foregroundView有高度约束的条件下
        if let height = heightConstraint?.constant {
            foregroundTopConstraint?.constraint.update(offset: height/2+7)
        }
        foregroundView.layer.transform = foregroundView.transform3d()
        createAnimationView()
        self.bringSubview(toFront: foregroundView)
    }
    
    /// 创建动画容器视图,将cantianerView上的每一块进行截图添加到animationView上进行动画展示
    private func createAnimationView(){

        animationView = UIView.init(frame: containerView.frame)
        animationView?.backgroundColor = .clear
        animationView?.layer.cornerRadius = foregroundView.layer.cornerRadius
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        animationView?.alpha = 0
        
        guard let animationView = self.animationView else { return }
        self.addSubview(animationView)
        
        //复制containerView的约束
        
        animationView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
    }
    
    /// 删除animationView上的所有subViews
    private func removeImageItemsFromAniamtionView(){
        guard let animationView = self.animationView else {
            return
        }
        animationView.subviews.forEach({$0.removeFromSuperview()})
    }
    //创建所有rotateView的数组
    func createAnimationItemView()->[ULAnimationFoldingRotateView] {
        guard let animationView = self.animationView else {
            fatalError()
        }
        
        var items = [ULAnimationFoldingRotateView]()
        //添加froegroundView
        items.append(foregroundView)
        var rotatedViews = [ULAnimationFoldingRotateView]()
        //遍历animationView所有的subView
        for case let itemView as ULAnimationFoldingRotateView in animationView.subviews.filter({$0 is ULAnimationFoldingRotateView}).sorted(by: {$0.tag < $1.tag}) {
            //添加animationView的subView
            rotatedViews.append(itemView)
            //如果rotateView包含下一个rotateView的翻转辅助效果图的话，将辅助效果图添加到数组中
            if let backView = itemView.backView {
                rotatedViews.append(backView)
            }
        }
        //合并两个数组
        items.append(contentsOf: rotatedViews)
        return items
    }
    
    private func addImageItemsToAnimationView(){
        //显示containerView用于截图
        containerView.alpha = 1
        //contaienrView's size
        let containerSize = containerView.bounds.size
        //foregroundView's size
        let foregroundSize = foregroundView.bounds.size
        //对containerView上的第一个item进行截图
        var image = containerView.ul_takeSnapshot(CGRect.init(x: 0, y: 0, width: containerSize.width, height: foregroundSize.height))
        var imageView = UIImageView.init(image: image)
        imageView.layer.cornerRadius = foregroundView.layer.cornerRadius
        imageView.tag = 0
        //添加到animationView
        animationView?.addSubview(imageView)
        
        //对containerView第二个item进行截图
        image = containerView.ul_takeSnapshot(CGRect.init(x: 0, y: foregroundSize.height, width: containerSize.width, height: foregroundSize.height))
        imageView = UIImageView.init(image: image)
        //第二个item需要进行旋转使用RotateView
        let rotateView = ULAnimationFoldingRotateView()
        rotateView.tag = 1
        rotateView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        rotateView.layer.transform = rotateView.transform3d()
        rotateView.addSubview(imageView)
        rotateView.frame = CGRect.init(x: imageView.frame.origin.x, y: foregroundSize.height, width: containerSize.width, height: foregroundSize.height)
        animationView?.addSubview(rotateView)
        
        //其余item的高度,其他item高度一样高
        let itemHeight = (containerSize.height - 2 * foregroundSize.height) / CGFloat(itemCount - 2)
        //其余item的其实位置
        var yPosition = 2 * foregroundSize.height
        //其余item的tag其实值
        var tag = 2
        for _ in 2..<itemCount {
            //其他item进行截图
            image = containerView.ul_takeSnapshot(CGRect.init(x: 0, y: yPosition, width: containerSize.width, height: itemHeight))
            imageView = UIImageView.init(image: image)
            //其余item需要进行旋转使用rotateView
            let rotateView = ULAnimationFoldingRotateView.init(frame: imageView.frame)
            rotateView.addSubview(imageView)
            rotateView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
            rotateView.layer.transform = rotateView.transform3d()
            animationView?.addSubview(rotateView)
            rotateView.frame = CGRect.init(x: 0, y: yPosition, width: rotateView.bounds.size.width, height: itemHeight)
            rotateView.tag = tag
            //yPosition累加
            yPosition += itemHeight
            //tag累加
            tag += 1
        }
        //隐藏caontainerView
        containerView.alpha = 0
        animationView?.alpha = 1
        //为containerView的third和fourth item添加从0转到-90度的效果动画View containerView的first不需要 containerView的second的此效果动画View为foregroundView
        if let animationView = self.animationView {

            var previusView: ULAnimationFoldingRotateView?
            //animaitonView中类型为rotateView 其tag>0的subView (second、third、fourth)
            for case let contener as ULAnimationFoldingRotateView in animationView.subviews.sorted(by: { $0.tag < $1.tag })
                where contener.tag > 0 && contener.tag < animationView.subviews.count {
                    //first的时候previus为nil
                    previusView?.addBackView(contener.bounds.size.height, color: UIColor.black)
                    //second是first上添加second使用效果view、third是second上添加third使用效果view、
                    previusView = contener
            }

        }
        //为所有需要进行旋转的rotateView添加到数组中
        animationItemViews = createAnimationItemView()
    }
    
    /// 获取动画时间数组
    ///
    /// - Parameter type: 动画类型
    /// - Returns: 时间数组
    private func durationSequence(_ type: ULAnimationFoldingViewType)-> [TimeInterval] {
        var durations : [TimeInterval] = [0.26, 0.2, 0.2]
        for index in 0..<itemCount-1 {
            let duration = durations[index]
            durations.append(TimeInterval(duration / 2.0))
            durations.append(TimeInterval(duration / 2.0))
        }
        return durations
    }
    
    /// 展开动画
    private func openAnimation(_ completion:((Void) -> Void)?) {
    
        removeImageItemsFromAniamtionView()
        addImageItemsToAnimationView()
        guard let animationView = self.animationView else {
            return
        }
        //显示animationView
        animationView.alpha = 1;
        //隐藏containerView
        containerView.alpha = 0;
        
        let durations = durationSequence(.open)
        var delay: TimeInterval = 0
        var timing                = kCAMediaTimingFunctionEaseIn
        var from: CGFloat         = 0.0;
        var to: CGFloat           = CGFloat(-M_PI / 2)
        var hidden                = true
        configureAnimationItems(.open)
        
        guard let animationItemViews = self.animationItemViews else {
            return
        }
        
        for index in 0..<animationItemViews.count {
            //animationView
            let animatedView = animationItemViews[index]
            //animationView执行动画
            animatedView.foldingAnimation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
            //foregroundView    0 -> -90    hide:true
            //second            90 -> 0     hide:false
            //thirdBack         0 -> -90    hide:true
            //third             90 -> 0     hide:false
            //fourthBack        0 -> -90    hide:true
            //fourth            90 -> 0     hide:fasle
            from   = from == 0.0 ? CGFloat(M_PI / 2) : 0.0;
            to     = to == 0.0 ? CGFloat(-M_PI / 2) : 0.0;
            timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
            hidden = !hidden
            //动画时间一次累计
            delay += durations[index]
        }
        
        //containerView的first
        let firstItemView = animationView.subviews.filter{$0.tag == 0}.first
        firstItemView?.layer.masksToBounds = true
        DispatchQueue.main.asyncAfter(deadline: .now() + durations[0], execute: {
            firstItemView?.layer.cornerRadius = 0
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            //所有动画结束后
            self.animationView?.alpha = 0
            self.containerView.alpha  = 1
            //            completion?()
        })
    }
    
    private func closeAniamtion(_ completion:((Void) -> Void)?){
    
        removeImageItemsFromAniamtionView()
        addImageItemsToAnimationView()
        
        guard let animationItemViews = self.animationItemViews else {
            fatalError()
        }
        
        animationView?.alpha = 1;
        containerView.alpha  = 0;
        
        var durations: [TimeInterval] = durationSequence(.close).reversed()
        
        var delay: TimeInterval = 0
        var timing                = kCAMediaTimingFunctionEaseIn
        var from: CGFloat         = 0.0;
        var to: CGFloat           = CGFloat(M_PI / 2)
        var hidden                = true
        configureAnimationItems(.close)
        
        if durations.count < animationItemViews.count {
            fatalError("wrong override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval")
        }
        for index in 0..<animationItemViews.count {
            let animatedView = animationItemViews.reversed()[index]
            
            animatedView.foldingAnimation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
            
            to     = to == 0.0 ? CGFloat(M_PI / 2) : 0.0;
            from   = from == 0.0 ? CGFloat(-M_PI / 2) : 0.0;
            timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
            hidden = !hidden
            delay += durations[index]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.animationView?.alpha = 0
            completion?()
        })
        //animationView的firstView
        let firstItemView = animationView?.subviews.filter{$0.tag == 0}.first
        firstItemView?.layer.cornerRadius = 0
        firstItemView?.layer.masksToBounds = true
        
        //获取foregroundView 的时间
        if let durationFirst = durations.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay - durationFirst * 2, execute: {
                firstItemView?.layer.cornerRadius = self.foregroundView.layer.cornerRadius
                firstItemView?.setNeedsDisplay()
                firstItemView?.setNeedsLayout()
            })
        }

    }
    
    /// 配置animationView上的item
    ///
    /// - Parameter animationType: 当前的动画状态
    func configureAnimationItems(_ animationType: ULAnimationFoldingViewType) {
        
        guard let animationViewSuperView = animationView?.subviews else {
            fatalError()
        }
        //展开动画
        if animationType == .open {
            for view in animationViewSuperView.filter({$0 is ULAnimationFoldingRotateView}) {
                //所有item隐藏
                view.alpha = 0;
            }
        } else { // close
            for case let view as ULAnimationFoldingRotateView in animationViewSuperView.filter({$0 is ULAnimationFoldingRotateView}) {
                if animationType == .open {
                    view.alpha = 0
                } else {
                    view.alpha = 1
                    view.backView?.alpha = 0
                }
            }
        }
    }
    
    /// 当前动画是否正在进行
    ///
    /// - Returns: YES:正在进行动画 NO:没有进行动画
    private func isAniamting() -> Bool{
        return animationView?.alpha == 1 ? true : false
    }
    
    //MARK: - UIButton_Actions
    override func startBtn_Pressed(_ sender:UIButton){
        
        if isAniamting() {
            return
        }
        
        if !startBtn.isSelected {
            //展开动画
            openAnimation(nil)
        }else{
            //闭合动画
            closeAniamtion(nil)
        }
        sender.isSelected = !sender.isSelected
    }

    //MARK: - Load_UI
    private func loadUI(){

        loadForegroundView()
        loadContainerView()
        configDefaultState()
    }

    private func loadForegroundView() {

        foregroundView.backgroundColor = UIColor.green
        self.addSubview(foregroundView)
        foregroundView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            foregroundTopConstraint = make.top.equalToSuperview().offset(7)
            make.height.equalTo(165)
        }
    }

    private func loadContainerView(){

        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            containerTopConstraint = make.top.equalTo(self).offset(180)
            make.height.equalTo(474)
        }

        firstView.backgroundColor = UIColor.purple
        containerView.addSubview(firstView)
        firstView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(165)
        }

        secondView.backgroundColor = UIColor.brown
        containerView.addSubview(secondView)
        secondView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(firstView.snp.bottom)
            make.height.equalTo(165)
        }

        thirdView.backgroundColor = UIColor.blue
        containerView.addSubview(thirdView)
        thirdView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(secondView.snp.bottom)
            make.height.equalTo(72)
        }

        forthView.backgroundColor = UIColor.cyan
        containerView.addSubview(forthView)
        forthView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(thirdView.snp.bottom)
            make.height.equalTo(72)
        }
    }
}



