//
//  LLHomeTableViewController.swift
//  testSwift
//
//  Created by licheng on 2016/10/9.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class LLHomeTableViewController: UITableViewController {

    ///保存微博数据
    var statuses : [StatusViewModel]?
        {
        didSet{
            tableView.reloadData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.初始化导航栏按钮
        setupNavgationItem()
        
        // 2.注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(LLHomeTableViewController.titleChange), name: NSNotification.Name(rawValue: LLPresentationManagerDidPresented), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector: #selector(LLHomeTableViewController.titleChange), name: NSNotification.Name(rawValue: LLPresentationManagerDidDismissed), object: animatorManager)
        
        //3.注册cell
        let cellNib = UINib(nibName: "LLHomeCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LLHomeCell")
        
        //预计行高
        tableView.estimatedRowHeight = 400
        //自动计算行高
//        tableView.rowHeight = UITableViewAutomaticDimension
        //隐藏分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // 4.获取微博数据
        loadData()
        
        print("test")
    }
    deinit
    {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - 内部控制方法
    private func loadData()
    {
        AFNTool.shareInstance.loadStatuses { (array, error) -> () in
            // 1.安全校验
            if error != nil
            {
                LLPrint("获取微博数据失败")
                return
            }
            guard let arr = array else
            {
                return
            }
            // 2.将字典数组转换为模型数组
            var models = [StatusViewModel]()
            for dict in arr
            {
                let statusViewModel = StatusViewModel(status: StatusModel(dict: dict))
                models.append(statusViewModel)
            }
            // 3.保存微博数据
//            self.statuses = models
            
            //4.缓存微博所有配图
            self.cachesImages(viewModels: models)
            
        }
    }
    
    ///缓存微博所有配图
    private func cachesImages(viewModels: [StatusViewModel])
    {
        //0.创建一个组
        let group = DispatchGroup()
        
        for viewModel in viewModels
        {
            // 1.从模型中取出配图数组
            guard let picurls = viewModel.thumbnail_pic
                else
            {
                // 如果当前微博没有配图就跳过, 继续下载下一个模型的
                continue
            }
            // 2.遍历配图数组下载图片
            for url in picurls
            {
                // 将当前的下载操作添加到组中
                group.enter()
                
                // 3.利用SDWebImage下载图片
                SDWebImageDownloader.shared().downloadImage(with: url as URL, options: SDWebImageDownloaderOptions.init(rawValue: 0), progress: nil, completed: { (image, _, error, finished) in
                    group.leave()
                })
            }
        }
        
        // 监听下载操作
        group.notify(queue: DispatchQueue.main, execute: {
            self.statuses = viewModels
        })
    }

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
        //1.创建二维码控制器
        let sb = UIStoryboard(name: "LLQRCode", bundle: nil)
        guard let vc = sb.instantiateInitialViewController() else
        {
            return
        }
        //弹出二维码控制器
        present(vc, animated: true, completion: nil)
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
        btn.setTitle(UserAccount.loadUserAccount()?.screen_name, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(LLHomeTableViewController.titleBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    /// 缓存行高
    var rowHeightCaches =  [String: CGFloat]()
}

extension LLHomeTableViewController
{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.取出Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "LLHomeCell", for: indexPath) as! LLHomeCell
        
        //2.设置数据
        cell.viewModel = statuses![indexPath.row]
        
        //2.返回cell
        return cell
    }
    
    //返回行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = statuses![indexPath.row]
        // 1.从缓存中获取行高
        guard let height = rowHeightCaches[viewModel.status.idstr ?? "-1"] else
        {
            // 缓存中没有行高
            // 2.计算行高
            // 2.1获取当前行对应的cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "LLHomeCell") as! LLHomeCell
            
            // 2.1缓存行高
            let  temp = cell.calculateRowHeight(viewModel: viewModel)
            
            rowHeightCaches[viewModel.status.idstr ?? "-1"] = temp
            
            // 3.返回行高
            return temp
        }
        // 缓存中有就直接返回缓存中的高度
        return height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 释放缓存数据
        rowHeightCaches.removeAll()
    }
    
}

