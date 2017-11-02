//
//  LoginModel.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/21.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  登陆模型

import UIKit


class LoginModel: NSObject {
    
    static let shared = LoginModel()
    
    //将登陆状态传给闭包
    
    //外部闭包变量
    var comfun:((_ _data:String)->Void)?
    
    //单例个人信息
    var personData : NSDictionary?
    
    //登陆状态
    var loginStatus : String?
    
    /**
     ## 登陆
     主要实现了登陆封装逻辑
     
     - tfNum    电话号码
     - tfPass   密码
     */
    func login(tfNum : UITextField,tfPass : UITextField,_com:@escaping (_ _data:String)->Void) -> Void {
        
        comfun = _com
        
        if tfNum.text?.characters.count == 0 {
            CustomAlertView.shared.alertWithTitle(strTitle: tfNumIsNull)
            return
            
        } else if Encryption.checkTelNumber(tfNum.text) == false {

            CustomAlertView.shared.alertWithTitle(strTitle: tfNumNotCor)
            return
        } else if tfPass.text?.characters.count == 0 {

            CustomAlertView.shared.alertWithTitle(strTitle: tfPassNull)
            
        } else if Encryption.checkTelNumber(tfNum.text) == true {
            
            //请求参数
            let params = ["phone" : tfNum.text!,
                          "password" : tfPass.text!.md5(),
                          "deviceid": deviceID,
                          "devtype" : deviceTpye] as [String : Any]

            postWithPath(path: loginUrl, paras: params, success: { (response) in
                
                CCog(message: response)
                
                //判读返回值是否为空
                guard let dic = response as? NSDictionary else {
                    return
                }

                
                //提取提示语
                let resultCode = dic["resultcode"] as! String
                
                //XFLog(message: "resultCode = ",file: resultCode)
                
                //返回正确
                if resultCode == "0" {
                    
                    
                    //提取提示语
                    let alertmsg = dic["resultmsg"] as! String
                    
                    
                    if alertmsg == "帐号与密码不匹配" {
//                        CustomAlertView.shared.dissmiss()
                        
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            CustomAlertView.shared.alertWithTitle(strTitle: passAndAccountNot)
//                        }
                        
                    } else if alertmsg == "缺少手机号参数" {
                        
                        
                        CustomAlertView.shared.dissmiss()
                        
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            CustomAlertView.shared.alertWithTitle(strTitle: tfNumNotCor)
//                        }
                        
                    } else if alertmsg == "恭喜您登录成功" {
    
                        
                        //清除URL保存的值
                        mainIndexArray.removeAllObjects()
                        fwqArray.removeAllObjects()
                        commuArray.removeAllObjects()
                        shoppingCarArray.removeAllObjects()
                        jiaoYIArray.removeAllObjects()
                        zhongjiangArray.removeAllObjects()
                        duihuanArray.removeAllObjects()
                        fenxiangArray.removeAllObjects()
                        
                        //登陆状态
                        self.loginStatus = "true"
                        
                        
                        CustomAlertView.shared.dissmiss()
                        
                        
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            CustomAlertView.shared.alertWithTitle(strTitle: loginSuccess)
//                        }
                        
                        
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
                            
                            //存储密码
                            localSave.set(tfPass.text, forKey: localPass)
                            
                            localSave.synchronize()
                            
                            
                            //本地用户名，写入内存（在app活动期间展示用户名）
                            _uName = tfNum.text!
                        }
                        
                    }
                    
                    
                    
                    guard let userDic = dic["data"] as? NSDictionary else {
                        return
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
                    
                    if let headUrl = pData["img"] as? String {
                        PersonInfoModel.shared.personImg = "http://" + comStrURL + headUrl
                    }
                    
                    PersonInfoModel.shared.jifen = pData["integral"] as? String
                    
                    
                    
                    //单例传值
                    self.personData = pData
                    
                    //保存到个人信息模型，用于app生存周期间赋值
                    PersonInfoModel.shared.personDicInfo = pData
                    
                    
                    //保存到本地用户收货地址
                    localSave.set(addDic, forKey: personAddData)
                    
                    //保存用户个人信息
                    localSave.set(pData, forKey: personInfo)
                    
                    localSave.synchronize()
                    
                    //传值
                    self.comfun!(alertmsg)
                    
                
                
                } else {
                    
                    let alMsg = dicc[resultCode]
                    
                    if resultCode == "40107" {
                        CustomAlertView.shared.dissmiss()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                            
                            //刷新猪控制器
                            CustomAlertView.shared.closeWithAlert(strTitle: loginError, test: {
                                
                                logoutModel.shared.logoutWithOutAlert()
                                
                            })
                        }
                        
                    } else {
                        
                        CustomAlertView.shared.dissmiss()

                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: alMsg!)
                        })
                    }

                }
                

            }, failure: { (error) in

                CustomAlertView.shared.dissmiss()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    CustomAlertView.shared.alertWithTitle(strTitle: "网络异常")
                }
                
            })
        }
        
    }
    
    ///不带提示的登陆模型，用于同步信息的时候
    func loginWithLocalInfo(tfNum : String,tfPass : String,_com:@escaping (_ _data:String)->Void) -> Void {
        
        comfun = _com

            //请求参数
            let params = ["phone" : tfNum,
                          "password" : tfPass.md5(),
                          "deviceid": deviceID,
                          "devtype" : deviceTpye] as [String : Any]

            //XFLog(message: params)
        
            //提示栏
            postWithPath(path: loginUrl, paras: params, success: { (response) in
                
                //判读返回值是否为空
                guard let dic = response as? NSDictionary else {
                    return
                }
                
                
                //提取提示语
                let resultCode = dic["resultcode"] as! String
                
                //XFLog(message: "resultCode = ",file: resultCode)
                
                if resultCode == "0" {
                    //提取提示语
                    let alertmsg = dic["resultmsg"] as! String
                    
                    if alertmsg == "帐号与密码不匹配" {
                        
                    } else if alertmsg == "缺少手机号参数" {
                        
                    } else if alertmsg == "恭喜您登录成功" {
                        
                        
                        //清除URL保存的值
                        mainIndexArray.removeAllObjects()
                        fwqArray.removeAllObjects()
                        commuArray.removeAllObjects()
                        shoppingCarArray.removeAllObjects()
                        jiaoYIArray.removeAllObjects()
                        zhongjiangArray.removeAllObjects()
                        duihuanArray.removeAllObjects()
                        fenxiangArray.removeAllObjects()
                        
                        
                        self.loginStatus = "true"
                        
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
                            localSave.set(tfNum, forKey: localName)
                            
                            //存储密码
                            localSave.set(tfPass, forKey: localPass)
                            
                            localSave.synchronize()
                            
                            
                            //本地用户名，写入内存（在app活动期间展示用户名）
                            //                        _uName = tfNum.text!
                        }
                        
                    } else {
                        CustomAlertView.shared.dissmiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: unKnown)
                        })
                    }
                    
                    
                    guard let userDic = dic["data"] as? NSDictionary else {
                        return
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
                    
                    if let headUrl = pData["img"] as? String {
                        PersonInfoModel.shared.personImg = "http://" + comStrURL + headUrl
                    }
                    
                    PersonInfoModel.shared.jifen = pData["integral"] as? String
                    
                    
                    
                    
                    //单例传值
                    self.personData = pData
                    
                    //保存到个人信息模型，用于app生存周期间赋值
                    PersonInfoModel.shared.personDicInfo = pData
                    
                    
                    //保存到本地用户收货地址
                    localSave.set(addDic, forKey: personAddData)
                    
                    //保存用户个人信息
                    localSave.set(pData, forKey: personInfo)
                    
                    localSave.synchronize()
                    
                    
                    //传值
                    self.comfun!(alertmsg)
                    

                } else {
                    
                    if resultCode == "40107" {
                        CustomAlertView.shared.dissmiss()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                            
                            //刷新猪控制器
                            CustomAlertView.shared.closeWithAlert(strTitle: loginError, test: {
                                
                                logoutModel.shared.logoutWithOutAlert()
                                
                            })
                        }
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
//                            CustomAlertView.shared.alertWithTitle(strTitle: alMsg!)
                        })
                    }

                }
                
                
                
            }, failure: { (error) in
                
            })
        
            
        
    }
    
}
