//
//  LoginAfterSygn.swift
//  Alili
//
//  Created by 郑东喜 on 2016/12/22.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  在信息上传后同步登陆消息

import UIKit

class LoginAfterSygn: NSObject {
    static let shared = LoginAfterSygn()
    
    func loginSygn() -> Void {
        
        //微信同步数据
        if thirdOpenID.characters.count != 0 {
            WXLogin.shared.loginWithLocal()
        } else if localSave.object(forKey: wid) != nil && localSave.object(forKey: wNickName) != nil && localSave.object(forKey: wHUrl) != nil {
            WXLogin.shared.loginWithLocal()
        }
        
        
        //QQ同步数据
        if thirdNickName.characters.count != 0{
            QQLogin.shared.loginWithLocal()
        } else if localSave.object(forKey: qid) != nil && localSave.object(forKey: qNickName) != nil && localSave.object(forKey: qHUrl) != nil {
            QQLogin.shared.loginWithLocal()
            
        } else {
            
            //取出本地用户名。密码
            guard let pass = localSave.object(forKey: localPass) as? String else {
                return
            }
            
            guard let uname = localSave.object(forKey: localName) as? String else {
                return
            }
            
            LoginModel.shared.loginWithLocalInfo(tfNum: uname, tfPass: pass) { (result) in
                
            }
            
        }
        
        //若运存中接收到的微信的值不为空，则进行登陆
//        print("thirdOpenID.characters.count",thirdOpenID.characters.count)
//        

    }
}


