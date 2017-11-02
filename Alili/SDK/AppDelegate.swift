//
//  AppDelegate.swift
//  DollarBuy
//
//  Created by 郑东喜 on 2016/11/1.
//  Copyright © 2016年 郑东喜. All rights reserved.
//

import UIKit

var netStatus = ""


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let tool = WXTool()
    let qqTool = QQTool()
    
    lazy var tencentOAuth = TencentOAuth()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //创建window
        UIApplication.shared.isStatusBarHidden = false

        ///设置主启动界面
        setMainBar()
        
        return true
    }
}


// MARK:- 设置主控制器
extension AppDelegate {
    func setMainBar() -> Void {
        // 创建window
        
        window = UIWindow.init(frame: UIScreen.main.bounds)

        window?.makeKeyAndVisible()

        let customtabbar = MainViewController()
        window?.rootViewController = customtabbar
        
        //设置QQ
        setQQ()
        
        //设置微信
        setWX()
        
        // 设置全局颜色
        UITabBar.appearance().tintColor = commonBtnColor
        UINavigationBar.appearance().tintColor = commonBtnColor
    }
}

// MARK:- 第三方介入
extension AppDelegate {
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
                
        let wxUrl = String(format: "%@", arguments: [WXPatient_App_ID])
        let qqUrl = String(format: "tencent%@", arguments: [QQAppID])
        
        if url.absoluteString.hasPrefix(wxUrl) {
            return WXApi.handleOpen(url, delegate: tool)
            
        } else if url.absoluteString.hasPrefix(qqUrl){
            QQApiInterface.handleOpen(url, delegate: qqTool)
            return TencentOAuth.handleOpen(url)
            //微信支付
        }
            
        else if url.host == "safepay" {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: {[weak self] (resultDic) in
                
                var data = NSDictionary()
                
                if let resultStatus = resultDic?["resultStatus"] as? String {
                    
                    if resultStatus == "9000"{
                        data = ["re" : "支付成功"]
                        
                    }else if resultStatus == "8000"{
                        data = ["re" : "正在处理中"]
                        
                    }else if resultStatus == "4000"{
                        data = ["re" : "订单支付失败"]
                        
                    }else if resultStatus == "6001" {
                        data = ["re" : "用户中途取消"]
                        
                    } else if resultStatus == "6002" {
                        data = ["re" : "网络连接出错"]
                    }
                }
                
                //发出网页调用支付宝的结果
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "123"), object: self, userInfo: data as? [AnyHashable : Any])
                
                return
            })
        }

        return true
    }
    
}

// MARK:- QQ、微信第三方回调
extension AppDelegate {

    // MARK:- 微信、QQ回调代理方法
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
                
        let wxUrl = String(format: "%@", arguments: [WXPatient_App_ID])
        let qqUrl = String(format: "tencent%@", arguments: [QQAppID])
        
        //微信
        if url.absoluteString.hasPrefix(wxUrl) {
            
            
            return WXApi.handleOpen(url, delegate: tool)
            
            //QQ
        } else if url.absoluteString.hasPrefix(qqUrl){
            QQApiInterface.handleOpen(url, delegate: qqTool)
            return TencentOAuth.handleOpen(url)
        }
        return true;
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        MBManager.hideAlert()
    }
}

// MARK:- 微信
extension AppDelegate {
    
    func setWX() -> Void {
//        WXApi.registerApp(WXPatient_App_ID)
        WXApi.registerApp(WXPatient_App_ID, enableMTA: true)

    }
}

// MARK:- QQ
extension AppDelegate {
    func setQQ() -> Void {
        tencentOAuth = TencentOAuth(appId: QQAppID, andDelegate: qqTool)
    }
}



