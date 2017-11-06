//
//  YHJMainVC.swift
//  Alili
//
//  Created by 郑东喜 on 2017/10/25.
//  Copyright © 2017年 郑东喜. All rights reserved.
//  优惠券

import UIKit
import WebKit

class YHJMainVC: WKBaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController?.viewControllers.count)! > 0 {
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: UIColor.black]
            
            UIApplication.shared.statusBarStyle = .default
            
        } else {
            
            self.navigationController?.navigationBar.barTintColor = commonBtnColor
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        token = localSave.object(forKey: userToken) as? String ?? ""
        
        navigationItem.rightBarButtonItem = self.yhjRightBarItem
        
        if let nav = navigationController?.viewControllers.count {
            CCog(message: nav)
            if nav == 2 {
                var aaa = ""
                if coupon_URl.contains("?") {
                    aaa = coupon_URl + ("&devtype=1&token=") + (token)
                } else {
                    aaa = coupon_URl + ("?devtype=1&token=") + (token)
                }
                CCog(message: aaa)
                
                if NetStatusModel.netStatus == 0 {
                    CCog()
                    self.webView.load(URLRequest.init(url: URL.init(string: aaa)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0))
                } else {
                    CCog()
                    self.webView.load(URLRequest.init(url: URL.init(string: aaa)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0))
                }
            } else {
                if NetStatusModel.netStatus == 0 {
                    self.webView.load(URLRequest.init(url: URL.init(string: self.url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0))
                } else {
                    self.webView.load(URLRequest.init(url: URL.init(string: self.url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0))
                }
            }
        }

    }
    
    lazy var yhjRightBarItem: UIBarButtonItem = {
        let d : UIBarButtonItem = UIBarButtonItem.init(title: "兑换优惠券", style: .plain, target: self, action: #selector(exhcangeYHJ))
        d.tintColor =  UIColor.black
        return d
    }()
    
    @objc private func exhcangeYHJ() {
        navigationController?.pushViewController(MyExchangeVC(), animated: true)
    }
    
    
}

