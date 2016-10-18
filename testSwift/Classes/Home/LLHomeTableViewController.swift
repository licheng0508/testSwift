//
//  LLHomeTableViewController.swift
//  testSwift
//
//  Created by licheng on 2016/10/9.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class LLHomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.初始化导航栏按钮
        setupNavgationItem()
        
        // 2.注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(LLHomeTableViewController.titleChange), name: NSNotification.Name(rawValue: LLPresentationManagerDidPresented), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector: #selector(LLHomeTableViewController.titleChange), name: NSNotification.Name(rawValue: LLPresentationManagerDidDismissed), object: animatorManager)
    }
    deinit
    {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - 内部控制方法
    /// 初始化导航条按钮
    private func setupNavgationItem() {
    
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(LLHomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem =  UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(LLHomeTableViewController.rigthBtnClick))
        
        // 2.添加标题按钮
        navigationItem.titleView = titleButton
        
    }
    @objc private func titleChange()
    {
        titleButton.isSelected = !titleButton.isSelected
    }
    /// title按钮点击
    @objc private func titleBtnClick(btn: TitleButton)
    {
//        btn.isSelected = !btn.isSelected
        // 2.显示菜单
        // 2.1创建菜单
        let sb = UIStoryboard(name: "LLPopover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else
        {
            return
        }
        // 自定义专场动画
        // 设置转场动画样式
        menuView.modalPresentationStyle = UIModalPresentationStyle.custom
        // 设置转场代理
        menuView.transitioningDelegate = animatorManager
        
        // 2.2弹出菜单
        present(menuView, animated: true, completion: nil)

    }
    /// 监听左边按钮点击
    @objc private func leftBtnClick()
    {
        LLPrint("leftBtnClick")
    }
    
    /// 监听二维码按钮点击
    @objc private func rigthBtnClick()
    {
        LLPrint("rigthBtnClick")
    }
    
    // MARK: - 懒加载
    private lazy var animatorManager: LLPresentationManager = {
        let manager = LLPresentationManager()
        manager.presentFrame = CGRect(x: (getMainScreenWidth() - 200)*0.5, y: 50, width: 200, height: 200)
        return manager
    }()
    
    /// 标题按钮
    private lazy var titleButton: TitleButton = {
        let btn = TitleButton()
        btn.setTitle("阿狸小妖", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(LLHomeTableViewController.titleBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
}
