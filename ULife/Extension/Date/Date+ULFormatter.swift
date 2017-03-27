//
//  Date+ULFormatter.swift
//  ULife
//
//  Created by codeLocker on 2017/3/27.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation

enum ULDateFormatterType : String {
    case line = "yyyy-MM-dd"
    case slash = "yyyy/MM/dd"
    case chinese = "yyyy年MM月dd日"
    case blank = "yyyy MM dd"
}

enum ULTimeFormatterType : String {
    case colon = "HH:mm:ss"
    case chinese = "HH时mm分ss秒"
    case blank = "HH mm ss"
}

extension Date {
    
    /// 获取字符串格式日期
    ///
    /// - Parameter type: formatter类型
    /// - Returns: 字符串格式日期
    func ul_dateString(type:ULDateFormatterType) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
    
    /// 获取字符串格式日期
    ///
    /// - Parameter formatter: formatter字符串
    /// - Returns: 获取字符串格式日期
    func ul_dateString(formatter:String?) -> String {
        
        if formatter == nil || formatter!.isEmpty {
            return self.ul_dateString(type: .line)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: self)
    }
    
    /// 获取字符串格式时间
    ///
    /// - Parameter type: formatter类型
    /// - Returns: 字符串格式时间
    func ul_timeString(type:ULTimeFormatterType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
    
    /// 获取字符串格式时间
    ///
    /// - Parameter formatter: formatter字符串
    /// - Returns: 字符串格式时间
    func ul_timeString(formatter:String?) -> String {
        if formatter == nil || formatter!.isEmpty {
            return self.ul_timeString(type: .colon)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: self)
    }
    
    /// 通过字符串格式获取Date格式时间
    ///
    /// - Parameters:
    ///   - dateString: 字符串时间
    ///   - dateType: 日期formatter
    ///   - timeType: 时间formatter
    /// - Returns: Date?
    static func ul_date(from dateString:String?, dateType:ULDateFormatterType?, timeType:ULTimeFormatterType?) -> Date? {
        
        guard let dateString = dateString else {
            return nil
        }
        
        var dateType = dateType
        var timeType = timeType
        
        if dateType == nil {
            dateType = .line
        }
        if timeType == nil {
            timeType = .colon
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "\(dateType!.rawValue) \(timeType!.rawValue)"
        return dateFormatter.date(from: dateString)
    }
    
    /// 通过字符串格式获取Date格式时间
    ///
    /// - Parameters:
    ///   - dateString: 字符串时间
    ///   - formatter: 日期时间formatter
    /// - Returns: Date?
    static func ul_date(from dateString:String?, formatter:String?) -> Date? {
    
        guard let dateString = dateString else {
            return nil
        }
        guard let formatter = formatter else {
            return Date.ul_date(from: dateString, dateType: nil, timeType: nil)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.date(from: dateString)
    }
}
