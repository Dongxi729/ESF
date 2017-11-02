//
//  RepplaceVC.swift
//  Alili
//
//  Created by 郑东喜 on 2017/2/15.
//  Copyright © 2017年 郑东喜. All rights reserved.
//

import UIKit

import WebKit

class RepplaceVC: WKBaseViewController {
    
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
        
        let url = URL.init(string: urlStr as! String)
        
        DispatchQueue.main.async {
            
            self.urlRequestCache = NSURLRequest.init(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 0)
            self.webView.load(self.urlRequestCache as URLRequest)   
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
        
        XFLog(message: url)
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            
            
            if self.url.contains("?") {
                self.url = self.url + ("&devtype=1&token=") + (token)
            } else {
                self.url = self.url + ("?devtype=1&token=") + (token)
            }
            
            //判断是否包含相同的url
            if shoppingCarArray.count > 0 && (shoppingCarArray.lastObject as! String) == self.url {
                
                self.webView.reload()
                decisionHandler(.allow)
                
                shoppingCarArray.removeLastObject()
                return
            }
            
            shoppingCarArray.add(url)
            
            aaa(str: self.url)
            
            
            decisionHandler(.cancel)
            
        } else {
            
            decisionHandler(.allow)
        }
        
    }
    
    func aaa(str : String) -> Void {
        
        let vvv = ShoppingViewController()
        vvv.url = str
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
        
    }
    
}
