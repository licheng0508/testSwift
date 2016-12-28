//
//  String+Extension.swift
//  testSwift
//
//  Created by licheng on 2016/11/16.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

extension String
{
    /// 快速生成缓存路径
    func cachesDir() -> String
    {
        // 1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    /// 快速生成文档路径
    func docDir() -> String
    {
        // 1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    /// 快速生成临时路径
    func tmpDir() -> String
    {
        // 1.获取缓存目录的路径
        let path = NSTemporaryDirectory()
        
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
}
