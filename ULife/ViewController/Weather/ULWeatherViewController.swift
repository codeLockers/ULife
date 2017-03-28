//
//  ULWeatherViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/2/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
//UI
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
    //实时天气view
    fileprivate let weatherCurrentview : ULWeatherLiveView = ULWeatherLiveView()
    //预报天气view
    fileprivate let weatherForecastView : ULWeatherForecastView = ULWeatherForecastView()
    
    //MARK: - Life_Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKVO()
        registerNotification()
        loadUI()
        layout()
        loadData()
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
        self.weatherViewModel.removeObserver(self, forKeyPath: ULWeatherViewModel_CurrentLiveWeather_Singal)
        self.weatherViewModel.removeObserver(self, forKeyPath: ULWeatherViewModel_CurrentForecasWeather_Singal)
    }
    
    //MARK: - Load_Data
    fileprivate func loadData() {
        ULLoadingStyleOneView.show(in: self.view)
        self.isLoading = true
        self.weatherViewModel.currentRegion()
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.navigationItem.title = "Weather"
        self.ul_navBarBgAlpha = 0
        self.navigationController?.ul_setRightItem(style: .refresh, delegate: self, action: #selector(refreshBtn_Pressed))
        
        imageView.ul_effectGroup = UIMotionEffectGroup.init()
        imageView.ul_setEffect(xValue: 50, yValue: 50)
        self.view.addSubview(imageView)
        
        self.view.addSubview(maskView)
        self.view.addSubview(regionView)
        self.view.addSubview(dateView)
        
        self.view.addSubview(weatherCurrentview)
        self.view.addSubview(weatherForecastView)
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
        weatherCurrentview.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(dateView.snp.bottom).offset(20)
            make.height.equalTo(ULConstants.screen.width * 0.618)
        }
        weatherForecastView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(weatherCurrentview.snp.bottom).offset(10)
        }
    }
}

extension ULWeatherViewController {
    
    @objc
    fileprivate func refreshBtn_Pressed() {
        if self.isLoading {
            return
        }
        self.loadData()
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
        self.weatherViewModel.addObserver(self, forKeyPath: ULWeatherViewModel_CurrentLiveWeather_Singal, options: .new, context: nil)
        self.weatherViewModel.addObserver(self, forKeyPath: ULWeatherViewModel_CurrentForecasWeather_Singal, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let newValue = change?[NSKeyValueChangeKey.newKey] as? String
        if keyPath == ULWeatherViewModel_CurrentRegion_Singal {
            //获取当前地区
            guard newValue == ULViewModelSingalType.success.rawValue else {
                self.view.ul_hint("定位失败")
                return
            }
            self.regionView.updateRegion(self.weatherViewModel.currentRegionRegeoCode)
            //获取实时天气
            self.weatherViewModel.liveWeather(self.weatherViewModel.currentRegionRegeoCode?.adcode)
            
        }else if keyPath == ULWeatherViewModel_CurrentLiveWeather_Singal {
            //获取当前实时天气
            guard newValue == ULViewModelSingalType.success.rawValue else {
                self.view.ul_hint("获取实时天气失败")
                return
            }
            self.weatherCurrentview.updateLiveWeather(self.weatherViewModel.currentLiveWeather)
            //获取预报天气
            self.weatherViewModel.forecastWeather(self.weatherViewModel.currentRegionRegeoCode?.adcode)
            
        }else if keyPath == ULWeatherViewModel_CurrentForecasWeather_Singal {
            ULLoadingStyleOneView.hide(from: self.view)
            self.isLoading = false
            guard newValue == ULViewModelSingalType.success.rawValue else {
                self.view.ul_hint("获取预报天气失败")
                return
            }
            self.weatherCurrentview.updateForecastWeather(self.weatherViewModel.currentForecastWeathers)
            self.weatherForecastView.updateForecastWeather(self.weatherViewModel.currentForecastWeathers)
        }
    }
}
