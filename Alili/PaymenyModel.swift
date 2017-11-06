//
//  PaymenyModel.swift
//  Alili
//
//  Created by 郑东喜 on 2016/11/30.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  支付宝支付

import UIKit


class PaymenyModel: NSObject,UIApplicationDelegate {

    static let shared = PaymenyModel()
    
    
    
    //外部闭包变量
    var comfun:((_ _data:String)->Void)?
    
    func alipay(orderString : String,comfun:((_ _data:String)->Void)?) -> Void {
        
        self.comfun = comfun
        
        let appScheme = "com.dongze.store"
        
        /**
         *  支付接口
         *
         *  @param orderStr       订单信息
         *  @param schemeStr      调用支付的app注册在info.plist中的scheme
         *  @param compltionBlock 支付结果回调Block，用于wap支付结果回调（非跳转钱包支付）
         */
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: {[weak self] resultDic in
            
            if let strongSelf = self {
                //                 print("result =",resultDic!)
                
                if let resultStatus = resultDic?["resultStatus"] as? String {

                    ///执行到此
                    if resultStatus == "9000"{
                        strongSelf.comfun!("网页支付成功")
                        
                        

                    }else if resultStatus == "8000"{
                        
                        strongSelf.comfun!("正在处理中")
                    }else if resultStatus == "4000"{
                        
                        strongSelf.comfun!("订单支付失败")
                    ///执行到此
                    }else if resultStatus == "6001" {

                        strongSelf.comfun!("用户中途取消")

                    }else if resultStatus == "6002" {
                        strongSelf.comfun!("网络连接出错")
                    }
                }
            }
        })
    }
}
