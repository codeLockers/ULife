//
//  ULLoadingStyleOneView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/24.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULLoadingStyleOneView: ULBaseLoadingView {

    private let roundDiamater : CGFloat = 10
    fileprivate let animationDuration : CFTimeInterval = 1
    
    fileprivate let round1BackgroundColor : UIColor = UIColor.ul_random()
    fileprivate let round2BackgroundColor : UIColor = UIColor.ul_random()
    fileprivate let round3BackgroundColor : UIColor = UIColor.ul_random()
    
    fileprivate lazy var round1 : UIView = { [unowned self] in
        let view = UIView()
        view.ul_width = self.roundDiamater
        view.ul_height = self.roundDiamater
        view.backgroundColor = self.round1BackgroundColor
        view.layer.cornerRadius = self.roundDiamater / 2.0
        return view
    }()
    
    fileprivate lazy var round2 : UIView = { [unowned self] in
        let view = UIView()
        view.ul_width = self.roundDiamater
        view.ul_height = self.roundDiamater
        view.backgroundColor = self.round2BackgroundColor
        view.layer.cornerRadius = self.roundDiamater / 2.0
        return view
        }()
    
    fileprivate lazy var round3 : UIView = { [unowned self] in
        let view = UIView()
        view.ul_width = self.roundDiamater
        view.ul_height = self.roundDiamater
        view.backgroundColor = self.round3BackgroundColor
        view.layer.cornerRadius = self.roundDiamater / 2.0
        return view
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
//        print(" ULLoadingViewStyleOne dealloc")
    }
    
    //MARK: Load_UI
    private func loadUI() {
        self.addSubview(round1)
        self.addSubview(round2)
        self.addSubview(round3)
    }
    
    override func layout() {
        round2.center = self.center
        
        round1.center.y = round2.center.y
        round1.center.x = round2.center.x - 20
        
        round3.center.y = round2.center.y
        round3.center.x = round2.center.x + 20
        
        startAnimation()
    }
}

extension ULLoadingStyleOneView {
    
    fileprivate func startAnimation() {
    
        let otherRoundCenter1 = CGPoint.init(x: round1.center.x+10, y: round2.center.y)
        let otherRoundCenter2 = CGPoint.init(x: round2.center.x+10, y: round2.center.y)
        
        //圆1的路径
        let path1 = UIBezierPath.init()
        path1.addArc(withCenter: otherRoundCenter1, radius: 10, startAngle: -.pi, endAngle: 0, clockwise: true)
        let path1_1 = UIBezierPath.init()
        path1_1.addArc(withCenter: otherRoundCenter2, radius: 10, startAngle: .pi, endAngle: 0, clockwise: false)
        path1.append(path1_1)
        
        viewMovePathAnim(view: round1, path: path1, time: animationDuration)
        viewColorAnim(view: round1, fromColor: round1BackgroundColor, toColor: round3BackgroundColor, time: animationDuration)
        
        let path2 = UIBezierPath.init()
        path2.addArc(withCenter: otherRoundCenter1, radius: 10, startAngle: 0, endAngle: -.pi, clockwise: true)
        
        viewMovePathAnim(view: round2, path: path2, time: animationDuration)
        viewColorAnim(view: round2, fromColor: round2BackgroundColor, toColor: round1BackgroundColor, time: animationDuration)
        let path3 = UIBezierPath.init()
        path3.addArc(withCenter: otherRoundCenter2, radius: 10, startAngle: 0, endAngle: -.pi, clockwise: false)
        
        viewMovePathAnim(view: round3, path: path3, time: animationDuration)
        viewColorAnim(view: round3, fromColor: round3BackgroundColor, toColor: round2BackgroundColor, time: animationDuration)
    }

    func viewMovePathAnim(view:UIView, path:UIBezierPath, time:CFTimeInterval) {
        
        let anim = CAKeyframeAnimation.init(keyPath: "position")
        anim.path = path.cgPath
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        anim.calculationMode = kCAAnimationCubic
        anim.repeatCount = MAXFLOAT
        anim.duration = animationDuration
        anim.autoreverses = false
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(anim, forKey: "animation")
    }
    
    func viewColorAnim(view:UIView,fromColor:UIColor,toColor:UIColor,time:Double) {
        
        let colorAnim = CABasicAnimation.init(keyPath: "backgroundColor")
        colorAnim.toValue = toColor.cgColor
        colorAnim.fromValue = fromColor.cgColor
        colorAnim.duration = time
        colorAnim.autoreverses = false
        colorAnim.fillMode = kCAFillModeForwards;
        colorAnim.isRemovedOnCompletion = false;
        colorAnim.repeatCount = MAXFLOAT
        view.layer.add(colorAnim, forKey: "backgroundColor")
    }
}
