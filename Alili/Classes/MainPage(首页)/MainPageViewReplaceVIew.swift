//
//  MainPageViewReplaceVIew.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/12/6.
//  Copyright © 2016年 郑东喜. All rights reserved.
//

import UIKit

import WebKit

class MainPageViewReplaceVIew : WKBaseViewController,WKBaseDelegate {
    
    
    //设置导航栏样式
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        self.navigationController?.navigationBar.isHidden = false
        
        
        if (self.navigationController?.viewControllers.count)! > 0 {
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: UIColor.black]
            
            UIApplication.shared.statusBarStyle = .default
            
            
        } else {
            
            self.webView.frame = CGRect.init(x: 0, y: 20, width: SW, height: SH + 20)
            
            self.navigationController?.navigationBar.barTintColor = commonBtnColor
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.wkDelegate = self
        
        if self.webView == nil {
            return
        }
        
        XFLog(message: self.url)
        
        DispatchQueue.main.async {
            
            
            self.webView.load(URLRequest.init(url: URL.init(string: self.url)!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 5.0))
            
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
        
        //        XFLog(message: self.url)
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            
            
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
    
    //url---
    func aaa(str : String) -> Void {
        let vvv = MainPageViewController()
        vvv.url = str
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
    }
    
    
}


// MARK:- 实现代理方法
extension MainPageViewReplaceVIew {
    func server() {
        
        self.navigationController!.popToRootViewController(animated: true)
    }
}
