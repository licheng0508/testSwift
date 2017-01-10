//
//  StatusModel.swift
//  testSwift
//
//  Created by licheng on 2016/12/28.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class StatusModel: NSObject {

    /// 微博创建时间
    var created_at: String?
    
    /// 字符串型的微博ID
    var idstr: String?
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
    /// 微博作者的用户信息
    var user: UserModel?
    
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?
    
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeys(dict)
    }
    
    /// KVC的setValuesForKeysWithDictionary方法内部会调用setValue方法
    override func setValue(_ value: Any?, forKey key: String) {
//        LLPrint("key = \(key), value = \(value)")
        // 1.拦截user赋值操作
        if key == "user"
        {
            user = UserModel(dict: value as! [String: AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["created_at", "idstr", "text", "source"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }

}
