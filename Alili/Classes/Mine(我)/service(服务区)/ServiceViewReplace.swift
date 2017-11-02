//
//  ServiceViewReplace.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/12/7.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  服务区替换界面，原理同ServiewViewController

import UIKit
import WebKit

class ServiceViewReplace: WKBaseViewController,WKBaseDelegate {
    
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
        let urlStr = fwqArray.lastObject
        
        self.wkDelegate = self
        
        let url = URL.init(string: urlStr as! String)
        
        
        DispatchQueue.main.async {
            if self.netThrough {
                
                DispatchQueue.main.async {
                    
                    
                    self.urlRequestCache = NSURLRequest.init(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 0)
                    self.webView.load(self.urlRequestCache as URLRequest)
                    
                }
                
            } else {
                DispatchQueue.main.async {
                    
                    self.urlRequestCache = NSURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
                    self.webView.load(self.urlRequestCache as URLRequest)
                    
                }
            }
        }
    }
    
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        url = (navigationAction.request.url?.absoluteString)!

        //XFLog(message: url)
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            
            //如果为本身或者本身携带#的url进行自身刷新。
            if url == fwqURL {
                
                //自刷新
                self.webView.load(URLRequest.init(url: URL.init(string: url)!))
                
                fwqArray.removeAllObjects()
                
            } else {
                //XFLog(message: fwqArray)

                    if url.contains("?") {
                        url = url + ("&devtype=1&token=") + (token)
                    } else {
                        url = url + ("?devtype=1&token=") + (token)
                    }
                }
                
                fwqArray.add(url)
                aaa(str: fwqArray.lastObject as! String)
            
            decisionHandler(.cancel)
            
        } else {
            decisionHandler(.allow)
            
        }
    }
    
    //url---
    func aaa(str : String) -> Void {
        
        
        let vvv = ServiceViewController()
        vvv.url = str
        self.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vvv, animated: true)
    }

}

// MARK:- 实现代理方法
extension ServiceViewReplace {
    func server() {

        self.navigationController!.popToRootViewController(animated: true)
    }
}
