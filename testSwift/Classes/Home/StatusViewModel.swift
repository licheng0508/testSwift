//
//  StatusViewModel.swift
//  testSwift
//
//  Created by licheng on 2016/12/29.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

/*
 M: 模型(保存数据)
 V: 视图(展现数据)
 C: 控制器(管理模型和视图, 桥梁)
 VM:
 作用: 1.可以对M和V进行瘦身
 2.处理业务逻辑
 */
class StatusViewModel: NSObject {

    ///模型对象
    var status: StatusModel
    
    init(status: StatusModel)
    {
        self.status = status
        
        //处理头像
        icon_URL = NSURL(string: status.user?.profile_image_url ?? "")
        
        //处理认证图片
        switch status.user?.verified_type ?? -1
        {
        case 0:
            verified_image = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verified_image = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verified_image = UIImage(named: "avatar_grassroot")
        default:
            verified_image = nil
        }
        
        // 处理会员图标
        if (status.user?.mbrank)! >= 1 && (status.user?.mbrank)! <= 6
        {
            mbrankImage = UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        
        //处理时间
        if let timeStr = status.created_at, timeStr != ""
        {
            //将服务器返回的时间格式化为NSDate
            let creatDate = NSDate.createDate(timeStr: timeStr, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
            
            //生成发布微博时间对应的字符串
            created_Time = creatDate.descriptionStr()
        }
        
        //处理来源
        if let sourceStr : NSString = status.source as NSString?, sourceStr != ""
        {
            //获取截取字符串位置
            let startIndex = sourceStr.range(of: ">").location + 1
            //获取要截取字符串的长度
            let length = sourceStr.range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
            //截取字符串
            let rest = sourceStr.substring(with: NSMakeRange(startIndex, length))
            
            source_Text = "来自" + rest
        }
        
        //处理配图URL
        // 1.从模型中取出配图数组
        if let picurls = status.pic_urls
        {
            thumbnail_pic = [NSURL]()
            // 2.遍历配图数组下载图片
            for dict in picurls {
                // 2.1取出图片的URL字符串
                guard let urlStr = dict["thumbnail_pic"] as? String
                    else
                {
                    continue
                }
                // 2.2根据字符串创建URL
                let url = NSURL(string: urlStr)!
                thumbnail_pic?.append(url)
                
            }
        }

    }
    
    /// 用户认证图片
    var verified_image: UIImage?
    
    /// 会员图片
    var mbrankImage: UIImage?
    
    /// 用户头像URL地址
    var icon_URL: NSURL?
    
    /// 微博格式化之后的创建时间
    var created_Time: String = ""
    
    /// 微博格式化之后的来源
    var source_Text: String = ""
    
    /// 保存所有配图URL
    var thumbnail_pic: [NSURL]?
    
    /// 保存所有配图Image
    var thumbnail_pic_image: [UIImage]?
}
