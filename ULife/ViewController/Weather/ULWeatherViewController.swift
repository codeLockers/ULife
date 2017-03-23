//
//  ULWeatherViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/2/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWeatherViewController: ULBaseViewController {
    
    private let effectMotionLength : CGFloat = 50
    
    //遮罩
    fileprivate let maskView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
        }()
    fileprivate lazy var imageView : UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "image")?.ul_scaleAspect(minSize: CGSize.init(width:self.view.ul_width+2 * self.effectMotionLength,height:self.view.ul_height+2 * self.effectMotionLength))
        imageView.contentMode = .center
        return imageView
    }()
    
    //MARK: - Life_Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        layout()
        
        ULNotificationCenterManager.manger.registerPushViewController(self, selector: #selector(pushViewControler))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ULNotificationCenterManager.manger.postEnableSidebar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        ULNotificationCenterManager.manger.removeObserver(self)
    }
    
    //MARK: - Private_Methods
    @objc
    func pushViewControler(_ notification:NSNotification?) {
        
        let vc = notification?.object
        if vc is UIViewController {
            self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
            ULNotificationCenterManager.manger.postDisableSidebar()
        }
    }

    //MARK: - Load_UI
    private func loadUI() {
        self.navigationItem.title = "Weather"
        self.ul_navBarBgAlpha = 0
        self.view.addSubview(imageView)
        self.view.addSubview(maskView)
        
        imageView.effectGroup = UIMotionEffectGroup.init()
        imageView.setEffect(xValue: 50, yValue: 50)
    }
    
    private func layout() {

        maskView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(-effectMotionLength, -effectMotionLength, -effectMotionLength, -effectMotionLength))
        }
    }
}
