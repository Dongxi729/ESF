//
//  ServiceViewController.swift
//  DollarBuy
//
//  Created by 郑东喜 on 2016/11/6.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  服务区

import UIKit
import WebKit

class ServiceViewController: WKBaseViewController,WKBaseDelegate {

    //设置导航栏样式
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        self.navigationItem.title = "服务区"
        
        self.wkDelegate = self
        
        if fwqArray.count > 1 {
            let urlStr = fwqArray.lastObject as! String
            
            
            webView.load(URLRequest.init(url: URL.init(string: urlStr)!))
            
        } else {
            
            DispatchQueue.main.async {
                
                let urlStr = fwqURL + "?devtype=1&token=" + self.token
                
                //判断是否包含域名
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
    
    
     /// 地址请求拦截
     ///
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
        
        //XFLog(message: url)

        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            
            //如果为本身或者本身携带#的url进行自身刷新。
            if url == fwqURL {
                
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
            
            
            //vc基础类
            decisionHandler(.cancel)
            
            
        } else {
            decisionHandler(.allow)
        }

    }
    
    
    /// 拿到拦截到的url进行跳转
    func aaa(str : String) -> Void {
        
        let vvv = ServiceViewReplace()
        vvv.url = str
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
//        self.hidesBottomBarWhenPushed = false
    }
    
    
 }

// MARK:- 实现代理方法
extension ServiceViewController {
    /// 服务区，留言成功后，返回主界面
    func server() {
        self.navigationController!.popToRootViewController(animated: true)
    }
}
