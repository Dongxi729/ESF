//
//  ShoppingViewController.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/12/2.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  购物车界面

import UIKit
import WebKit


class ShoppingViewController : WKBaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        XFLog(message: self.navigationController?.viewControllers.count)
        
        if self.navigationController?.viewControllers.count == 1 {
            if SH == 812 {
                XFLog(message: "小炮")
                webView.frame = CGRect.init(x: 0, y: 0, width: SW, height: SH - (self.navigationController?.navigationBar.Height)! - 64 * 2)
            }
        }
        
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
        
        if (localSave.object(forKey: userToken) != nil) {
            let urlStr = (shooppingCarURL) + ("?devtype=1&token=") + self.token
            self.webView.load(URLRequest.init(url: URL.init(string: urlStr)!))
            
        } else {

            
            ///修改导航栏高度和首页一致
            let compassView : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SW, height: 20))
            compassView.backgroundColor = commonBtnColor
            view.addSubview(compassView)
            self.navigationController?.navigationBar.isHidden = true
            
            self.webView.frame = CGRect.init(x: 0, y: 20, width: SW, height: SH + 20)
            
            
            //设置状态栏颜色
            self.navigationController?.navigationBar.barTintColor = commonBtnColor
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            //加载本地索引为0的缓存
            let urlStr = "http://\(comStrURL)/app/index.aspx?devtype=1" + "&token=" + self.token
            
            //判断是否包含域名
            if urlStr.contains(comStrURL) {
                let url1 = URL.init(string: urlStr)
                self.urlRequestCache = NSURLRequest(url: url1!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
                
                self.webView.load(self.urlRequestCache as URLRequest)
                
            } else {
                return
            }
            
            
            let alertView = UIAlertController.init(title: "提示", message: "请登录", preferredStyle: .alert)
            alertView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (nil) in
                
                //清除URL保存的值
                mainIndexArray.removeAllObjects()
                fwqArray.removeAllObjects()
                commuArray.removeAllObjects()
                shoppingCarArray.removeAllObjects()
                jiaoYIArray.removeAllObjects()
                zhongjiangArray.removeAllObjects()
                duihuanArray.removeAllObjects()
                fenxiangArray.removeAllObjects()
                
                //切换至首页并添加动画
                let tabbarVC = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
                
                tabbarVC.selectedIndex = 0
                
                //转场动画
                Animated.vcWithTransiton(vc: tabbarVC, animatedType: "kCATransitionFade", timeduration: 1.0)
                
            }))
            
            alertView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (nil) in
                
                //设置状态栏颜色
                self.navigationController?.navigationBar.barTintColor = UIColor.white
                
                //文字颜色
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
                
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(LoginView(), animated: true)
                
                self.navigationController?.navigationBar.barTintColor = UIColor.white
                
                //文字颜色
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
                
                
                UIApplication.shared.statusBarStyle = .default
                self.hidesBottomBarWhenPushed = false
                
            }))
            
            //            self.present(alertView, animated: true, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
            
            return
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //取出本地token，进行拼接
        if (localSave.object(forKey: userToken) != nil) {
            
            self.navigationItem.title = "购物车"
            //背景色--白色
            view.backgroundColor = UIColor.white
            
            if shoppingCarArray.count > 1 {
                
                let urlStr = ((shoppingCarArray.lastObject) as! String)
                
                self.url = urlStr
                
                webView.load(URLRequest.init(url: URL.init(string: urlStr)!))
                
            } else  {
                DispatchQueue.main.async {
                    
                    let urlStr = (shooppingCarURL) + ("?devtype=1&token=") + self.token
                
                    self.url = urlStr
                    
                    if urlStr.contains(comStrURL) {
                        let url = URL.init(string: urlStr)
                        DispatchQueue.main.async {
                            
                            self.urlRequestCache = NSURLRequest.init(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 0)
                        }
                    } else {
                        CustomAlertView.shared.alertWithTitle(strTitle: "请下拉刷新")
                    }
                }
                
            }
            
        } else {
            let alertView = UIAlertController.init(title: "提示", message: "请登录", preferredStyle: .alert)
            alertView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            
            alertView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (nil) in
                
                self.navigationController?.pushViewController(LoginView(), animated: true)
            }))
            
        }
    }
    
    
    /**
     *  JS 调用 swift 时 webview 会调用此方法
     *
     *  @param userContentController  webview中配置的userContentController 信息
     *  @param message                JS执行传递的消息
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
        
        XFLog(message: url)

        if navigationAction.navigationType == WKNavigationType.linkActivated || self.url.contains("order_pay") {
            
            //如果为本身或者本身携带#的url进行自身刷新。
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
            
            shoppingCarArray.add(self.url)
            self.aaa(str: self.url)
            
            decisionHandler(.cancel)
            
            
        } else {
            decisionHandler(.allow)
        }
    }
    
    /// 跳转的控制器
    ///
    func aaa(str : String) -> Void {
        
        let vvv = ShoppingReplaceView()
        vvv.url = str
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vvv, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if self.navigationController?.childViewControllers.count == 1 {
            MBManager.hideAlert()
        }
    }
}
