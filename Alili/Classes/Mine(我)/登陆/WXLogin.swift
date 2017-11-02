//
//  WXLogin.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/13.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  微信登陆方法

import UIKit

//var _wxLoginSuccess : String = "false"

class WXLogin: NSObject {
    
    //单例
    static let shared = WXLogin()
    
    //闭包传值
    var comfun:((_ _data : String) -> Void)?
    
    /**
     ## 实现微信第三方登陆
     */

    func wxLogin(_com:@escaping (_ _data:String)->Void) -> Void {
    //接收闭包内存地址
        self.comfun = _com

        ///获取微信open id
        let wxopenID = thirdOpenID
        
        ///获取微信头像地址
        let wxHeadImgURL = thirdHeadImgURL
        
        ///微信昵称
        let wxNickName = thirdNickName
        
        
        let param = ["deviceid" : deviceID,
                     "devtype" : deviceTpye,
                     "openid" : wxopenID,
                     "platform" : 2,
                     "headimg" : wxHeadImgURL,
                     "nickname" : wxNickName,] as [String :Any]

        postWithPath(path: oauthURL, paras: param, success: { (response) in
            
            
            guard let dic = response as? NSDictionary else {
                return
            }
            
            
            //提取提示语
            let resultCode = dic["resultcode"] as! String
            
            //返回正确
            if resultCode == "0" {
                
                //清除URL保存的值
                mainIndexArray.removeAllObjects()
                fwqArray.removeAllObjects()
                commuArray.removeAllObjects()
                shoppingCarArray.removeAllObjects()
                jiaoYIArray.removeAllObjects()
                zhongjiangArray.removeAllObjects()
                duihuanArray.removeAllObjects()
                fenxiangArray.removeAllObjects()
                
                //提取提示语
                let alertmsg = dic["resultmsg"] as! String
                
                if alertmsg == "授权成功" {
//                    _wxLoginSuccess = "true"

                    CustomAlertView.shared.dissmiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                        CustomAlertView.shared.alertWithTitle(strTitle: authSuccess)
                    })
                    
                    
                    //FIXME: 表示此处有bug 或者要优化 列如下
                    
                    //取出登陆后的token
                    guard let tokenData = dic["data"] as? NSDictionary else {
                        return
                    }
                    
                    let token = tokenData["token"] as! String

                    
                    //获取登陆个人信息
//                    print((dic["data"] as! NSDictionary)["address"] as! NSDictionary)
//                    print((dic["data"] as! NSDictionary)["user"] as! NSDictionary)
                    
                    
                    guard let list = (dic["data"] as? NSDictionary)?["user"] as? NSDictionary else {
                        return
                    }
                    
                    //改变单例的值
                    PersonInfoModel.shared.nickName = list["nickname"] as? String
                    
                    if let headUrl = list["img"] as? String {
                        PersonInfoModel.shared.personImg = "http://" + comStrURL + headUrl
                    }
                    
                    PersonInfoModel.shared.bindPhone = list["password"] as? String
                    
                    PersonInfoModel.shared.jifen = list["integral"] as? String
                    
                    //存入本地
                    localSave.set(list, forKey: thirdLoginInfo)
                    localSave.synchronize()
                    
                    //list数组为空，就返回
                    if list.count == 0 {
                        return
                    }
                    
//                    let wxImg = list["img"] as! String
                    
                    
                    let wxNickName = list["nickname"] as! String
                    
                    //赋值给内存对应的id
                    _uName = wxNickName
                    
                    
                    //将token存入本地,图片地址存入本地
                    localSave.set(token, forKey: userToken)
                    localSave.set(wxNickName, forKey: localName)
                    localSave.synchronize()
                    
                    
                    //收获信息
                    guard let addInfo = (dic["data"] as? NSDictionary)?["address"] as? NSDictionary else {
                        return
                    }
                    //存到模型
                    GetGoodModel.shared.addDic = addInfo
                    
                    //改变单例的值
                    GetGoodModel.shared.shrName = addInfo["shrname"] as? String
                    GetGoodModel.shared.area = addInfo["area"] as? String
                    GetGoodModel.shared.city = addInfo["city"] as? String
                    GetGoodModel.shared.province = addInfo["province"] as? String
                    GetGoodModel.shared.shrphone = addInfo["shrphone"] as? String
                    GetGoodModel.shared.street = addInfo["street"] as? String
                    
                    
                    //保存到个人模型
                    
                    LoginModel.shared.personData = list
                    
                    //写入本地，方便下次读取
                    localSave.set(list, forKey: personInfo)
                    localSave.set(addInfo, forKey: personAddData)
                    
                    localSave.synchronize()
                    
                    
//                    print(wxImg,wxNickName)
                    
                    //主控制器刷新并跳转到个人模块
                    let mainTabbarVC = MainViewController()
                    mainTabbarVC.mvc = MyVC()
                    
                    UIApplication.shared.keyWindow?.rootViewController = mainTabbarVC
                    
                    mainTabbarVC.selectedIndex = 3
                    
                } else {
                    CustomAlertView.shared.dissmiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        CustomAlertView.shared.alertWithTitle(strTitle: unKnown)
                    })
                }
                
