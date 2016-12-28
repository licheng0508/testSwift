//
//  LLUserSignViewController.swift
//  testSwift
//
//  Created by licheng on 2016/12/28.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class LLUserSignViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func weiboSignClick() {
        
        let sb = UIStoryboard(name: "LLOAuth", bundle: nil)
        guard let oauthView = sb.instantiateInitialViewController() else
        {
            return
        }
        present(oauthView, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
