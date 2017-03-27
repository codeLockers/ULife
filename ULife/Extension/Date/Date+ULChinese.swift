//
//  Date+ULChinese.swift
//  ULife
//
//  Created by codeLocker on 2017/3/27.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation
//60年一个甲子
let ul_chineseYears = ["甲子","乙丑","丙寅","丁卯","戊辰","己巳","庚午","辛未","壬申","癸酉","甲戌","乙亥","丙子","丁丑","戊寅","己卯","庚辰","辛己","壬午","癸未","甲申","乙酉","丙戌","丁亥","戊子","己丑","庚寅","辛卯","壬辰","癸巳","甲午","乙未","丙申","丁酉","戊戌","己亥","庚子","辛丑","壬寅","癸丑","甲辰","乙巳","丙午","丁未","戊申","己酉","庚戌","辛亥","壬子","癸丑","甲寅","乙卯","丙辰","丁巳","戊午","己未","庚申","辛酉","壬戌","癸亥"]
//农历的12个月份
let ul_chineseMonths = ["正月","二月","三月","四月","五月","六月","七月","八月","九月","十月","冬月","腊月"]
//农历
let ul_chinestDays = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"]
//农历节日
let ul_chineseFestivals = [1:[1:"春节",5:"破五节",7:"七草节",15:"元宵节"],
                           2:[2:"龙抬头节"],
                           3:[3:"上巳节"],
                           5:[5:"端午节"],
                           7:[7:"七夕节",15:"中元节"],
                           8:[7:"孔子诞辰",15:"中秋节"],
                           9:[9:"重阳节",15:"下元节"],
                           10:[1:"寒衣节"],
                           12:[8:"腊八节",23:"小年"]
]
let ul_internationalFestivals = [1:[1:"元旦"],
                                 2:[14:"情人节"],
                                 3:[8:"妇女节",12:"植树节",15:"消费者权益保护日"],
                                 4:[1:"愚人节"],
                                 5:[1:"劳动节",4:"青年节"],
                                 6:[1:"儿童节"],
                                 7:[1:"党的生日|香港回归纪念日",7:"抗日战争纪念日"],
                                 8:[1:"建军纪念日"],
                                 9:[3:"抗日战争胜利纪念日 ",10:"教师节",18:"九·一八事变纪念日"],
                                 10:[1:"国庆节",10:"辛亥革命纪念日"],
                                 12:[1:"世界艾滋病日",12:"西安事变纪念日",13:"南京大屠杀纪念日",20:"澳门回归纪念日",25:"圣诞节"]
]

extension Date {
    
    /// 获取农历日期
    ///
    /// - Returns: 年月日
    func ul_chineseDate() -> (year:String?,month:String?,day:String?) {
        let chineseCalendar = Calendar.init(identifier: .chinese)
        let dateComponent = chineseCalendar.dateComponents([.year,.month,.day], from: self)
        
        var chineseDate : (year:String?,month:String?,day:String?) = (nil,nil,nil)
        if dateComponent.year != nil && dateComponent.year! >= 0 && dateComponent.year! <= ul_chineseYears.count {
            chineseDate.year = ul_chineseYears[dateComponent.year! - 1]
        }
        if dateComponent.month != nil && dateComponent.month! >= 0 && dateComponent.month! <= ul_chineseMonths.count {
            chineseDate.month = ul_chineseMonths[dateComponent.month! - 1]
        }
        if dateComponent.day != nil && dateComponent.day! >= 0 && dateComponent.day! <= ul_chinestDays.count {
            chineseDate.day = ul_chinestDays[dateComponent.day! - 1]
        }
        return chineseDate
    }
    
    /// 获取农历节日
    ///
    /// - Returns: 节日名
    func ul_chinesrFestival() -> String? {
        let chineseCalendar = Calendar.init(identifier: .chinese)
        let dateComponent = chineseCalendar.dateComponents([.month,.day], from: self)
        
        var festival : String?
        festival = ul_chineseFestivals[dateComponent.month!]?[dateComponent.day!]
        if festival != nil {
            return festival
        }
        //除夕节为春节前一天，将Date后移一天如果是春节的话，则Date为除夕
        let nextDate = Date.init(timeInterval: 60*60*24, since: self)
        let nextDateComponent = chineseCalendar.dateComponents([.month,.day], from: nextDate)
        if nextDateComponent.month == 1 && nextDateComponent.day == 1 {
            return "除夕"
        }
        return nil
    }
    
    /// 获取公历节日
    ///
    /// - Returns: 节日名
    func ul_internationalFestival() -> String? {
        let chineseCalendar = Calendar.init(identifier: .gregorian)
        let dateComponent = chineseCalendar.dateComponents([.month,.day], from: self)
        return ul_chineseFestivals[dateComponent.month!]?[dateComponent.day!]
    }
}
