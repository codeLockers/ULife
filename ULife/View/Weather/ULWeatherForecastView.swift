//
//  ULWeatherForecastView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/28.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULWeatherForecastView: UIView {

    fileprivate let tableView = UITableView()
    fileprivate var forecasts : [AMapLocalDayWeatherForecast]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: load_UI
    private func loadUI() {
    
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.register(ULWeatherForecastCell.self, forCellReuseIdentifier: String(describing: ULWeatherForecastCell.self))
        self.addSubview(tableView)
    }
    
    private func layout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ULWeatherForecastView {
    
    /// 更新当天的实时、白天、晚上天气预报信息
    ///
    /// - Parameter forecastWeathers: 天气预报信息数组(需要筛选出当天的)
    func updateForecastWeather(_ forecastWeathers:[AMapLocalDayWeatherForecast]?) {
        guard let forecastWeathers = forecastWeathers else {
            return
        }
        
        let forecasts = forecastWeathers.filter { (forecast) -> Bool in
            return !Date().ul_isSameDay(Date.ul_date(from: forecast.date, dateType: .line, timeType: nil))
        }

        guard forecasts.count > 0 else {
            return
        }
        
        self.forecasts = forecasts
        
        tableView.reloadData()
    }
}

extension ULWeatherForecastView : UITableViewDelegate ,  UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecasts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ULWeatherForecastCell.self)) as? ULWeatherForecastCell
        cell?.setUpCell(forecastWeather: self.forecasts?[indexPath.row])
        return cell!
    }
}
