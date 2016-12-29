//
//  NSDate+Extension.swift
//  testSwift
//
//  Created by licheng on 2016/12/29.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

extension NSDate
{

    /// 根据一个字符串创建一个NSDate
    class func createDate(timeStr: String, formatterStr: String) -> NSDate
    {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        //如果不指定以下代码, 在真机中可能无法转换(地区)
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        return formatter.date(from: timeStr)! as NSDate
    }
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    
    /// 生成当前时间对应的字符串
    func descriptionStr() -> String
    {
        //创建时间格式化对象
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        
        //创建一个日历类
        let calendar = Calendar.current
        
        // 3.定义变量记录时间格式
        var formatterStr = "HH:mm"
        
        if calendar.isDateInToday(self as Date)
        {
            //今天 比较两个时间之间的差值
            let interval = Int(NSDate().timeIntervalSince(self as Date))
            
            if interval < 60
            {
                return "刚刚"
            }else if interval < 60 * 60
            {
                return "\(interval / 60)分钟前"
            }else if interval < 60 * 60 * 24
            {
                return "\(interval / (60 * 60))小时前"
            }
        }else if calendar.isDateInYesterday(self as Date)
        {
            //昨天
            formatterStr = "昨天 " + formatterStr
        }else
        {
            // 该方法可以获取两个时间之间的差值
            let comps = calendar.dateComponents([.year], from: self as Date, to: NSDate() as Date)
            if comps.year! >= 1
            {
                //更早时间
                formatterStr = "yyyy-MM-dd " + formatterStr
            }else
            {
                //一年以内
                formatterStr = "MM-dd " + formatterStr
            }
        }
        formatter.dateFormat = formatterStr
        return formatter.string(from: self as Date)
    }
    
}
