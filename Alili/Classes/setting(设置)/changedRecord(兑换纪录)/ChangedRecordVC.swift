//
//  ChangedRecordVC.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/30.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  兑换记录

import UIKit

import WebKit

class ChangedRecordVC: WKBaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///禁用左滑返回手势
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "兑换记录"
        
        
        if duihuanArray.count > 1 {
            let urlStr = duihuanArray.lastObject
            
            webView.load(URLRequest.init(url: URL.init(string: urlStr as! String)!))
            
        } else {
            DispatchQueue.main.async {
                
                let urlStr = changeRocordURL + "?devtype=1" + "&token=" + self.token

                if urlStr.contains(comStrURL) {
                    let url = URL.init(string: urlStr)
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

                } else {
                    CustomAlertView.shared.alertWithTitle(strTitle: "请下拉刷新")
                }

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
            
            duihuanArray.add(url)
            aaa(str: duihuanArray.lastObject as! String)
        
            decisionHandler(.cancel)
            
        } else {
            decisionHandler(.allow)
        }
    }
    
    //url---
    func aaa(str : String) -> Void {
        
        let vvv = ChangedReplaceView()
        vvv.url = str
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
//        self.hidesBottomBarWhenPushed = false
        
    }

}
