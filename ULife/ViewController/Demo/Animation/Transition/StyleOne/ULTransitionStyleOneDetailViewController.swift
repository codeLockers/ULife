//
//  ULTransitionStyleOneDetailViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/3/24.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULTransitionStyleOneDetailViewController: ULBaseViewController {

    var coverImage : UIImage?
    var closeAnimationBlock : ((UIViewController) -> Void)?
    
    lazy var fadeAnimationBlock : () -> Void = { [unowned self] in
        
        UIView.animate(withDuration: 0.35, animations: {
            
            self.detailBtn.frame.origin.y = UIScreen.main.bounds.size.width * 2/3.0
            
        }, completion: { (finish) in
        })
    }
    
    fileprivate let imageView : UIImageView = {
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: ULConstants.screen.width, height: ULConstants.screen.width/3*2.0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let detailBtn : UIButton = {
    
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: ULConstants.screen.height, width: ULConstants.screen.width, height: ULConstants.screen.height - ULConstants.screen.width/3*2.0))
        btn.backgroundColor = UIColor.ul_random()
        btn.addTarget(self, action: #selector(button_Pressed), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "DEtail"
        self.view.backgroundColor = UIColor.white
        self.imageView.image = self.coverImage
        self.view.addSubview(self.imageView)
        self.view.addSubview(detailBtn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func button_Pressed() {
        
//        let animationContainerView = UIView.init(frame: self.view.bounds)
//        animationContainerView.backgroundColor = UIColor.white
//        self.view.addSubview(animationContainerView)
//        
//        self.closeAnimationBlock?(self)
        
        let _ = self.navigationController?.popViewController(animated: true)
    }

}
