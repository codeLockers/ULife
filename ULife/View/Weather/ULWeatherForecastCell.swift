//
//  ULWeatherForecastCell.swift
//  ULife
//
//  Created by codeLocker on 2017/3/28.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWeatherForecastCell: UITableViewCell {

    fileprivate let dateLab : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    fileprivate let temperatureLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    fileprivate let weatherImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let weatherLab : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(dateLab)
        self.contentView.addSubview(temperatureLabel)
        self.contentView.addSubview(weatherImageView)
        self.contentView.addSubview(weatherLab)
    }
    
    private func layout() {
        dateLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        temperatureLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        weatherImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(100)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        weatherLab.snp.makeConstraints { (make) in
            make.left.equalTo(weatherImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}

extension ULWeatherForecastCell {
    
    func setUpCell(forecastWeather:AMapLocalDayWeatherForecast?) {
        guard let forecastWeather = forecastWeather else {
            return
        }
        let date = Date.ul_date(from: forecastWeather.date, dateType: .line, timeType: nil)
        self.dateLab.text = date?.ul_dateString(formatter: "MM/dd")
        
        self.temperatureLabel.text = "\(forecastWeather.dayTemp!)~\(forecastWeather.nightTemp!)℃"
        self.weatherImageView.image = ULWeatherLiveView.weatherImage(forecastWeather.dayWeather)
        self.weatherLab.text = forecastWeather.dayWeather
    }
}
