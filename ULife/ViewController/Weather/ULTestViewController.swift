//
//  ULTestViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/2/26.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULTestViewController: UIViewController {

    fileprivate let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.ul_random()
        imageView.image = UIImage.init(named: "image")
        imageView.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        //            ?.ul_scaleAspect(minSize: CGSize.init(width:ULConstants.screen.width+20,height:ULConstants.screen.height+20))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blue
        
        self.view.addSubview(imageView)
        
        let x = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        x.minimumRelativeValue = (-50)
        x.maximumRelativeValue = (50)
        
        self.imageView.addMotionEffect(x)
        
        let y = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        y.minimumRelativeValue = -50
        y.maximumRelativeValue = 50
        
        self.imageView.addMotionEffect(y)
        
        
//        UIInterpolatingMotionEffect * fairyEffX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];// type表示沿水平方向运行效果
//        fairyEffX.maximumRelativeValue = @(50);
//        fairyEffX.minimumRelativeValue = @(-50);
//        // 为view添加运动效果
//        [self.fairy addMotionEffect:fairyEffX];
//        
//        UIInterpolatingMotionEffect * fairyEffY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
//        fairyEffY.maximumRelativeValue = @(50);
//        fairyEffY.minimumRelativeValue = @(-50);
//        [self.fairy addMotionEffect:fairyEffY];
        
//        print(self.navigationController!.parent!)
        
//        let vc = self.navigationController!.parent! as! ULSidebarViewController
//        vc.diableSideBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
