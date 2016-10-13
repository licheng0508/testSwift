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
    }

    // MARK: - 内部控制方法
    /// 初始化导航条按钮
    private func setupNavgationItem() {
    
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(LLHomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem =  UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(LLHomeTableViewController.rigthBtnClick))
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
}
