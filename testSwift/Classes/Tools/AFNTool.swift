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
    
}
