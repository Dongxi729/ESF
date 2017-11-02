//
//  MyVC.swift
//  MD5
//
//  Created by 郑东喜 on 2016/11/25.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  我的模块

import UIKit

import WebKit

class MyVC: BaseViewController,MyViewheaderViewDelegate,MyViewCellDelegate,loginViewDelegate,SettingViewControllerDelegate,LoginUpViewDelegate {
    
    static let shared = MyVC()
    
    //头部视图
    var headerView = MyViewheaderView()
    
    //滑动视图
    var sc = UIScrollView()
    
    //登陆滑动视图
    var loginSc = UIScrollView()
    
    /// 刷新视图
    var v = RefreshView()
    
    
    //视图消失时，还原导航栏
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //隐藏导航栏
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    //视图将要出现时的操作
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        if SH == 812 {
            
            
            self.navigationController?.navigationBar.isHidden = true
            
            ///状态栏背景色
            self.navigationController?.navigationBar.barTintColor = commonBtnColor
            
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            UIApplication.shared.statusBarStyle = .lightContent
            
        } else {
            
            //隐藏导航栏
            self.navigationController?.navigationBar.isHidden = true
        }
        
        
        ///清空数组
        fwqArray.removeAllObjects()
        jiaoYIArray.removeAllObjects()
        
        //背景颜色
        view.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        
        
        if (localSave.object(forKey: userToken) != nil) {
            
            self.navigationItem.title = "我的"
            
            MyAccountModel.shared.getAccout(_com: { (ss) in
                
            })
            
            
            
            
            
            //设置导航栏背景颜色透明
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            
            //若单例中没有值，则从缓存字典中取值
            if PersonInfoModel.shared.personImg != nil {
                let headURL = PersonInfoModel.shared.personImg
                
                //默认从缓存加载，若缓存为空，则从单例的地址
                if localSave.object(forKey: headImgCache) != nil {
                    let imgData = localSave.object(forKey: headImgCache) as! Data
                    
                    self.headerView.headImg.image = UIImage.init(data: imgData as Data)
                } else {
                    DispatchQueue.main.async {
                        CCog(message: headURL)
                        if headURL?.characters.count == 0 {
                            self.headerView.headImg.image = #imageLiteral(resourceName: "nav_5")
                        } else {
                            DownImgTool.shared.downImgWithURLShowToImg(urlStr: headURL!, imgView: self.headerView.headImg)
                        }
                    }
                }
            }
            
            
            //单例获取值
            if PersonInfoModel.shared.nickName != nil {
                headerView.nickName.text = PersonInfoModel.shared.nickName
                
            } else {
                
                //若用户状态为登陆，则不重新再加载我的界面视图，否则导致页面滞留，不滑动
                if LoginModel.shared.loginStatus == "true" {
                    //若当前页面的宽度不为0（已经加载过了），就不执行操作，否则加载视图
                    if sc.frame.width != 0 {
                        
                        return
                        
                    } else {
                        setUI()
                    }
                }
            }
            
        } else {
            
            
            //用户token为空。设置未登录视图
            setUnloginView()
            
            let alertView = UIAlertController.init(title: "提示", message: "请登录", preferredStyle: .alert)
            alertView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (nil) in
                
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
            }))
            
            alertView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (nil) in
                //设置状态栏颜色
                self.navigationController?.navigationBar.barTintColor = UIColor.white
                
                //文字颜色
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
                
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(LoginView(), animated: true)
                self.hidesBottomBarWhenPushed = false
            }))
            
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //取出本地token，进行拼接
        if (localSave.object(forKey: userToken) != nil) {
            
            //加载购物车链接
            setUI()
            
            //找不到token,提示用户登陆
        } else {
            let alertView = UIAlertController.init(title: "提示", message: "请登录", preferredStyle: .alert)
            alertView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            
            alertView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (nil) in
                
                self.navigationController?.pushViewController(LoginView(), animated: true)
            }))
            
        }
    }
    
}



