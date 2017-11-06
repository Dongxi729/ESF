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
        
        if (navigationController?.viewControllers.count)! > 2 {
            self.webView.load(URLRequest.init(url: URL.init(string: self.url)!))
        } else {
            //加载URL
            self.url = coupon_URl
            
            if self.url.contains("?") {
                self.url = self.url + ("&token=") + (token)
            } else {
                self.url = self.url + ("?token=") + (token)
            }
            
            let url = URL.init(string: self.url)
            
            DispatchQueue.main.async {
                
                self.urlRequestCache = NSURLRequest.init(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 0)
                self.webView.load(self.urlRequestCache as URLRequest)
            }
        }
        
        navigationItem.rightBarButtonItem = self.yhjRightBarItem
    }
    
    lazy var yhjRightBarItem: UIBarButtonItem = {
        let d : UIBarButtonItem = UIBarButtonItem.init(title: "兑换优惠券", style: .plain, target: self, action: #selector(exhcangeYHJ))
        d.tintColor =  UIColor.black
        return d
    }()
    
    @objc private func exhcangeYHJ() {
        navigationController?.pushViewController(MyExchangeVC(), animated: true)
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
        
        XFLog(message: url)
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {

            if self.url.contains("coupon.aspx?state=1") || self.url.contains("coupon.aspx?state=2") || self.url.contains("coupon.aspx") {
                
                if !self.url.contains("token") {
                    if self.url.contains("?") {
                        self.url = self.url + ("&devtype=1&token=") + (token)
                    } else {
                        self.url = self.url + ("?devtype=1&token=") + (token)
                    }
                }
                
                webView.load(URLRequest.init(url: URL.init(string: self.url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0))
            }
            
            if self.url.contains("product_list.aspx?cat=0") || self.url.contains("product_detail.aspx") || self.url.contains("tp=buynow") {
                if !self.url.contains("token") {
                    if self.url.contains("?") {
                        self.url = self.url + ("&devtype=1&token=") + (token)
                    } else {
                        self.url = self.url + ("?devtype=1&token=") + (token)
                    }
                }
                aaa(str: self.url)
            }
            
            decisionHandler(.cancel)
            
        } else {
            if self.url.contains("&tp=buynow") {
                if !self.url.contains("token") {
                    if self.url.contains("?") {
                        self.url = self.url + ("&devtype=1&token=") + (token)
                    } else {
                        self.url = self.url + ("?devtype=1&token=") + (token)
                    }
                    aaa(str: self.url)
                }
            }
            
            decisionHandler(.allow)
        }
    }
    
    /// 页面跳转
    ///
    /// - Parameter str: 跳转的链接
    func aaa(str : String) -> Void {
        
        let vvv = YHJMainVC()
        vvv.url = str
        self.navigationController?.pushViewController(vvv, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

