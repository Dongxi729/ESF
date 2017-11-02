//
//  LoginView.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/21.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  登陆主控制器

import UIKit


protocol loginViewDelegate {
    //改变导航栏标题
    func logSuccess()

    //关闭当前视图
    func closeSelf()
}

class LoginView: TableBaseViewController,LoginUpViewDelegate,LoginDownViewDelegate,QQToolDelegate,WXToolDelegate,TableDelegate {
    /// 支付失败
    internal func payFail() {
        
    }

    /// 用户退出支付
    internal func payExit() {
        
    }

    /// 支付成功
    internal func paySuccess() {
        
    }
    
    var delegate : loginViewDelegate?
    
    //QQ工具类
    let qqT = QQTool()
    
    //微信工具类
    let wxT = WXTool()
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //文字颜色
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.black]
        
        UIApplication.shared.statusBarStyle = .default
        
        let btnn = UIButton()
        btnn.frame = CGRect(x: 15, y: 64, width: 20, height: 20)
        
        btnn.addTarget(self, action:#selector(self.fooButtonTapped), for: .touchUpInside)

        btnn.setBackgroundImage(UIImage.init(named: "close"), for: .normal)
        btnn.setBackgroundImage(UIImage.init(named: "close"), for: .highlighted)

        
        let rightFooBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(customView: btnn)
        
        //显示左上角图标
        self.navigationItem.setLeftBarButton(rightFooBarButtonItem, animated: true)

        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "登录"
        
        //继承基础类的代理
        self.t_delegate = self
        
        //取消返回手势,防止用户不小心返回页面，输入的个人信息丢失
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    
    //页面结束后，恢复左滑手势
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    
    deinit {
    
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "123"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //标题
        let centerTitle = UILabel()
        centerTitle.frame = CGRect(x: 0, y: 25, width: UIScreen.main.bounds.width, height: 30)
//        centerTitle.backgroundColor = UIColor.red
        centerTitle.font = UIFont.boldSystemFont(ofSize: 16)
        
        centerTitle.text = "登陆"
        centerTitle.textAlignment = NSTextAlignment.center
        
        setUpView()
        setDownView()

        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    //关闭当前视图
    func dismiss() -> Void {
        delegate?.closeSelf()
        
        self.dismiss(animated: true, completion: nil)
        
    }

}



extension LoginView {
    func setUpView() -> Void {
        
        let upView = LoginUpView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.55 ))
        
        //判断机型
        let deviceType = UIDevice.current.deviceType

        switch deviceType {
        case .iPhone4S:

            upView.frame = CGRect(x: 0, y: -40, width: SW, height: SH * 0.5)
            break
        default:

            break
        }
        
        //监听代理
        upView.delegate = self
        
        view.addSubview(upView)
    }
    
    func setDownView() -> Void {
        //
        let downView = LoginDownView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.6, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45 - 64))
        
        //判断机型
        let deviceType = UIDevice.current.deviceType
        
        switch deviceType {
        case .iPhone4S:
            
            downView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.6, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5 - 64)
            break
        default:
            break
        }
        
        //监听代理
        downView.delegate = self
        
        view.addSubview(downView)
    }
}

// MARK:- 监听代理
extension LoginView {
    //注册事件
    func rigSEL() {
        self.hidesBottomBarWhenPushed = true
         self.navigationController?.pushViewController(RigisterViewController(), animated: true)
    }
    
    //忘记密码事件
    func forSEL() {

        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ForgerPassViewController(), animated: true)
    }
    
    ///QQ代理事件
    func qqLoginSEL() {
        qqT.qqLogin()
        qqT.delegate = self
        
    }
    ///微信登陆
    func wxloginSEL() {
//        wxT.clickAuto()
        
        wxT.clickAuto { (result) in
            if result == "授权成功" {
            }
        }
        wxT.delegate = self
        
    }
    
    ///登陆事件
    func logSE() {
        
    }
    
    func logSuc() {

        self.dismiss()

    }
    
}


extension LoginView {
    func qqLoginCallBack() {
        
        
        self.dismiss()
        self.navigationController!.popToRootViewController(animated: true)

    }
    
    //微信登陆成功回调
    func WXLoginCallBack() {
        self.dismiss()
        
        self.navigationController!.popToRootViewController(animated: true)

    }

}

// MARK:- 实现基类的方法
extension LoginView {
    func click() {

        
        //清除URL保存的值
        mainIndexArray.removeAllObjects()
        fwqArray.removeAllObjects()
        commuArray.removeAllObjects()
        shoppingCarArray.removeAllObjects()
        jiaoYIArray.removeAllObjects()
        zhongjiangArray.removeAllObjects()
        duihuanArray.removeAllObjects()
        fenxiangArray.removeAllObjects()
        

        let mainVC = MainViewController()
        
        UIApplication.shared.keyWindow?.rootViewController = mainVC
        
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 0
    }
    
}
