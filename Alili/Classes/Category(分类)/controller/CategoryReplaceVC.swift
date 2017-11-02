//
//  CategoryReplaceVC.swift
//  Alili
//
//  Created by 郑东喜 on 2017/2/13.
//  Copyright © 2017年 郑东喜. All rights reserved.
//

import UIKit
import WebKit

class CategoryReplaceVC: WKBaseViewController {
    
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
        
        // Do any additional setup after loading the view.
        
        if separateArrey.count > 1 {
            //取出数组的url转为字符串
            url = separateArrey.lastObject as! String
            
            //XFLog(message: url)
            
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        } else {
            
        }
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
        
        if navigationAction.navigationType == WKNavigationType.linkActivated || self.url.contains("product_list.aspx") || self.url.contains("tp=buynow") {
            
            
            if self.url.contains("?") {
                self.url = self.url + ("&devtype=1&token=") + (token)
            } else {
                self.url = self.url + ("?devtype=1&token=") + (token)
            }
            
            
            mainIndexArray.add(self.url)
            
            self.aaa(str: mainIndexArray.lastObject as! String)
            
            decisionHandler(.cancel)
            
        } else {
            decisionHandler(.allow)
        }
    }
    
    /// 页面跳转
    ///
    /// - Parameter str: 跳转的链接
    func aaa(str : String) -> Void {
        
        let vvv = CategoryVC()
        vvv.url = str
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
}
