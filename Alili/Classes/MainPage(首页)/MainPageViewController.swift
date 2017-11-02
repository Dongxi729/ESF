//
//  MainPageViewController.swift
//  DollarBuy
//
//  Created by 郑东喜 on 2016/11/6.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  首页轮播图

import UIKit
import WebKit


class MainPageViewController : WKBaseViewController {
    
   
    //设置导航栏样式
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nav = navigationController?.viewControllers.count {
            if nav > 1 {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            } else {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
        //若导航栏的子页面数量大于1，则设置第一面的导航栏颜色为白色，其他为橘色
        if (self.navigationController?.viewControllers.count)! > 1 {
            
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            
            UIApplication.shared.statusBarStyle = .default
            
        } else {
            if UIScreen.main.bounds.height == 812 {
                
                compassView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SW, height: 44))
            } else {
                compassView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SW, height: 20))
            }
            
            compassView.backgroundColor = commonBtnColor
            
            if self.webView != nil {
            
                self.webView.frame = CGRect.init(x: 0, y: 20, width: SW, height: SH - 64)
            }

            ///状态栏背景色
            self.navigationController?.navigationBar.barTintColor = commonBtnColor
            
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFirst(loadURl: self.url, firstUrl: firPage_URL)
    }
    
}
