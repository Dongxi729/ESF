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
        
        XFLog(message: UIScreen.main.bounds.height)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        view.bringSubview(toFront: (self.navigationController?.navigationBar)!)
        
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

            self.navigationController?.navigationBar.isHidden = true
            
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
        
        if (self.navigationController?.childViewControllers.count)! > 1 {
            
            DispatchQueue.main.async {
                
                
                //判断是否包含域名
                if self.url.contains(comStrURL) {
                    
                    
                    DispatchQueue.main.async {
                        
                        self.compassView.frame = CGRect.init(x: 0, y: 0, width: SW, height: 64)
                        
                        self.urlRequestCache = NSURLRequest.init(url: URL.init(string: self.url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 0)
                        
                        self.webView.load(self.urlRequestCache as URLRequest)
                    }
                    
                } 
            }
            
        } else {
            
            
            let urlStr = "http://\(comStrURL)/app/index.aspx?devtype=1" + "&token=" + self.token
            
            self.url = urlStr
            
            self.compassView.frame = CGRect.init(x: 0, y: 0, width: SW, height: 64)
            
            self.urlRequestCache = NSURLRequest.init(url: URL.init(string: urlStr)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
            
            self.webView.load(self.urlRequestCache as URLRequest)
        }
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
       
        
        if navigationAction.navigationType == WKNavigationType.linkActivated || self.url.contains("product_list.aspx") || self.url.contains("&tp=buynow") {
            
            if self.url.contains("?") {
                self.url = self.url + ("&devtype=1&token=") + (token)
            } else {
                self.url = self.url + ("?devtype=1&token=") + (token)
            }
            
            //判断是否包含相同的url
            if mainIndexArray.count > 0 && (mainIndexArray.lastObject as! String) == self.url {
                
                
                self.webView.reload()
                decisionHandler(.allow)
                
                mainIndexArray.removeLastObject()
                return
            }
            
            mainIndexArray.add(self.url)
            self.aaa(str:self.url)
            
            decisionHandler(.cancel)
            
            
        } else {
            
            
            decisionHandler(.allow)
        }
        
    }
    
    
    /// 页面跳转
    ///
    /// - Parameter str: 跳转的链接
    func aaa(str : String) -> Void {
        
        let vvv = MainPageViewReplaceVIew()
        vvv.url = str
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
}
