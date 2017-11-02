//
//  ShoppingReplaceView.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/12/7.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  购物车替换界面

import UIKit

import WebKit

class ShoppingReplaceView: WKBaseViewController {
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //加载URL
        let urlStr = shoppingCarArray.lastObject
        self.url = urlStr as! String
        
        //XFLog(message: urlStr)
        
        let url = URL.init(string: urlStr as! String)
        DispatchQueue.main.async {
            
            self.urlRequestCache = NSURLRequest.init(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 0)
            self.webView.load(self.urlRequestCache as URLRequest)
            
        }
    }
    
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
        
        XFLog(message: url)
        
        if navigationAction.navigationType == WKNavigationType.linkActivated || self.url.contains("product_list.aspx") {
            
            
            
            if self.url.contains("?") {
                self.url = self.url + ("&devtype=1&token=") + (token)
            } else {
                self.url = self.url + ("?devtype=1&token=") + (token)
            }
            
            //判断是否包含相同的url
            if shoppingCarArray.count > 0 && (shoppingCarArray.lastObject as! String) == self.url {
                
                self.webView.reload()
                decisionHandler(.allow)
                
                separateArrey.removeLastObject()
                return
            }
            
            shoppingCarArray.add(url)
            
            aaa(str: self.url)

            
            decisionHandler(.cancel)
            
            
        } else {
            
            if self.url.contains("order_pay") && !self.url.contains("devtype") {
                
                if self.url.contains("?") {
                    self.url = self.url + ("&devtype=1&token=") + (token)
                } else {
                    self.url = self.url + ("?devtype=1&token=") + (token)
                }
                
                if shoppingCarArray.count > 0 && (shoppingCarArray.lastObject as! String) == self.url {
                    self.webView.reload()
                    decisionHandler(.allow)
                    
                    self.view.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.view.isUserInteractionEnabled = true
                    })
                    
                    shoppingCarArray.removeLastObject()
                    return
                }
                
                shoppingCarArray.add(url)
                
                bbb(str: self.url)
                
                decisionHandler(.cancel)
                
            }
            
            decisionHandler(.allow)
            
        }
        
    }
    
    //url---
    func aaa(str : String) -> Void {
        
        let vvv = ShoppingViewController()
        vvv.url = str
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
        
    }
    
    //url---
    func bbb(str : String) -> Void {
        
        let vvv = RepplaceVC()
        vvv.url = str
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
        
    }
    
}
