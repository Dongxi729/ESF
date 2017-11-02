//
//  LoginDownView.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/17.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  登陆页面下半部分uiview自定义

import UIKit

//代理
protocol LoginDownViewDelegate {
    ///微信代理事件
    func wxloginSEL()
    
    ///QQ代理事件
    func qqLoginSEL()
}


class LoginDownView: UIView,WXApiDelegate,WXToolDelegate {
    /// 支付成功
    internal func paySuccess() {
        
    }

    /// 支付失败
    internal func payFail() {
        
    }

    /// 用户退出支付
    internal func payExit() {
        
    }

    var wxImg = UIImageView()
    
    // MARK:- 微信未安装的视图，只显示一个图标外加手势事件
    fileprivate lazy var qqUnImg: UIImageView = {
        let qq : UIImageView = UIImageView.init(frame: CGRect.init(x: (self.bounds.width - self.bounds.width * 0.15) * 0.5, y: 0 , width: self.bounds.width * 0.15, height: self.bounds.width * 0.15))
        qq.isUserInteractionEnabled = true
        qq.contentMode = .scaleAspectFit
        qq.image = UIImage.init(named: "qq")
        let getTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(clickQQImgSEL))
        qq.addGestureRecognizer(getTap)
        return qq
    }()
    
    //QQ单独时的Label 
    lazy var unQQLabel: UILabel = {
        let qqUILabel : UILabel = UILabel.init(frame: CGRect.init(x: 0, y: self.qqUnImg.BottomY + 10, width: SW, height: 20))
        qqUILabel.textColor = UIColor.lightGray
        qqUILabel.textAlignment = .center
        qqUILabel.font = UIFont.systemFont(ofSize: 14)
        qqUILabel.text = "QQ登录"
        return qqUILabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        if WXApi.isWXAppInstalled() == true {
            // MARK:- 左边微信登陆视图
            self.leftView()
            // MARK:- 左边微信登陆视图
            self.rightView()
//        } else {
//            self.addSubview(qqUnImg)
//            self.addSubview(unQQLabel)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置代理监听按钮事件
    var delegate : LoginDownViewDelegate?
}




// MARK:- 左边微信登陆视图
extension LoginDownView {
    func leftView() -> Void {
        //左边微信登陆视图
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width * 0.5, height: self.bounds.height * 0.5))
        
        self.addSubview(leftView)
        
        //微信按钮
        let btnW = leftView.frame.size.width * 0.3

        
        //分开搞，图片加label
        wxImg = UIImageView.init(frame: CGRect(x: leftView.frame.size.width * 0.3, y: leftView.frame.size.height * 0.5 - btnW * 0.3, width: leftView.Width * 0.3, height: leftView.Width * 0.3))
        wxImg.center = leftView.center
        
        wxImg.image = UIImage.init(named: "wx")
        wxImg.contentMode = .scaleAspectFit
        
        //文本
        let wxDesc = UILabel.init(frame: CGRect(x:0, y: wxImg.BottomY + 10, width: leftView.Width, height: 20))
        wxDesc.font = UIFont.systemFont(ofSize: 14)
        wxDesc.textColor = UIColor.lightGray
        
        
        //打开交互手势
        wxImg.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(LoginDownView.clickWXImgSEL))
        wxImg.addGestureRecognizer(tapGes)
        
        wxDesc.text = "微信登录"
        wxDesc.textAlignment = .center
        
        leftView.addSubview(wxImg)
        leftView.addSubview(wxDesc)

    }
}


// MARK:- 左边微信登陆视图
extension LoginDownView {
    func rightView() -> Void {
        //右边QQ登陆视图
        let rightView = UIView(frame: CGRect(x: SW * 0.5, y: 0, width:self.bounds.width * 0.5, height: self.bounds.height * 0.5))
        
        self.addSubview(rightView)

        //微信按钮
        let btnW = rightView.frame.size.width * 0.3
        
        
        //分开搞，图片加label
        let qqImg = UIImageView.init(frame: CGRect(x: rightView.frame.size.width * 0.5 - rightView.Width * 0.15 , y: rightView.frame.size.height * 0.5 - btnW * 0.3 - btnW * 0.15 , width: rightView.Width * 0.3, height: rightView.Width * 0.3))

        qqImg.image = UIImage.init(named: "qq")
        qqImg.contentMode = .scaleAspectFit
        
        //文本
        let qqDesc = UILabel.init(frame: CGRect(x:0, y: qqImg.BottomY + 10, width: rightView.Width, height: 20))
        qqDesc.font = UIFont.systemFont(ofSize: 14)
        qqDesc.textColor = UIColor.lightGray
        
        
        //打开交互手势
        qqImg.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(LoginDownView.clickQQImgSEL))
        qqImg.addGestureRecognizer(tapGes)
        
        qqDesc.text = "QQ登录"
        qqDesc.textAlignment = .center
        
        rightView.addSubview(qqImg)
        rightView.addSubview(qqDesc)


    }
}

// MARK:- 单机事件
extension LoginDownView {
    //微信
    @objc func clickWXImgSEL() -> Void {

        //XFLog(message: "微信")
        
        
        if WXApi.isWXAppInstalled() == false {

            let req = SendAuthReq()

            let kAuthScope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
            let kAutoOpenID = "0c806938e2413ce73eef92cc3"
            let kAuthState = "xxx"

            req.scope = kAuthScope
            req.state = kAuthState
            req.openID = kAutoOpenID
            WXApi.sendAuthReq(req, viewController: UIApplication.shared.keyWindow?.rootViewController, delegate: self)

            
        } else {
            delegate?.wxloginSEL()
        }

    }
    
    //QQ
    @objc func clickQQImgSEL() -> Void {
        //XFLog(message: "QQ")

        delegate?.qqLoginSEL()
    }
}

extension LoginDownView {
    //微信登陆成功回调
    func WXLoginCallBack() {
//        self.dismiss()
        
//        self.navigationController!.popToRootViewController(animated: true)
        print("\((#file as NSString).lastPathComponent):(\(#line))\n")
        
    }
}


