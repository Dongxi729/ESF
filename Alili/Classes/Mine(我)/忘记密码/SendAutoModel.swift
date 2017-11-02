//
//  SendAutoModel.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/21.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  发送验证码模型

import UIKit



class SendAutoModel: NSObject {
    static let shared = SendAutoModel()
    
    //闭包传值（请求返回的值）
    var comfun:((_ _data : String) -> Void)?

    var aa : String = ""
    
    
}


extension SendAutoModel {
    /**
     ## 发送忘记密码验证码
     封装发送验证码业务逻辑
     
     - tfNum    电话号码
     */
    func sendForgetAuto(sendType : Int,tfNum : UITextField,_com:@escaping (_ _data:String)->Void) -> Void {
        
        //闭包内存传值
        self.comfun = _com
        
        //检查验证码是否为空
        if tfNum.text?.characters.count == 0 {
            CustomAlertView.shared.alertWithTitle(strTitle: tfNumIsNull)

        } else if Encryption.checkTelNumber(tfNum.text) == false {
            
            CustomAlertView.shared.alertWithTitle(strTitle: tfNumNotCor)

        } else if Encryption.checkTelNumber(tfNum.text) == true {
            
            let params = ["type": sendType,
                          "phone":tfNum.text!] as [String : Any]

            aa = "true"
            
            self.comfun!(aa)

            postWithPath(path: sendMsgUrl, paras: params, success: {
                (response) in
                
                print(type(of: self),#line,response)
                
                //判读返回值是否为空
                guard let dic = response as? NSDictionary else {

                    return
                }
               
                //XFLog(message: dic)
                

                    //提取提示语
                    let alertmsg = dic["resultmsg"] as! String
                    
                    if alertmsg == "手机号已被注册" {

                        CustomAlertView.shared.alertWithTitle(strTitle: numUsed)
                        
                    } else if alertmsg == "成功" {

                        CustomAlertView.shared.alertWithTitle(strTitle: msgSended)
                    } else if alertmsg == "触发业务流控" {

                        CustomAlertView.shared.alertWithTitle(strTitle: msgSengWrong)
                        
                    } else if alertmsg == "发送短信失败" {

                        CustomAlertView.shared.alertWithTitle(strTitle: msgSengWrong)
                    } else if alertmsg == "不可设置密码" {

                        
                    } else {

                        CustomAlertView.shared.dissmiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: unKnown)
                        })
                    }
                    
                    //接收返回值
                    self.comfun!(alertmsg)

            }, failure: { (error) in

                MBManager.showBriefAlert(netWrong)
            })
   
        
        }
        
        

    }
}
