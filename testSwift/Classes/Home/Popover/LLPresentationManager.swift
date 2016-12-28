//
//  LLPresentationManager.swift
//  testSwift
//
//  Created by licheng on 2016/10/17.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class LLPresentationManager: NSObject ,UIViewControllerTransitioningDelegate ,UIViewControllerAnimatedTransitioning
{
    /// 定义标记记录当前是否是展现
    private var isPresent = false
    
    /// 保存菜单的尺寸
    var presentFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    
    // MARK: - UIViewControllerTransitioningDelegate
    // 该方法用于返回一个负责转场动画的对象
    // 可以在该对象中控制弹出视图的尺寸等
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = LLPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame =  presentFrame
        return pc
    }
    
    // 该方法用于返回一个负责转场如何出现的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        // 发送一个通知, 告诉调用者状态发生了改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LLPresentationManagerDidPresented), object: self)
        return self
    }
    
    // 该方法用于返回一个负责转场如何消失的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        // 发送一个通知, 告诉调用者状态发生了改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LLPresentationManagerDidDismissed), object: self)
        return self
    }

    // MARK: - UIPresentationController
    // 告诉系统展现和消失的动画时长
    // 暂时用不上
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.25
    }
    
    // 专门用于管理modal如何展现和消失的, 无论是展现还是消失都会调用该方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        // 0.判断当前是展现还是消失
        if isPresent
        {
            // 展现
            willPresentedController(transitionContext: transitionContext)
            
        }else
        {
            // 消失
            willDismissedController(transitionContext: transitionContext)
        }
    }
    
    /// 执行展现动画
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning)
    {
        // 1.获取需要弹出视图
        // 通过ToViewKey取出的就是toVC对应的view
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else
        {
            return
        }
        
        // 2.将需要弹出的视图添加到containerView上
        transitionContext.containerView.addSubview(toView)
        
        // 3.执行动画
        toView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        // 设置锚点
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
//            toView.transform = CGAffineTransformIdentity
            toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) -> Void in
            // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
            transitionContext.completeTransition(true)
        }
    }
    /// 执行消失动画
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning)
    {
        // 1.拿到需要消失的视图
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else
        {
            return
        }
        // 2.执行动画让视图消失
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            // 突然消失的原因: CGFloat不准确, 导致无法执行动画, 遇到这样的问题只需要将CGFloat的值设置为一个很小的值即可
            fromView.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
            }, completion: { (_) -> Void in
                // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
                transitionContext.completeTransition(true)
        })
    }

}
