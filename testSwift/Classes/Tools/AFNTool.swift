//
//  AFNTool.swift
//  testSwift
//
//  Created by licheng on 2016/11/8.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class AFNTool: AFHTTPSessionManager {

    //Swift单例
    static let shareInstance : AFNTool = {
    
        // 注意: baseURL后面一定更要写上./
        let baseURL = NSURL(string: "https://api.weibo.com/")!
        
        let instance = AFNTool(baseURL: baseURL as URL, sessionConfiguration: URLSessionConfiguration.default)
        
        instance.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as? Set
        
        return instance
        
    }()
    
    //Mark: - 外部控制方法
    func loadStatuses(finished: @escaping (_ array: [[String: AnyObject]]?, _ error: NSError?)->()){
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        //1.准备路径
        let path = "2/statuses/home_timeline.json"
        
        //2.准备参数
        let parameters = ["access_token": UserAccount.loadUserAccount()?.access_token!]
        //3.发送GET请求
        get(path, parameters: parameters, progress: { (progress) in
            
        }, success: { (task : URLSessionDataTask, objc : Any?) in
    
            guard let arr = (objc as! [String: AnyObject])["statuses"] as? [[String: AnyObject]]
                else
            {
                finished(nil, NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["message": "没有获取到数据"]))
                return
            }
            
            finished(arr, nil)
            
        }) { (task : URLSessionDataTask?, error : Error) in
            
            finished(nil, error as NSError?)
        }
    }
    
}
