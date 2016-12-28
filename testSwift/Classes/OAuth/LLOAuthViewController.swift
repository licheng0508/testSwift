//
//  LLOAuthViewController.swift
//  testSwift
//
//  Created by licheng on 2016/11/2.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class LLOAuthViewController: UIViewController {

    ///登录Web
    @IBOutlet weak var customWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.定义字符串保存登录界面URL
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)"
        // 2.创建URL
        guard let url = NSURL(string: urlStr) else
        {
            return
        }
        // 3.创建Request
        let request = NSURLRequest(url: url as URL)
        
        // 4.加载登录界面
        customWebView.loadRequest(request as URLRequest)

    }
    // MARK: - 内部控制方法
    @IBAction func closeBtnClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func autoBtnClick(_ sender: UIBarButtonItem) {
        
        //账号
        let jsUserIdStr = "document.getElementById('userId').value = 'test';"
        customWebView.stringByEvaluatingJavaScript(from: jsUserIdStr)
        
        //密码
        let jsPasswdStr = "document.getElementById('passwd').value = 'test';"
        customWebView.stringByEvaluatingJavaScript(from: jsPasswdStr)
        
    }

}

extension LLOAuthViewController: UIWebViewDelegate {
    
//    func webViewDidStartLoad(_ webView: UIWebView) {
//        // 显示提醒
//        SVProgressHUD.showInfo(withStatus: "正在加载中...")
//        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
//    }
//    
//    private func webViewDidFinishLoad(webView: UIWebView) {
//        // 关闭提醒
//        SVProgressHUD.dismiss()
//    }

    //每次请求都会调用
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
     
        
        // 1.判断当前是否是授权回调页面
        guard let urlStr = request.url?.absoluteString else
        {
            return false
        }
        if !urlStr.hasPrefix(WB_Redirect_uri)
        {
            return true
        }
        
        // 2.判断授权回调地址中是否包含code=
        let key = "code="
        guard let str = request.url!.query else
        {
            return false
        }
        
        if str.hasPrefix(key)
        {
            let code = str.substring(from: key.endIndex)
            loadAccessToken(codeStr: code)
            return false
        }
        return false
    }
    
    /// 利用RequestToken换取AccessToken
    private func loadAccessToken(codeStr: String?)
    {
        guard let code = codeStr else
        {
            return
        }
        // 注意:redirect_uri必须和开发中平台中填写的一模一样
        // 1.准备请求路径
        let path = "oauth2/access_token"
        // 2.准备请求参数
        let parameters = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_Redirect_uri]
        // 3.发送POST请求
        AFNTool.shareInstance.post(path, parameters: parameters, progress: { (gress: Progress) in
//            LLPrint(gress)
        }, success: { (task : URLSessionDataTask, objc : Any?) in
            
            // 1.将授权信息转换为模型
            let account = UserAccount(dict: objc as! [String : AnyObject])
            
            // 2.获取用户信息
            account.loadUserInfo(finished: { (account, error) -> () in
                // 3.保存用户信息
                let isSave = account?.saveAccount()
                LLPrint(isSave)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LLSwitchRootViewController), object: nil)
                
                // 关闭界面
                self.dismiss(animated: true, completion: nil)
            })
            
        }) { (task : URLSessionDataTask?, error : Error) in
            LLPrint(error)
        }
    }
}
