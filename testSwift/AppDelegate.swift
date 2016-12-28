//
//  AppDelegate.swift
//  testSwift
//
//  Created by licheng on 2016/9/28.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //一般情况下设置全局性的属性, 最好放在AppDelegate中设置, 这样可以保证后续所有的操作都是设置之后的操作
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        
        //注册监听
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.changeRootViewController), name: NSNotification.Name(rawValue: LLSwitchRootViewController), object: nil)
        
        //初始化Window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    deinit{
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {

    /// 切换根控制器
    func changeRootViewController()
    {
        window?.rootViewController = LLMainViewController()
    }
    
    /// 用于返回默认界面
    func defaultViewController() -> UIViewController
    {
        // 1.判断是否登录
        if UserAccount.isLogin()
        {
            return LLMainViewController()
        }
        // 没有登录
        let sb = UIStoryboard(name: "LLUserSign", bundle: nil)
        return sb.instantiateInitialViewController()!
    }

}

/*
 自定义LOG的目的:
 在开发阶段自动显示LOG
 在发布阶段自动屏蔽LOG
 
 print(__FUNCTION__)  // 打印所在的方法
 print(__LINE__)     // 打印所在的行
 print(__FILE__)     // 打印所在文件的路径
 
 方法名称[行数]: 输出内容
 */
func LLPrint<T>(_ message: T, method: String = #function, line: Int = #line)
{
    #if DEBUG
        print("\(method)[\(line)]: \(message)")
    #endif
}

///获取屏幕宽度
func getMainScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}
///获取屏幕高度
func getMainScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}




