//
//  WKV+URL.swift
//  Alili
//
//  Created by 郑东喜 on 2017/11/2.
//  Copyright © 2017年 郑东喜. All rights reserved.
//  统一域名处理

import Foundation
import WebKit

extension WKBaseViewController {
    
    /// 加载域名
    ///
    /// - Parameters:
    ///   - loadURl: 加载处理好的域名
    ///   - firstUrl: 加载第一个域名
    func loadFirst(loadURl :String,firstUrl :  String) {
        
        if let nav = navigationController?.viewControllers.count {
            CCog(message: nav)
            if nav == 1 {
                self.url = firstUrl
            }
        }
        
        CCog(message: navigationController?.viewControllers.count)
        
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (sddd) in
            NetStatusModel.netStatus = sddd.rawValue
            if let nav = self.navigationController?.viewControllers.count {
                

                
                if NSStringFromClass(self.classForCoder).contains("ChangedRecordVC") ||
                    NSStringFromClass(self.classForCoder).contains("ServiceViewController") ||
                    NSStringFromClass(self.classForCoder).contains("RigisterAgreeWebView") {
                    if nav > 2 {
                        CCog()
                        if NetStatusModel.netStatus == 0 {
                            self.webView.load(URLRequest.init(url: URL.init(string: loadURl)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0))
                        } else {
                            self.webView.load(URLRequest.init(url: URL.init(string: loadURl)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0))
                        }
                    } else {
                        CCog()
                        if NetStatusModel.netStatus == 0 {
                            self.webView.load(URLRequest.init(url: URL.init(string: self.commaddURl(adUrl: firstUrl))!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0))
                        } else {
                            self.webView.load(URLRequest.init(url: URL.init(string: self.commaddURl(adUrl: firstUrl))!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0))
                        }
                    }
                } else {
                    if nav > 1 {

                        if NetStatusModel.netStatus == 0 {
                            self.webView.load(URLRequest.init(url: URL.init(string: loadURl)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0))
                        } else {
                            self.webView.load(URLRequest.init(url: URL.init(string: loadURl)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0))
                        }
                    } else {
                        if NetStatusModel.netStatus == 0 {
                            self.webView.load(URLRequest.init(url: URL.init(string: self.commaddURl(adUrl: firstUrl))!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0))
                        } else {
                            self.webView.load(URLRequest.init(url: URL.init(string: self.commaddURl(adUrl: firstUrl))!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0))
                        }
                    }
                }
                
                
            }
        }
    }
    
    func jumpComm(jumpVC : Any ,str : String) {
        
        // MARK: - 分类
        if NSStringFromClass(self.classForCoder).contains("CategoryVC") {
            let vc = CategoryVC()
            vc.url = str
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // MARK: - 首页
        if NSStringFromClass(self.classForCoder).contains("MainPageViewController") {
            let vc = MainPageViewController()
            vc.url = str
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // MARK: - 服务区ServiceViewController
        if NSStringFromClass(self.classForCoder).contains("ServiceViewController") {
            let vc = ServiceViewController()
            vc.url = str
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // MARK: - 支付失败PayFailViewController PaySuccessVC
        if NSStringFromClass(self.classForCoder).contains("PaySuccessVC") {}
        
        if NSStringFromClass(self.classForCoder).contains("PayFailViewController") {}
        
        // MARK: - 购物车ShoppingViewController  ShoppingReplaceView  RepplaceVC
        
        if NSStringFromClass(self.classForCoder).contains("ShoppingViewController") {
            let vc = ShoppingViewController()
            vc.url = str
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        // MARK: - 兑换纪录  ChangedRecordVC ChangedReplaceView
        if NSStringFromClass(self.classForCoder).contains("ChangedRecordVC") {
            let vc = ChangedRecordVC()
            vc.url = str
            self.navigationController?.pushViewController(vc, animated: true)
        }
        // MARK: - 交易明细 JiaoYIReplaceView  JiaoYIVC
        if NSStringFromClass(self.classForCoder).contains("JiaoYIVC") {}
        if NSStringFromClass(self.classForCoder).contains("JiaoYIReplaceView") {}
        
        if NSStringFromClass(self.classForCoder).contains("RigisterAgreeWebView") {
            let vc = RigisterAgreeWebView()
            vc.url = str
            self.navigationController?.pushViewController(vc, animated: true)
        }
        // MARK: - 分享视图 SharedVC  ShareReplaceView
    }
    
    @objc func commaddURl(adUrl : String) -> String{
        
        var aaa = ""
        if self.url.contains("?") {
            aaa = adUrl + ("&devtype=1&token=") + (token)
        } else {
            aaa = adUrl + ("?devtype=1&token=") + (token)
        }
        
        return aaa
    }
    
    /// 处理跳出去的域名方法
    ///
    /// - Parameter yy: 传递的控制器
    @objc func commJump(yy : UIViewController) {
        if self.url.contains("product_list.aspx") && !self.url.contains("token=") {
            webView.stopLoading()
            jumpComm(jumpVC: yy, str: commaddURl(adUrl: self.url))
        }
        
        
        if self.url.contains("buynow") && !self.url.contains("token=") {
            webView.stopLoading()
        }
        
        if self.url.contains("Informationdetail.aspx")  && !self.url.contains("token=") {
            webView.stopLoading()
            jumpComm(jumpVC: yy, str: commaddURl(adUrl: self.url))
        }
        
        if self.url.contains("order_pay") && !self.url.contains("token=") {
            webView.stopLoading()
            jumpComm(jumpVC: yy, str: commaddURl(adUrl: self.url))
        }
        
        if self.url.contains("orderdetail.aspx") && !self.url.contains("token=") {
            webView.stopLoading()
            jumpComm(jumpVC: yy, str: commaddURl(adUrl: self.url))
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        url = (navigationAction.request.url?.absoluteString)!
        
        CCog(message: self.url)
        // MARK: - 分类
        if NSStringFromClass(self.classForCoder).contains("CategoryVC") {
            
            if navigationAction.navigationType == WKNavigationType.linkActivated  {
            CCog(message: self.url)
                self.url = commaddURl(adUrl: self.url)
                
                jumpComm(jumpVC: CategoryVC(), str: self.url)
                decisionHandler(.cancel)
                
            } else {
                CCog(message: self.url)
                commJump(yy: CategoryVC())
                decisionHandler(.allow)
            }
        }
        
        
        // MARK: - 首页
        if NSStringFromClass(self.classForCoder).contains("MainPageViewController") {
            
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                
                CCog(message: self.url)
                
                if self.url.contains(firPage_URL) {
                    
                } else {
                    self.url = commaddURl(adUrl: self.url)
                    
                    jumpComm(jumpVC: MainPageViewController(), str: self.url)
                }
                decisionHandler(.cancel)
                
            } else {
                CCog(message: self.url)
                commJump(yy: MainPageViewController())
                decisionHandler(.allow)
            }
        }

        // MARK: - 购物车
        if NSStringFromClass(self.classForCoder).contains("ShoppingViewController") {
        
            CCog(message: self.url)
            if navigationAction.navigationType == WKNavigationType.linkActivated  {
                if self.url.contains(shooppingCarURL) {
                    
                } else {
                    
                    CCog(message: self.url)
                    
                    self.url = commaddURl(adUrl: self.url)
                    
                    CCog(message: self.url)
                    
                    jumpComm(jumpVC: ShoppingViewController(), str: self.url)
                }
                decisionHandler(.cancel)
                
            } else {
                CCog(message: self.url)
                commJump(yy: ShoppingViewController())
                if self.url.contains("token=") {
                }
                decisionHandler(.allow)
            }
        }
        
        // MARK: - 服务区
        if NSStringFromClass(self.classForCoder).contains("ServiceViewController") {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                
                CCog(message: self.url)
                
                if self.url.contains(fwqURL) {
                    
                } else {
                    self.url = commaddURl(adUrl: self.url)
                    
                    jumpComm(jumpVC: ServiceViewController(), str: self.url)
                }
                decisionHandler(.cancel)
                
            } else {
                CCog(message: self.url)
                commJump(yy: ServiceViewController())
                decisionHandler(.allow)
            }
        }
        if NSStringFromClass(self.classForCoder).contains("ServiceViewReplace") {}
        
        // MARK: - 支付失败
        if NSStringFromClass(self.classForCoder).contains("PaySuccessVC") {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                
                CCog(message: self.url)
                
                if self.url.contains(paySuccessURL) {
                    
                } else {
                    self.url = commaddURl(adUrl: self.url)
                    
                    jumpComm(jumpVC: PaySuccessVC(), str: self.url)
                }
                decisionHandler(.cancel)
                
            } else {
                CCog(message: self.url)
                commJump(yy: PaySuccessVC())
                decisionHandler(.allow)
            }
        }
        
        if NSStringFromClass(self.classForCoder).contains("PayFailViewController") {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                
                CCog(message: self.url)
                
                if self.url.contains(payFailURL) {
                    
                } else {
                    self.url = commaddURl(adUrl: self.url)
                    
                    jumpComm(jumpVC: PayFailViewController(), str: self.url)
                }
                decisionHandler(.cancel)
                
            } else {
                CCog(message: self.url)
                commJump(yy: PayFailViewController())
                decisionHandler(.allow)
            }
        }
        
        // MARK: - 兑换纪录  ChangedRecordVC ChangedReplaceView
        if NSStringFromClass(self.classForCoder).contains("ChangedRecordVC") {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                
                CCog(message: self.url)
                
                self.url = commaddURl(adUrl: self.url)
                
                if self.url.contains("user_dhjl.aspx?state=0") || self.url.contains("user_dhjl.aspx?state=1") || self.url.contains(changeRocordURL) {
                    webView.load(URLRequest.init(url: URL.init(string: self.url)!))
                } else {
                    
                    jumpComm(jumpVC: ChangedRecordVC(), str: self.url)
                }
                decisionHandler(.cancel)
                
            } else {
                commJump(yy: ChangedRecordVC())
                CCog(message: self.url)
                decisionHandler(.allow)
            }
        }
        
        // MARK: - 交易明细 JiaoYIReplaceView  JiaoYIVC
        if NSStringFromClass(self.classForCoder).contains("JiaoYIVC") {}
        if NSStringFromClass(self.classForCoder).contains("JiaoYIReplaceView") {}
        
        if NSStringFromClass(self.classForCoder).contains("RigisterAgreeWebView") {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                
                CCog(message: self.url)
                
                if self.url.contains(rigURL) {
                    
                } else {
                    self.url = commaddURl(adUrl: self.url)
                    
                    jumpComm(jumpVC: RigisterAgreeWebView(), str: self.url)
                }
                decisionHandler(.cancel)
                
            } else {
                CCog(message: self.url)
                commJump(yy: RigisterAgreeWebView())
                decisionHandler(.allow)
            }
        }
    }
    
    
    // MARK:- 允许拦截
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
}

