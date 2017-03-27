//
//  Date+ULComponent.swift
//  ULife
//
//  Created by codeLocker on 2017/3/27.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation

extension Date {
    
    /// 获取当前的手机系统的日历
    ///
    /// - Returns: 日历
    func ul_currentCalendar() -> Calendar {
        return Calendar.current
    }
    
    /// Date某一个属性上的偏移
    ///
    /// - Parameters:
    ///   - offset: 偏移量
    ///   - component: 属性
    /// - Returns: Date?
    func ul_excursion(_ offset:Int, component:Calendar.Component) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.setValue(offset, for: component)
        return self.ul_currentCalendar().date(byAdding: dateComponent, to: self)
    }
    
    func ul_era() -> Int {
        return self.ul_currentCalendar().component(.era, from: self)
    }
    func ul_year() -> Int {
        return self.ul_currentCalendar().component(.year, from: self)
    }
    func ul_month() -> Int {
        return self.ul_currentCalendar().component(.month, from: self)
    }
    func ul_day() -> Int {
        return self.ul_currentCalendar().component(.day, from: self)
    }
    func ul_hour() -> Int {
        return self.ul_currentCalendar().component(.hour, from: self)
    }
    func ul_minute() -> Int {
        return self.ul_currentCalendar().component(.minute, from: self)
    }
    func ul_second() -> Int {
        return self.ul_currentCalendar().component(.second, from: self)
    }
    func ul_weekday() -> Int {
        return self.ul_currentCalendar().component(.weekday, from: self)
    }
    func ul_weekdayOrdinal() -> Int {
        return self.ul_currentCalendar().component(.weekdayOrdinal, from: self)
    }
    func ul_quarter() -> Int {
        return self.ul_currentCalendar().component(.quarter, from: self)
    }
    func ul_weekOfMonth() -> Int {
        return self.ul_currentCalendar().component(.weekOfMonth, from: self)
    }
    func ul_weekOfYear() -> Int {
        return self.ul_currentCalendar().component(.weekOfYear, from: self)
    }
    func ul_yearForWeekOfYear() -> Int {
        return self.ul_currentCalendar().component(.yearForWeekOfYear, from: self)
    }
    func ul_nanosecond() -> Int {
        return self.ul_currentCalendar().component(.nanosecond, from: self)
    }
    func ul_timeZone() -> Int {
        return self.ul_currentCalendar().component(.timeZone, from: self)
    }
    
    func ul_chineseLongWeekday() -> String {
        let longWeekday = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        return longWeekday[self.ul_weekday() - 1]
    }
    
    func ul_chineseShortWeekday() -> String {
        let longWeekday = ["周日","周一","周二","周三","周四","周五","周六"]
        return longWeekday[self.ul_weekday() - 1]
    }
    
    /// 当前日期所在月份一共有多少天
    ///
    /// - Returns: 天数
    func ul_countOfDayInCurrentMonth() -> Int {
        let range = self.ul_currentCalendar().range(of: .day, in: .month, for: self)
        return range!.upperBound - range!.lowerBound
    }
    
    
}
