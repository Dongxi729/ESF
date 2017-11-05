//
//  ShoppingViewController.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/12/2.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  购物车界面

import UIKit
import WebKit


class ShoppingViewController : WKBaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //若导航栏的子页面数量大于1，则设置第一面的导航栏颜色为白色，其他为橘色
        if (self.navigationController?.viewControllers.count)! > 1 {
            
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            
            UIApplication.shared.statusBarStyle = .default
            
        } else {
            
            ///状态栏背景色
            self.navigationController?.navigationBar.barTintColor = commonBtnColor
            
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        if let nav = navigationController?.viewControllers.count {
            CCog(message: nav)
            if nav == 1 {
                if NetStatusModel.netStatus == 0 {
                    self.webView.load(URLRequest.init(url: URL.init(string: commaddURl(adUrl: shooppingCarURL))!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0))
                } else {
                    self.webView.load(URLRequest.init(url: URL.init(string: commaddURl(adUrl: shooppingCarURL))!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0))
                }
            }
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let nav = navigationController?.viewControllers.count {
            
            if nav > 1 {
                if NetStatusModel.netStatus == 0 {
                    self.webView.load(URLRequest.init(url: URL.init(string: self.url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0))
                } else {
                    self.webView.load(URLRequest.init(url: URL.init(string: self.url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0))
                }
            }
        }
        
//        loadFirst(loadURl: self.url, firstUrl: shooppingCarURL)

    }
}
