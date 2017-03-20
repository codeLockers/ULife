//
//  ULSpinningLabel.swift
//  ULife
//
//  Created by codeLocker on 2017/3/20.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULSpinningLabelChange: NSObject {
    
    fileprivate var attributeTitle : NSAttributedString?
    fileprivate var spinUp : Bool?
    fileprivate var animated : Bool?
    fileprivate var waitingLayout : Bool?
    
    override init() {
        super.init()
    }
    
    convenience init(newAttributedTitle : NSAttributedString , newSpinUp : Bool , newAnimated : Bool , newWaitingLayout : Bool) {
        self.init()
        attributeTitle = newAttributedTitle
        spinUp = newSpinUp
        animated = newAnimated
        waitingLayout = newWaitingLayout
    }
}

//方向
public enum ULSpinningLabelDirection{
    case downWard   //向下
    case upWard     //向上
}
//效果
enum ULSpinningLabelSetting {
    case none           //无动画
    case animated       //动画
}

class ULSpinningLabel: UIView {
    //最终静态显示的label
    fileprivate let titleLabel : UILabel = UILabel()
    //逐渐消失动画的label
    fileprivate let disappearingLabel : UILabel = UILabel()
    //逐渐显示动画的label
    fileprivate let appearineLabel : UILabel = UILabel()
    //下一页显示内容的属性状态
    fileprivate var nextChange : ULSpinningLabelChange?
    //是否正在动画
    fileprivate var isAnimating : Bool = false
    //标题
    var title : String? {
    
        get{
            return nextChange == nil ? titleLabel.text : nextChange?.attributeTitle?.string
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    convenience init(title:String){
        self.init(frame: CGRect.zero)
        titleLabel.attributedText = NSAttributedString.init(string: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Load_UI
    private func loadUI() {
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        disappearingLabel.textAlignment = .center
        addSubview(disappearingLabel)

        appearineLabel.textAlignment = .center
        addSubview(appearineLabel)
    }
    
    //MARK: - Public_Methods
    func setAttributedTitle(_ newTitle : NSAttributedString , spinDirection : ULSpinningLabelDirection , spinSetting : ULSpinningLabelSetting) {

        let spinUp = spinDirection == .upWard
        let animated = spinSetting == .animated
        setAttributedTitle(newTitle, spinUp: spinUp, animated: animated)
    }
    
    //MARK: - Private_Methods
    private func setAttributedTitle(_ newTitle:NSAttributedString, spinUp:Bool, animated:Bool){
        
        if titleLabel.attributedText == newTitle {
            nextChange = nil
            return
        }
        //正在动画
        if isAnimating {
            nextChange = ULSpinningLabelChange.init(newAttributedTitle: newTitle, newSpinUp: spinUp, newAnimated: animated, newWaitingLayout: false)
            return
        }
        //原先标题
        let oldTitle : NSAttributedString? = titleLabel.attributedText

        titleLabel.attributedText = newTitle

        //开始动画
        isAnimating = true
        //动画方向
        let spinDirection : CGFloat = spinUp ? 1 : -1
        //self的width
        let totalWidth = self.frame.width
        //self的height
        let totalHeight = self.frame.height
        //self的center
        let boundsCenter = CGPoint.init(x: totalWidth/2.0, y: totalHeight/2.0)

        let appearOffset = ceil(spinDirection * 0.8 * totalHeight)
        let willAppearTransform = CATransform3DMakeTranslation(0, appearOffset, 0)
        let didAppearTransform = CATransform3DIdentity

        let disappearPerspective = -0.01
        let disappearRotation = spinDirection * CGFloat(M_PI_4)
        let disappearOffset = ceil(-spinDirection * 1.5 * totalHeight)
        var willDisappearTransform = CATransform3DIdentity
        willDisappearTransform.m34 = CGFloat(disappearPerspective)

        var didDisappearTransform = CATransform3DRotate(willDisappearTransform, disappearRotation, 1, 0, 0);
        didDisappearTransform = CATransform3DTranslate(didDisappearTransform, 0, disappearOffset, 0);

        titleLabel.isHidden = true;
        //设置新标题
        
        disappearingLabel.isHidden = false
        disappearingLabel.attributedText = oldTitle
        disappearingLabel.layer.anchorPoint = CGPoint.init(x: 0.5, y: spinUp ? 1 : 0)
        disappearingLabel.bounds = CGRect.init(x: 0, y: 0, width: totalWidth, height: totalHeight)
        disappearingLabel.center = CGPoint.init(x: boundsCenter.x, y: boundsCenter.y + spinDirection * totalHeight / 2)
        disappearingLabel.layer.transform = willDisappearTransform
        disappearingLabel.alpha = 1.0

        appearineLabel.isHidden = false
        appearineLabel.attributedText = newTitle
        appearineLabel.bounds = CGRect.init(x: 0, y: 0, width: totalWidth, height: totalHeight)
        appearineLabel.center = boundsCenter
        appearineLabel.layer.transform = willAppearTransform
        appearineLabel.alpha = 0

        performAnimated(true, duration: CATransaction.animationDuration(), animation: {
            
            self.appearineLabel.alpha = 1
            self.appearineLabel.layer.transform = didAppearTransform
            self.disappearingLabel.alpha = 0
            self.disappearingLabel.layer.transform  = didDisappearTransform
            
        }) { (isCompleted) in
            
            self.titleLabel.isHidden = false
            self.disappearingLabel.isHidden = true
            self.appearineLabel.isHidden = true
            self.isAnimating = false
        }
    }
    
    private func performAnimated(_ isAnimated:Bool , duration:TimeInterval , animation:@escaping ()->Void , completion:((Bool)->Void)?) {
        if isAnimated {
            UIView.animate(withDuration: duration, animations: animation, completion: completion)
        }
    }
}
