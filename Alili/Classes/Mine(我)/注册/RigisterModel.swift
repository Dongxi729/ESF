//
//  RigisterModel.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/22.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  注册模型

import UIKit

class RigisterModel: NSObject {
    
    static let shared = RigisterModel()
    
    var comfun:((_ _data : String) -> Void)?
    
    //新用户
    var isNew = "false"
    
    /**
     ## 注册
     封装了注册逻辑
     
     - tfNum            电话号码
     - tfAuto           验证码
     - tfPass           密码
     - tfconfirmPass    确认密码
     */
    func rigister(tfNum : UITextField,tfAuto : UITextField, tfPass : UITextField,tfconfirmPass : UITextField,tfNickName : UITextField,_com:@escaping (_ _data:String)->Void) -> Void {

        //赋值闭包内存
        self.comfun = _com
        
        let bool = localSave.bool(forKey: agreeLaw)
        
        if tfNum.text?.characters.count == 0 {

            CustomAlertView.shared.alertWithTitle(strTitle: tfNumIsNull)
            
        } else if Encryption.checkTelNumber(tfNum.text) == false {

            CustomAlertView.shared.alertWithTitle(strTitle: tfNumNotCor)
            
        } else if tfAuto.text?.characters.count == 0 {

            CustomAlertView.shared.alertWithTitle(strTitle: tfAutoNull)
            
        } else if tfPass.text?.characters.count == 0 {
            CustomAlertView.shared.alertAfterDown(strTitle: tfPassNull)
            
        } else if tfconfirmPass.text?.characters.count == 0 {
            CustomAlertView.shared.alertWithTitle(strTitle: confirPassNotNull)

            
        } else if tfPass.text != tfconfirmPass.text {
            CustomAlertView.shared.alertWithTitle(strTitle: passTwoChekc)
            
        } else if tfNickName.text?.characters.count == 0 {
            CustomAlertView.shared.alertWithTitle(strTitle: nickNameNotNull)
            
            
            
        } else if Encryption.checkTelNumber(tfNum.text) == true && bool == false {
            
            /**
             注册成功，恭喜您成为一元预购的新成员
             缺少验证码
             短信验证码错误
             手机号已被注册
             缺少手机号参数或手机格式错误或为11位数字
             */
            let params = ["deviceid":deviceID,
                          "devtype": deviceTpye,
                          "nickname" : tfNickName.text!,
                          "phone":tfNum.text!,
                          "password":tfPass.text!.md5(),
                          "code":tfAuto.text!] as [String : Any]

            CustomAlertView.shared.alertWithIndicator(strTitle: "注册中...")
            
            postWithPath(path: rigisterUrl, paras: params, success: { (response) in
                
                guard let dic = response as? NSDictionary else {
                    return
                }

                
                //XFLog(message: dic)

                //提取提示语
                _ = dic["resultcode"] as! String

                //返回正确

                    //提取提示语
                    let alertmsg = dic["resultmsg"] as! String
                    
                    
                    if alertmsg == "缺少手机号参数或手机格式错误或为11位数字" {
                        
                        CustomAlertView.shared.dissmiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: tfNumNotCor)
                        })
                        
                        return
                    } else if alertmsg == "短信验证码错误" {
                        
                        CustomAlertView.shared.dissmiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: authNumWrong)
                        })
                        
                        return
                    } else if alertmsg == "手机号已被注册"{
                        CustomAlertView.shared.dissmiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: numUsed)
                        })
                        
                        return
                    } else if alertmsg == "缺少昵称" {
                        CustomAlertView.shared.dissmiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: nickNameWrong)
                        })
                        
                        return
                    } else if alertmsg == "注册成功，恭喜您成为一元预购的新成员" {
                        
                        LoginModel.shared.loginStatus = "true"
                        RigisterModel.shared.isNew = "true"
                        
                        //清除URL保存的值
                        mainIndexArray.removeAllObjects()
                        fwqArray.removeAllObjects()
                        commuArray.removeAllObjects()
                        shoppingCarArray.removeAllObjects()
                        jiaoYIArray.removeAllObjects()
                        zhongjiangArray.removeAllObjects()
                        duihuanArray.removeAllObjects()
                        fenxiangArray.removeAllObjects()
                        
                        CustomAlertView.shared.dissmiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: rigSuccess)
                        })
                        
                        
                        
                        //存储账号、密码
                        localSave.set(tfNum.text, forKey: localName)
                        
                        localSave.set(tfPass.text, forKey: localPass)
                        
                        localSave.synchronize()
                        
                        
                        
                        guard let userDic = dic["data"] as? NSDictionary else {
                            return
                        }
                        
                        guard let dataSource = (dic["data"] as? NSDictionary) else {
                            return
                        }
                        
                        //如果返回信息为空，不执行下面，否则保存对应的用户信息
                        if dataSource.count == 0 {
                            return
                            
                        } else {
                            
                            let token = dataSource["token"] as! String

                            //存储用户动态标识ID
                            localSave.set(token, forKey: userToken)
                            
                            
                            //存储账号
                            localSave.set(tfNum.text, forKey: localName)
                            localSave.synchronize()
                            
                        }
                        
                        
                        //提取用户收获地址
                        let addDic = userDic["address"] as! NSDictionary
                        
                        GetGoodModel.shared.addDic = addDic
                        
                        //改变单例的值
                        GetGoodModel.shared.shrName = addDic["shrname"] as? String
                        GetGoodModel.shared.area = addDic["area"] as? String
                        GetGoodModel.shared.city = addDic["city"] as? String
                        GetGoodModel.shared.province = addDic["province"] as? String
                        GetGoodModel.shared.shrphone = addDic["shrphone"] as? String
                        GetGoodModel.shared.street = addDic["street"] as? String
                        
                        //提取用户个人信息
                        let  pData = userDic["user"] as! NSDictionary
                        
                        
                        //改变单例的值
                        PersonInfoModel.shared.nickName = pData["nickname"] as? String
                        
                        PersonInfoModel.shared.personImg = pData["img"] as? String
                        
                        PersonInfoModel.shared.jifen = pData["integral"] as? String
                        
                        
                        
                        //单例传值
                        LoginModel.shared.personData = pData
                        
                        //保存到个人信息模型，用于app生存周期间赋值
                        PersonInfoModel.shared.personDicInfo = pData
                        
                        
                        //保存到本地用户收货地址
                        localSave.set(addDic, forKey: personAddData)
                        
                        //保存用户个人信息
                        localSave.set(pData, forKey: personInfo)
                        
                        localSave.synchronize()
                        

                        
                        //存入本地单例中显示
                        
                        //本地用户名，写入内存（在app活动期间展示用户名）
                        _uName = tfNum.text!
                        
                        self.comfun!(alertmsg)
                     
                        
                    } else {
                        CustomAlertView.shared.dissmiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: unKnown)
                        })
                        
                        return
                }
                
            }, failure: { (error) in
                self.comfun!(error.localizedDescription)

                CustomAlertView.shared.dissmiss()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    CustomAlertView.shared.alertWithTitle(strTitle: netWrong)
                })
                
            })
        }
        else {

            CustomAlertView.shared.alertWithTitle(strTitle: agressLawing)
        }

    }
}

extension RigisterModel {
    
}

