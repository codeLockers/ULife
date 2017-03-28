//
//  ULWeatherLiveView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/27.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWeatherLiveView: UIView {

    fileprivate let weatherView = UIView()
    fileprivate let weatherImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    fileprivate let weatherNameLab : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    fileprivate let iconView : UIView = {
        let view = UIView()

        let temperatureImageView = UIImageView()
        temperatureImageView.contentMode = .center
        temperatureImageView.image = UIImage.init(named: "ul_weather_temperature")
        view.addSubview(temperatureImageView)
        
        let windImageView = UIImageView()
        windImageView.contentMode = .center
        windImageView.image = UIImage.init(named: "ul_weather_wind")
        view.addSubview(windImageView)
        
        let humidityImageView = UIImageView()
        humidityImageView.contentMode = .center
        humidityImageView.image = UIImage.init(named: "ul_weather_humidity")
        view.addSubview(humidityImageView)
        
        temperatureImageView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(humidityImageView)
        })
        
        windImageView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(temperatureImageView.snp.bottom)
            make.height.equalTo(temperatureImageView)
        })
        
        humidityImageView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(windImageView.snp.bottom)
        })
        
        return view
    }()
    
    fileprivate let weatherLiveDetailCurrent : ULWeatherLiveDetailView = {
        let view = ULWeatherLiveDetailView()
        view.title = "Current"
        return view
    }()
    fileprivate let weatherLiveDetailDay : ULWeatherLiveDetailView = {
        let view = ULWeatherLiveDetailView()
        view.title = "Day"
        return view
    }()
    fileprivate let weatherLiveDetailNight : ULWeatherLiveDetailView = {
        let view = ULWeatherLiveDetailView()
        view.title = "Night"
        return view
    }()
    
    fileprivate var liveWeather : AMapLocalWeatherLive? {
        set {
            guard newValue != nil else {
                return
            }
            self.updateLiveWeather(newValue!)
        }
        get {
            return self.liveWeather
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Load_UI
    private func loadUI() {
        
        self.addSubview(weatherView)
        weatherView.addSubview(weatherImageView)
        weatherView.addSubview(weatherNameLab)
        
        self.addSubview(iconView)
        
        self.addSubview(weatherLiveDetailCurrent)
        self.addSubview(weatherLiveDetailDay)
        self.addSubview(weatherLiveDetailNight)
    }
    private func layout() {
        weatherView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        weatherImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(weatherImageView.snp.width)
        }
        weatherNameLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(weatherImageView)
            make.top.equalTo(weatherImageView.snp.bottom).offset(5)
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(weatherView.snp.right)
            make.bottom.equalToSuperview()
            make.width.equalTo(20)
            make.top.equalToSuperview().offset(20)
        }
        weatherLiveDetailCurrent.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(weatherLiveDetailNight)
        }
        weatherLiveDetailDay.snp.makeConstraints { (make) in
            make.left.equalTo(weatherLiveDetailCurrent.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(weatherLiveDetailCurrent)
        }
        weatherLiveDetailNight.snp.makeConstraints { (make) in
            make.left.equalTo(weatherLiveDetailDay.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
}

extension ULWeatherLiveView {
    
    /// 更新实时天气信息
    ///
    /// - Parameter liveWeather: 实时天气对象
    func updateLiveWeather(_ liveWeather:AMapLocalWeatherLive?) {
        
        guard let liveWeather = liveWeather else {
            return
        }
        weatherNameLab.text = liveWeather.weather
        weatherImageView.image = self.weatherImage(liveWeather.weather)
        weatherLiveDetailCurrent.temperature = "\(liveWeather.temperature!) ℃"
        weatherLiveDetailCurrent.wind = "\(liveWeather.windDirection!) \(liveWeather.windPower!)级"
        weatherLiveDetailCurrent.humidity = liveWeather.humidity
    }
    
    /// 更新当天的实时、白天、晚上天气预报信息
    ///
    /// - Parameter forecastWeathers: 天气预报信息数组(需要筛选出当天的)
    func updateForecastWeather(_ forecastWeathers:[AMapLocalDayWeatherForecast]?) {
        guard let forecastWeathers = forecastWeathers else {
            return
        }
        
        let forecasts = forecastWeathers.filter { (forecast) -> Bool in
            return Date().ul_isSameDay(Date.ul_date(from: forecast.date, dateType: .line, timeType: nil))
        }
        
        guard forecasts.count > 0 else {
            return
        }
        
        let forecast = forecasts.first
        weatherLiveDetailDay.temperature = "\(forecast!.dayTemp!) ℃"
        weatherLiveDetailDay.wind = "\(forecast!.dayWind!) \(forecast!.dayPower!)级"
        weatherLiveDetailDay.humidity = forecast!.dayWeather
        
        weatherLiveDetailNight.temperature = "\(forecast!.nightTemp!) ℃"
        weatherLiveDetailNight.wind = "\(forecast!.nightWind!) \(forecast!.nightPower!)级"
        weatherLiveDetailNight.humidity = forecast!.nightWeather
    }
    
    /// 根据天气气象获取对应的图片
    ///
    /// - Parameter weatherName: 气象名称
    /// - Returns: 对应的图片
    fileprivate func weatherImage(_ weatherName:String) -> UIImage? {
        var imageName = ""
        if weatherName == "中雨" ||
            weatherName == "大雨" ||
            weatherName == "暴雨" ||
            weatherName == "大暴雨" ||
            weatherName == "特大暴雨" ||
            weatherName == "小雨-中雨" ||
            weatherName == "中雨-大雨" ||
            weatherName == "大雨-暴雨" ||
            weatherName == "暴雨-大暴雨" ||
            weatherName == "大暴雨-特大暴雨" {
            imageName = "ul_weather_rain_level2"
        } else if weatherName == "晴" {
            imageName = "ul_weather_clear"
        } else if weatherName == "多云" || weatherName == "阴" {
            imageName = "ul_weather_cloudy"
        } else if weatherName == "阵雨" || weatherName == "小雨" {
            imageName = "ul_weather_rain_level1"
        } else if weatherName == "雷阵雨" || weatherName == "雷阵雨并伴有冰雹" {
            imageName = "ul_weather_thundershower"
        } else if weatherName == "雨夹雪" {
            imageName = "ul_weather_rainsnow"
        } else if weatherName == "小雪" ||
            weatherName == "阵雪" ||
            weatherName == "中雪" ||
            weatherName == "大雪" ||
            weatherName == "暴雪" ||
            weatherName == "小雪-中雪" ||
            weatherName == "中雪-大雪" ||
            weatherName == "大雪-暴雪" ||
            weatherName == "弱高吹雪" {
            imageName = "ul_weather_snow"
        }else if weatherName == "沙尘暴" ||
            weatherName == "浮尘" ||
            weatherName == "扬沙" ||
            weatherName == "强沙尘暴" ||
            weatherName == "飑" ||
            weatherName == "轻霾" ||
            weatherName == "霾" {
            imageName = "ul_weather_sandstorm"
        }else if weatherName == "雾" {
            imageName = "ul_weather_fog"
        }else if weatherName == "冻雨" {
            imageName = "ul_weather_icerain"
        }else if weatherName == "龙卷风" {
            imageName = "ul_weather_tornado"
        }
        return UIImage.init(named: imageName)
    }
}

class ULWeatherLiveDetailView : UIView {
    
    private let titleLab : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let temperatureLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    private let windLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    private let humidityLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    fileprivate var title : String? {
        set {
            self.titleLab.text = newValue
        }
        get {
            return self.title
        }
    }
    
    fileprivate var temperature : String? {
        set {
            self.temperatureLabel.text = newValue
        }
        get {
            return self.temperature
        }
    }
    
    fileprivate var wind : String? {
        set {
            self.windLabel.text = newValue
        }
        get {
            return self.wind
        }
    }
    
    fileprivate var humidity : String? {
        set {
            self.humidityLabel.text = newValue
        }
        get {
            return self.humidity
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.addSubview(titleLab)
        self.addSubview(temperatureLabel)
        self.addSubview(windLabel)
        self.addSubview(humidityLabel)
    }
    //MARK: - Layout
    private func layout() {
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(20)
        }
        temperatureLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
            make.height.equalTo(humidityLabel)
        }
        windLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom)
            make.height.equalTo(temperatureLabel)
        }
        humidityLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(windLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
