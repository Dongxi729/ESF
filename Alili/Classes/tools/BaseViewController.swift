//
//  BaseViewController.swift
//  Fuck
//
//  Created by 郑东喜 on 2016/12/10.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  UIViewController基类

import UIKit

//代理事件,拦截点击事件
protocol NavDelegate {
    func click() -> Void
}

class BaseViewController: UIViewController,UIGestureRecognizerDelegate,UINavigationBarDelegate {
    
    var delegate : NavDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var rightFooBarButtonItem : UIBarButtonItem?
    
    func checlLogin() {
        
        let alertView = UIAlertController.init(title: "提示", message: "请登录", preferredStyle: .alert)
        alertView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (nil) in
            
            //清除URL保存的值
            mainIndexArray.removeAllObjects()
            fwqArray.removeAllObjects()
            commuArray.removeAllObjects()
            shoppingCarArray.removeAllObjects()
            jiaoYIArray.removeAllObjects()
            zhongjiangArray.removeAllObjects()
            duihuanArray.removeAllObjects()
            fenxiangArray.removeAllObjects()
            separateArrey.removeAllObjects()
            //切换至首页并添加动画
            let tabbarVC = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
            
            tabbarVC.selectedIndex = 0
            
            //转场动画
            Animated.vcWithTransiton(vc: tabbarVC, animatedType: "kCATransitionFade", timeduration: 1.0)
            
        }))
        
        alertView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (nil) in
            
            //设置状态栏颜色
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(LoginView(), animated: true)
            
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            
            
            UIApplication.shared.statusBarStyle = .default
            self.hidesBottomBarWhenPushed = false
            
        }))
        
        //            self.present(alertView, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        let btnn = UIButton()
        btnn.frame = CGRect(x: 15, y: 64, width: 20, height: 20)
        
        btnn.addTarget(self, action:#selector(BaseViewController.fooButtonTapped), for: .touchUpInside)
        
        btnn.setBackgroundImage(UIImage.init(named: "back"), for: .normal)
        btnn.setBackgroundImage(UIImage.init(named: "back"), for: .highlighted)
        
        
        self.rightFooBarButtonItem = UIBarButtonItem.init(customView: btnn)
        
        if self.navigationController == nil {
            self.navigationItem.setLeftBarButton(rightFooBarButtonItem, animated: true)
            return
        }
        
        //当子页面数大于1 时，显示左上角的箭头图标
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationItem.setLeftBarButton(rightFooBarButtonItem, animated: true)
        }
        
        //启用滑动返回（swipe back）
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
    //修复返回失效
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            return (self.navigationController?.viewControllers.count)! > 1
        }
        return true
    }
    
    /**
     //是否允许手势
     func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
     if (gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer) {
     //只有二级以及以下的页面允许手势返回
     return self.navigationController?.viewControllers.count > 1
     }
     return true
     }
     
     */
    @objc func fooButtonTapped(){
        
        self.delegate?.click()
        
        if self.navigationController == nil {
            return
        } else {
            self.navigationController!.popViewController(animated: true)
        }
        
        
    }
    
}

