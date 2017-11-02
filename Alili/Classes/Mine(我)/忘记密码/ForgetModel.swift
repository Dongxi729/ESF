//
//  ForgetModel.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/21.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  忘记密码模型

import UIKit

class ForgetModel: NSObject {
    
    //单例初始化
    static let shared = ForgetModel()
    
    //将忘记密码修改状态传给闭包
    
    //外部闭包变量
    var comfun:((_ _data:String)->Void)?
}

extension ForgetModel {
    /**
     ## 忘记密码
     封装忘记密码业务逻辑
     
     - tfNum            电话号码
     - tfPass           密码
     - tfConfirmPass    确认密码
     */
    func forgetPass(tfNum : UITextField,tfAuto : UITextField,tfPass : UITextField,tfConfirmPass : UITextField,_com:@escaping (_ _data:String)->Void) -> Void {
        
        comfun = _com
        
        if tfNum.text?.characters.count == 0 {
            CustomAlertView.shared.alertWithTitle(strTitle: tfNumIsNull)
            
        } else if tfAuto.text?.characters.count == 0 {
            CustomAlertView.shared.alertWithTitle(strTitle: tfAutoNull)
            
        } else if tfPass.text?.characters.count == 0 {
            CustomAlertView.shared.alertWithTitle(strTitle: tfPassNull)
            
        } else if tfConfirmPass.text?.characters.count == 0 {
            CustomAlertView.shared.alertWithTitle(strTitle: confirPassNotNull)
            
        } else if Encryption.checkTelNumber(tfNum.text) == false {
            CustomAlertView.shared.alertWithTitle(strTitle: tfNumNotCor)
            
        } else if tfPass.text != tfConfirmPass.text {
            CustomAlertView.shared.alertWithTitle(strTitle: passTwoChekc)
            
        } else if Encryption.checkTelNumber(tfNum.text) == true {
            let params = ["code":tfAuto.text!,
                          "newpwd":tfPass.text!.md5(),
                          "phone":tfNum.text!] as [String : Any]

            
            CustomAlertView.shared.alertAfterDown(strTitle: "密码修改中...")
            postWithPath(path: forgetPassUrl, paras: params, success: { (response) in
                /**
                 缺少手机号参数或手机格式错误或不为11位数字
                 短信验证码错误
                 缺少验证码参数
                 手机号不存在
                 你的密码修改成功
                 触发业务流控
                 */
                guard let dic = response as? NSDictionary else {
                    return
                }

                //XFLog(message: dic)
                //提取提示语
                let alertmsg = dic["resultmsg"] as! String
                
                
                if alertmsg == "缺少手机号参数或手机格式错误或不为11位数字" {

                    
                    CustomAlertView.shared.dissmiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { 
                        CustomAlertView.shared.alertWithTitle(strTitle: tfNumNotCor)
                    })
                    
                } else if alertmsg == "短信验证码错误" {

                    
                    CustomAlertView.shared.dissmiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        CustomAlertView.shared.alertWithTitle(strTitle: tfAuthWrong)
                    })
                    
                } else if alertmsg == "触发业务流控"{
                    
                    CustomAlertView.shared.dissmiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        CustomAlertView.shared.alertWithTitle(strTitle: msgSengWrong)
                    })
                    
                } else if alertmsg == "手机号不存在"{
                    CustomAlertView.shared.dissmiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        CustomAlertView.shared.alertWithTitle(strTitle: phoneNotExist)
                    })
                    
                } else if alertmsg == "你的密码修改成功"{
                    
                    //传值
                    self.comfun!(alertmsg)
                    
                    CustomAlertView.shared.dissmiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        CustomAlertView.shared.alertWithTitle(strTitle: changePasSuccess)
                    })
                }
                
                
            }, failure: { (error) in

                CustomAlertView.shared.dissmiss()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    CustomAlertView.shared.alertWithTitle(strTitle: netWrong)
                })
            })
        }
        
    }
}
