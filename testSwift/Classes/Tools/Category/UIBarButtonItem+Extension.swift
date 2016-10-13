//
//  UIBarButtonItem+Extension.swift
//  testSwift
//
//  Created by licheng on 2016/10/13.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    /**
     创建item
     - parameter imageName: item显示图片
     - parameter target:    谁来监听
     - parameter action:    监听到之后执行的方法
     */
    convenience init(imageName: String, target: AnyObject?, action: Selector) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        btn .addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        btn.sizeToFit()
        self.init(customView: btn)
    }
}
