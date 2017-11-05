//
//  QQLogin.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/13.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  qq登陆方法

import UIKit

class QQLogin: NSObject {
    static let shared = QQLogin()
    
    //闭包传值
    var comfun:((_ _data : String) -> Void)?
    
    
    /**
     ## qq第三方登陆功能
     实现QQ第三方登陆监听流程
     */
    
    func qqLogin(_com:@escaping (_ _data:String)->Void) -> Void {
        self.comfun = _com
        
        ///获取QQopen id
        let qqopenID = thirdOpenID
        
        ///获取QQ头像地址
        let qqHeadImgURL = thirdHeadImgURL
        
        ///QQ昵称
        var qqNickName = thirdNickName
        
        //若为空,则昵称传“未知”
        if qqNickName == "" {
            qqNickName = "未知"
        }

        //XFLog(message: "QQopenID",file: qqopenID)
        //XFLog(message: "QQ头像地址",file: qqHeadImgURL)
        //XFLog(message: "QQ昵称",file: qqNickName)
        
        let param = ["deviceid" : deviceID,
                     "devtype" : deviceTpye,
                     "openid" : qqopenID,
                     "platform" : 0,
                     "headimg" : qqHeadImgURL,
                     "nickname" : qqNickName,] as [String :Any]

        //XFLog(message: param)
        
//        CustomAlertView.shared.alertWithIndicator(strTitle: "授权登录中...")

        
        /**
         ## 授权请求

         - path    请求地址
         - param   请求参数
         - success   成功返回
         - fail   失败返回
         */
        postWithPath(path: oauthURL, paras: param, success: { (response) in
            
            guard let dic = response as? NSDictionary else {
                return
            }

//            //XFLog(message: dic)
            //提取提示语
            let resultcode = dic["resultcode"] as! String
            
            //返回正确
            if resultcode == "0" {
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
                    
//                    CustomAlertView.shared.dissmiss()
                    
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        CustomAlertView.shared.alertWithTitle(strTitle: authSuccess)
//                    })
                    
                    
                    //取出登陆后的token
                    guard let tokenData = dic["data"] as? NSDictionary else {
                        return
                    }
                    
                    let token = tokenData["token"] as! String

                    //XFLog(message: "token",file: token)
                    
//                    //获取登陆个人信息
//                    print((dic["data"] as! NSDictionary)["address"] as! NSDictionary)
//                    print((dic["data"] as! NSDictionary)["user"] as! NSDictionary)
//                    
                    //个人信息
                    guard let list = (dic["data"] as? NSDictionary)?["user"] as? NSDictionary else {
                        return
                    }

//                    //XFLog(message: list)
                    
                    //改变单例的值
                    PersonInfoModel.shared.nickName = list["nickname"] as? String
                    
                    if let headUrl = list["img"] as? String {
                        PersonInfoModel.shared.personImg = headUrl
                    }
                    
                    PersonInfoModel.shared.bindPhone = list["password"] as? String
                    
                    PersonInfoModel.shared.jifen = list["integral"] as? String
                    
                    
                    //存入本地--第三方登陆授权返回信息
                    localSave.set(list, forKey: thirdLoginInfo)
                    localSave.synchronize()
                    
                    //list数组为空，就返回
                    if list.count == 0 {
                        return
                    }

                    
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
                    
                    
                    //刷新跟控制器跳转到个人中心
                    let mainTabVC = MainViewController()
                    mainTabVC.mvc = MyVC()
                    UIApplication.shared.keyWindow?.rootViewController = mainTabVC
                    
                    mainTabVC.selectedIndex = 3
                } else {
                    CustomAlertView.shared.dissmiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        CustomAlertView.shared.alertWithTitle(strTitle: unKnown)
                    })
                }
                
                //闭包传值
                self.comfun!(alertmsg)

            } else {

                let alMsg = dicc[resultcode]
                
                if resultcode == "40107" {
                    CustomAlertView.shared.dissmiss()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                        
                        //刷新猪控制器
                        CustomAlertView.shared.closeWithAlert(strTitle: loginError, test: {
                            let nav = NaVC.init(rootViewController: LoginView())
                            UIApplication.shared.keyWindow?.rootViewController = nav                        })
                    }
                    
                } else {
                    CustomAlertView.shared.dissmiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        CustomAlertView.shared.alertWithTitle(strTitle: alMsg!)
                    })
                }
            }
            
        }, failure: { (error) in
            
            //返回网络错误信息
            self.comfun!(error.localizedDescription)
            
            CustomAlertView.shared.dissmiss()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                CustomAlertView.shared.alertWithTitle(strTitle: netWrong)
            })
            
        })
    }
    
    
    /// 当app在运行期间更新资料成功后，重新请求调用次方法，同步信息
    func loginWithLocal() -> Void {
        
        
//        ///获取QQopen id
//        let qqopenID = thirdOpenID
//        
//        ///获取QQ头像地址
//        let qqHeadImgURL = thirdHeadImgURL
//        
//        ///QQ昵称
//        var qqNickName = thirdNickName
        
        guard let qqopenID = localSave.object(forKey: qid) as? String else {
            return
        }
        
        guard let qqHeadImgURL = localSave.object(forKey: qHUrl) as? String else {
            return
        }
        
        guard var qqNickName = localSave.object(forKey: qNickName) as? String else {
            return
        }
        
        
        
        //若为空,则昵称传“未知”
        if qqNickName == "" {
            qqNickName = "未知"
        }

        //XFLog(message: "QQopenID",file: qqopenID)
        //XFLog(message: "QQ头像地址",file: qqHeadImgURL)
        //XFLog(message: "QQ昵称",file: qqNickName)
        
        
        let param = ["deviceid" : deviceID,
                     "devtype" : deviceTpye,
                     "openid" : qqopenID,
                     "platform" : 0,
                     "headimg" : qqHeadImgURL,
                     "nickname" : qqNickName,] as [String :Any]

        //XFLog(message: param)
        
        postWithPath(path: oauthURL, paras: param, success: { (response) in

            guard let dic = response as? NSDictionary else {
                return
            }
            
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
                
                //取出登陆后的token
                guard let tokenData = dic["data"] as? NSDictionary else {
                    return
                }
                
                
                //提取提示语
                let resultCode = dic["resultcode"] as! String

                if resultCode == "0" {
                    let token = tokenData["token"] as! String

                    
                    guard let list = (dic["data"] as? NSDictionary)?["user"] as? NSDictionary else {
                        return
                    }
                    
                    //改变单例的值
                    PersonInfoModel.shared.nickName = list["nickname"] as? String
                    
                    if let headUrl = list["img"] as? String {
                        PersonInfoModel.shared.personImg =  headUrl
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
                    
                    
                } else {

                    let alMsg = dicc[resultCode]
                    
                    if resultCode == "40107" {
                        CustomAlertView.shared.dissmiss()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                            
                            //刷新猪控制器
                            CustomAlertView.shared.closeWithAlert(strTitle: loginError, test: {
                                let nav = NaVC.init(rootViewController: LoginView())
                                UIApplication.shared.keyWindow?.rootViewController = nav
                            })
                        }
                        
                    } else {
                        CustomAlertView.shared.dissmiss()

                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            CustomAlertView.shared.alertWithTitle(strTitle: alMsg!)
                        })
                    }
                    

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


