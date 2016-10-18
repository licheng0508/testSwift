//
//  LLPresentationController.swift
//  testSwift
//
//  Created by licheng on 2016/10/17.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class LLPresentationController: UIPresentationController {

    /// 保存菜单的尺寸
    var presentFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    /*
     1.如果不自定义转场modal出来的控制器会移除原有的控制器
     2.如果自定义转场modal出来的控制器不会移除原有的控制器
     3.如果不自定义转场modal出来的控制器的尺寸和屏幕一样
     4.如果自定义转场modal出来的控制器的尺寸我们可以自己在containerViewWillLayoutSubviews方法中控制
     5.containerView 非常重要, 容器视图, 所有modal出来的视图都是添加到containerView上的
     6.presentedView() 非常重要, 通过该方法能够拿到弹出的视图
     */
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
    }

    // 用于布局转场动画弹出的控件
    override func containerViewWillLayoutSubviews()
    {
        // 设置弹出视图的尺寸
        presentedView?.frame = presentFrame //CGRect(x: 100, y: 45, width: 200, height: 200)
        
        // 添加蒙版
        containerView?.insertSubview(coverButton, at: 0)
        coverButton.addTarget(self, action: #selector(LLPresentationController.coverBtnClick), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: - 内部控制方法
    @objc private func coverBtnClick()
    {
        //        NJLog(presentedViewController)
        //        NJLog(presentingViewController)
        // 让菜单消失
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var coverButton: UIButton = {
        let btn = UIButton()
        btn.frame = UIScreen.main.bounds
        btn.backgroundColor = UIColor.clear
        return btn
    }()

}
