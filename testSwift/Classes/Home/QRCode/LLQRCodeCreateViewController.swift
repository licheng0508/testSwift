//
//  LLQRCodeCreateViewController.swift
//  testSwift
//
//  Created by licheng on 2016/10/21.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class LLQRCodeCreateViewController: UIViewController {

    /// 二维码容器
    @IBOutlet weak var customImageVivew: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        creatQRCode()
    }
    
    // MARK: - 生成二维码
    private func creatQRCode(){
    
        //1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //2.还原滤镜默认属性
        filter?.setDefaults()
        // 3.设置需要生成二维码的数据到滤镜中
        // OC中要求设置的是一个二进制数据
        filter?.setValue("李城".data(using: String.Encoding.utf8), forKey: "InputMessage")
        //4.从滤镜中取出生成好的二维码图片
        guard let ciImage = filter?.outputImage else {
            return
        }
        customImageVivew.image = UIImage(ciImage: ciImage)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
