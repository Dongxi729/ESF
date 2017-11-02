//
//  NineWebView.swift
//  Alili
//
//  Created by 郑东喜 on 2017/1/23.
//  Copyright © 2017年 郑东喜. All rights reserved.
//

import UIKit

import WebKit


class NineWebView: WKBaseViewController {
    //设置导航栏样式
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
        
        if self.url.contains(comStrURL) {
            
            XFLog(message: self.url)
            XFLog(message: comStrURL)
            let url = URL.init(string: self.url)
            
            DispatchQueue.main.async {
                
                self.urlRequestCache = NSURLRequest.init(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
                self.webView.load(self.urlRequestCache as URLRequest)
            }
            
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
        
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            
            if self.url.contains("?") {
                self.url = self.url + ("&devtype=1&token=") + (token)
            } else {
                self.url = self.url + ("?devtype=1&token=") + (token)
            }
            
            //判断是否包含相同的url
            if separateArrey.count > 0 && (separateArrey.lastObject as! String) == self.url {
                MBManager.hideAlert()
                self.webView.reload()
                decisionHandler(.allow)
                
                separateArrey.removeLastObject()
                return
            }
            
            separateArrey.add(self.url)
            
            aaa(str: separateArrey.lastObject as! String)
            
            //XFLog(message: url)
            
            decisionHandler(.cancel)
            
        } else {
            decisionHandler(.allow)
            
        }
        
    }
    
    //url---
    func aaa(str : String) -> Void {
        
        let vvv = NineReplaceView()
        vvv.url = str
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
    }
}