                //闭包传值
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
            self.comfun!(error.localizedDescription)
            
            CustomAlertView.shared.dissmiss()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { 
                CustomAlertView.shared.alertWithTitle(strTitle: netWrong)
            })

        })
        
    }
    
    func loginWithLocal() -> Void {

        ///获取微信open id
//        let wxopenID = thirdOpenID
//        
//        ///获取微信头像地址
//        let wxHeadImgURL = thirdHeadImgURL
//        
//        ///微信昵称
//        let wxNickName = thirdNickName
        
        guard let wxopenID = localSave.object(forKey: wid) as? String else {
            return
        }
        
        guard let wxHeadImgURL = localSave.object(forKey: wHUrl) as? String else {
            return
        }
        
        guard let wxNickName = localSave.object(forKey: wNickName) as? String else {
            return
        }
        
        
        
        
        
        let param = ["deviceid" : deviceID,
                     "devtype" : deviceTpye,
                     "openid" : wxopenID,
                     "platform" : 2,
                     "headimg" : wxHeadImgURL,
                     "nickname" : wxNickName,] as [String :Any]
        
//        
//        print(param)
        
        postWithPath(path: oauthURL, paras: param, success: { (response) in
            
            
            guard let dic = response as? NSDictionary else {
                return
            }
            
            //XFLog(message: dic)
            
            //提取提示语
            let alertmsg = dic["resultmsg"] as! String
            
            if alertmsg == "授权成功" {
                
                //清除URL保存的值
                mainIndexArray.removeAllObjects()
                fwqArray.removeAllObjects()
                commuArray.removeAllObjects()
                shoppingCarArray.removeAllObjects()
                jiaoYIArray.removeAllObjects()
                zhongjiangArray.removeAllObjects()
                duihuanArray.removeAllObjects()
                fenxiangArray.removeAllObjects()

                //FIXME: 表示此处有bug 或者要优化 列如下
                
                //取出登陆后的token
                guard let tokenData = dic["data"] as? NSDictionary else {
                    return
                }
                
                let token = tokenData["token"] as! String

                
                //获取登陆个人信息
//                print((dic["data"] as! NSDictionary)["address"] as! NSDictionary)
//                print((dic["data"] as! NSDictionary)["user"] as! NSDictionary)
                
                
                guard let list = (dic["data"] as? NSDictionary)?["user"] as? NSDictionary else {
                    return
                }
                
                //改变单例的值
                PersonInfoModel.shared.nickName = list["nickname"] as? String
                
                if let headUrl = list["img"] as? String {
                    PersonInfoModel.shared.personImg = "http://" + comStrURL + headUrl
                }
                
                PersonInfoModel.shared.bindPhone = list["password"] as? String
                
                PersonInfoModel.shared.jifen = list["integral"] as? String
                
                //存入本地
                localSave.set(list, forKey: thirdLoginInfo)
                localSave.synchronize()
                
                //list数组为空，就返回
                if list.count == 0 {
                    return
                }
                
//                let wxImg = list["img"] as! String
                
                
                let wxNickName = list["nickname"] as! String
                
                //赋值给内存对应的id
                _uName = wxNickName
                
                
                //将token存入本地,图片地址存入本地
                localSave.set(token, forKey: userToken)
                localSave.set(wxNickName, forKey: localName)
                localSave.synchronize()
                
                
                //收获信息
                guard let addInfo = (dic["data"] as? NSDictionary)?["address"] as? NSDictionary else {
                    return
                }
                //存到模型
                GetGoodModel.shared.addDic = addInfo
                
                //改变单例的值
                GetGoodModel.shared.shrName = addInfo["shrname"] as? String
                GetGoodModel.shared.area = addInfo["area"] as? String
                GetGoodModel.shared.city = addInfo["city"] as? String
                GetGoodModel.shared.province = addInfo["province"] as? String
                GetGoodModel.shared.shrphone = addInfo["shrphone"] as? String
                GetGoodModel.shared.street = addInfo["street"] as? String
                
                
                //保存到个人模型
                
                LoginModel.shared.personData = list
                
                //写入本地，方便下次读取
                localSave.set(list, forKey: personInfo)
                localSave.set(addInfo, forKey: personAddData)
                
                localSave.synchronize()
                
                
//                print(wxImg,wxNickName)

            }
        
            
        }, failure: { (error) in

        })
        
    }
}


