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
    fileprivate let weatherViewModel = ULWeatherViewModel()
    //遮罩
    fileprivate let maskView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
        }()
    //背景图片
    fileprivate lazy var imageView : UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "image")?.ul_scaleAspect(minSize: CGSize.init(width:self.view.ul_width+2 * self.effectMotionLength,height:self.view.ul_height+2 * self.effectMotionLength))
        imageView.contentMode = .center
        return imageView
    }()
    //地区View
    fileprivate let regionView : ULWeatherRegionView = ULWeatherRegionView()
    //日期时间View
    fileprivate let dateView : ULWeatherDateView = ULWeatherDateView()
    
    //MARK: - Life_Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKVO()
        registerNotification()
        loadData()
        loadUI()
        layout()
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
        self.weatherViewModel.removeObserver(self, forKeyPath: ULWeatherViewModel_CurrentRegion_Singal)
    }
    
    //MARK: - Load_Data
    private func loadData() {
        self.regionView.startLoading()
        self.weatherViewModel.currentRegion()
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.navigationItem.title = "Weather"
        self.ul_navBarBgAlpha = 0
        
        imageView.effectGroup = UIMotionEffectGroup.init()
        imageView.setEffect(xValue: 50, yValue: 50)
        self.view.addSubview(imageView)
        
        self.view.addSubview(maskView)
        self.view.addSubview(regionView)
        self.view.addSubview(dateView)
    }
    
    private func layout() {

        maskView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(-effectMotionLength, -effectMotionLength, -effectMotionLength, -effectMotionLength))
        }
        regionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(64)
            make.height.equalTo(ULConstants.screen.width * 0.15)
        }
        dateView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(regionView.snp.bottom)
            make.right.equalToSuperview()
            make.height.equalTo(regionView)
        }
    }
}

//Notification
extension ULWeatherViewController {
    
    fileprivate func registerNotification() {
        ULNotificationCenterManager.manger.registerPushViewController(self, selector: #selector(pushViewControler))
    }
    
    @objc
    func pushViewControler(_ notification:NSNotification?) {
        
        let vc = notification?.object
        if vc is UIViewController {
            self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
            ULNotificationCenterManager.manger.postDisableSidebar()
        }
    }
}

//KVO
extension ULWeatherViewController {

    fileprivate func registerKVO() {
        
        self.weatherViewModel.addObserver(self, forKeyPath: ULWeatherViewModel_CurrentRegion_Singal, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let newValue = change?[NSKeyValueChangeKey.newKey] as? String
        if keyPath == ULWeatherViewModel_CurrentRegion_Singal {
            self.regionView.stopLoading()
            //获取当前地区
            guard newValue == ULViewModelSingalType.success.rawValue else {
                return
            }
            self.regionView.updateRegion(self.weatherViewModel.currentRegionRegeoCode)
        }
    }
}