//设置登陆好的我的信息界面
extension MyVC {
    /// 主界面
    func setUI() -> Void {
        
        sc = UIScrollView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20))
        sc.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
        //不允许滚
        sc.isScrollEnabled = false
        sc.showsVerticalScrollIndicator = false
        
        view.addSubview(sc)
        
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
        
        //加载上面的view
        headerView = MyViewheaderView()
        headerView.delegate = self
        
        if SH == 812 {
            headerView.frame = CGRect(x: 0, y: -24, width: UIScreen.main.bounds.width, height: 240 - 60 + 44)
        } else {
            
            headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 240 - 60)
        }
        
        sc.addSubview(headerView)
        
        //尾部视图
        let footerView = MyViewCell()
        
        footerView.frame = CGRect(x: 0, y: self.headerView.BottomY + 10, width: UIScreen.main.bounds.width, height: 270 - 60)
        
        
        footerView.delegate = self
        sc.addSubview(footerView)
    }
}

extension MyVC {
    func setRefreshPosition() -> Void {
        //重新登陆操作
        LoginAfterSygn.shared.loginSygn()
        
        v = RefreshView()
        v.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
        v.layer.cornerRadius = 5
        view.addSubview(v)
        
        v.setUI(labStr: "更新个人资料成功")
    }
}


// MARK:- 接收代理
extension MyVC {
    
    /// 积分
    func jumpToAccout() {
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(AccountTableViewController(), animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    
    /// 交易管理
    func cellOne() {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ChangedRecordVC(), animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    /// 收货地址
    func cellTwo() {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(DetailAddressVC(), animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
    /// 帮助中心
    func cellThree() {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ServiceViewController(), animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    /// 设置
    func cellFour() {
        
        self.hidesBottomBarWhenPushed = true
        
        let setVC = SettingViewController()
        //        setVC.delegate = self
        self.navigationController?.pushViewController(setVC, animated: true)
        
        self.hidesBottomBarWhenPushed = false
    }
    
}

// MARK:- 接收代理方法
extension MyVC {
    //登陆成功
    func logSuccess() {
        
    }
    
    //关闭登陆视图后，回调本身
    func closeSelf() {
        setUI()
    }
    
    //退出成功后，是在弹出登陆视图
    func back() {
        self.navigationController?.pushViewController(LoginView(), animated: true)
        //        UIApplication.shared.keyWindow?.rootViewController = LoginView()
    }
    
    /// 单机登陆
    func tapToLogin() {
        let lv = LoginView()
        self.present(lv, animated: true, completion: nil)
    }
    
    
    
    func logSuc() {
        
    }
    
    func logSE() {
        
    }
    
    func rigSEL() {
        
    }
    
    func forSEL() {
        
    }
}

// MARK:- 未登录视图
extension MyVC {
    func setUnloginView() -> Void {
        
        self.navigationItem.title = "首页"
        
        //设置状态栏颜色
        self.navigationController?.navigationBar.barTintColor = commonBtnColor
        
        //文字颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let webView = WKWebView()
        webView.frame = view.bounds
        
        
        //加载本地索引为0的缓存
        let urlStr = "http://\(comStrURL)/app/index.aspx?devtype=1"
        
        //判断是否包含域名
        if urlStr.contains(comStrURL) {
            ///大小布局和首页一致
            let url1 = URL.init(string: urlStr)
            let urlRequestCache = NSURLRequest(url: url1!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
            
            webView.load(urlRequestCache as URLRequest)
            
            let compassView : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SW, height: 20))
            compassView.backgroundColor = commonBtnColor
            view.addSubview(compassView)
            self.navigationController?.navigationBar.isHidden = true
            
            webView.frame = CGRect.init(x: 0, y: 20, width: SW, height: SH + 20)
            
        } else {
            return
        }
        
        view.addSubview(webView)
    }
}

// MARK:- cell代理实现
extension MyVC {
    ///待付款 -- JiaoYIVC
    func jumpTopay() {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ChangedRecordVC(), animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    ///待发货 -- 调到指定的子页面JS交互
    func jumpTosend() {
        //XFLog(message: "待发货")
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ChangedRecordVC(), animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
