//
//  WKBaseViewController.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/12/9.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  WKWebView基础类

import UIKit
import WebKit

import CoreTelephony

var _symbolForH5chosssedef : String = "false"

var shopList : String?


/// 当用户留言完毕后，出发此函数，跳转至交流区最初页面
protocol WKBaseDelegate {
    func server()
}

class WKBaseViewController: BaseViewController,WKNavigationDelegate,WKUIDelegate,ShareVCDelegate,WKScriptMessageHandler,UIScrollViewDelegate {
    
    var replaceView : UIView = UIView()
    
    var webView: WKWebView!
    
    //修补所用的view
    var compassView : UIView = UIView()
    
    static let shared = WKBaseViewController()
    
    // MARK:- 全局链接变量
    var url : String = ""
    
    // MARK:- 为网络状态
    var netStatus : String = ""
    
    // MARK:- 刷新控件
    var refreshControl = UIRefreshControl()
    // MARK:- 进度条
    var progressView = UIProgressView()
    
    // MARK:- 网络加载的路径
    var urlRequestCache = NSURLRequest()
    
    // MARK:- 分享变量
    var titleStr : String = ""
    var desc : String = ""
    var link : String = ""
    var imgURL : String = ""
    
    // MARK:- 检查刷新加载
    var situationMark = "loadFailed"
    
    // MARK:- 权限按钮
    let AutoCellularbtn = UIImageView()
    
    // MARK:- 刷新图片
    var imgView = UIImageView()
    
    // MARK:- token
    var token : String = ""
    
    // MARK:- 分享视图
    var viewController = ShareViewController()
    
    //代理
    var wkDelegate : WKBaseDelegate?
    
    /// 网络状态
    var netThrough = false
    
    // MARK: - 优惠券
    let userDefault = UserDefaults.standard
    var isLoadYHJ = false
    var loll = false
    var getCards : GetCardV!

    
    /// 断网图片单机刷新事件
    @objc func imgSEL() -> Void {
        
        //        view.addSubview(self.webView)
        //
        //        self.webView.load(self.urlRequestCache as URLRequest)
        
        if isLoded {
            self.webView.reload()
        } else {
            self.webView.load(URLRequest.init(url: URL.init(string: self.url)!))
        }
    }
    
    // MARK:- 移除蜂窝权限图片，界面消失的时候
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.imgView.isHidden = true
        AutoCellularbtn.removeFromSuperview()
        
    }
    
    deinit {
        
        XFLog(message: "销毁")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if #available(iOS 9.0, *) {
            
            let culluarData = CTCellularData()
            
            culluarData.cellularDataRestrictionDidUpdateNotifier = { (state : CTCellularDataRestrictedState) -> Void in
                
                ///网络受限
                if state.hashValue == 1 {
                    
                    DispatchQueue.main.async {
                        self.AutoCellularbtn.frame = CGRect(x:SW * 0.25 , y: SH * 0.25, width: SW * 0.5, height: SW * 0.5)
                        
                        self.AutoCellularbtn.image = UIImage.init(named: "sulution")
                        self.AutoCellularbtn.isUserInteractionEnabled = true
                        self.imgView.isHidden = true
                        
                        let soluGes = UITapGestureRecognizer.init(target: self, action: #selector(WKBaseViewController.gotoSet))
                        
                        self.AutoCellularbtn.addGestureRecognizer(soluGes)
                        
                        self.view.addSubview(self.AutoCellularbtn)
                        
                        return
                    }
                    
                    ///网络未受限
                } else {
                    //取出本地token，进行拼接,token为空不为空，均传到服务器
                    if (localSave.object(forKey: userToken) != nil) {
                        self.token = localSave.object(forKey: userToken) as! String
                        
                    } else {
                        self.token = ""
                    }
                    
                }
                
            }
            
        }
        
        
        //取出本地token，进行拼接,token为空不为空，均传到服务器
        if (localSave.object(forKey: userToken) != nil) {
            token = localSave.object(forKey: userToken) as! String
            
        } else {
            token = ""
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SETUI()
        
        lisetenNetChanged()
        
        self.imgView.frame = CGRect.init(x: 0, y: 0, width: SW * 0.35, height: SW * 0.35)
        self.imgView.center = view.center
        self.imgView.image = #imageLiteral(resourceName: "lostNet")
        let tag = UITapGestureRecognizer.init(target: self, action:#selector(WKBaseViewController.imgSEL))
        self.imgView.isUserInteractionEnabled = true
        self.imgView.addGestureRecognizer(tag)
        view.addSubview(imgView)
        self.imgView.isHidden = true
        
        
        if let navCount = self.navigationController?.viewControllers.count {
            
            if navCount > 1 {
                
                
                if SH == 812 {
                    self.webView.frame = CGRect.init(x: 0, y:20, width: SW, height: SH - (self.navigationController?.navigationBar.Height)! - (self.tabBarController?.tabBar.Height)!)
                }
            }
        }
    }
    
    @objc func lisetenNetChanged() {
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (sddd) in
            XFLog(message: sddd.rawValue)
            
            if sddd.rawValue == 0 {
                self.netThrough = false
                
                if self.url.characters.count != 0 {
                    
                    XFLog(message: self.url)
                    self.webView.load(URLRequest.init(url: URL.init(string: self.url)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 5.0))
                    self.webView.reload()
                } else {
                    self.navigationItem.title = "请检查网络"
                }
                
            } else {
                self.netThrough = true
            }
        }
        view.addSubview(compassView)
        if SH == 812 {
            
            compassView.alpha = 0
        }
    }
    
    // MARK:- 监听进度条值变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") { // listen to changes and updated view
            if self.webView == nil {
                return
            }
            
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    // MARK:- 网络开始请求
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let tababrVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
        
        if tababrVC?.selectedIndex == 0 && self.navigationController?.childViewControllers.count == 1 {
            self.progressView.frame = CGRect.init(x: 0, y: 64, width: SW, height: 10)
            self.replaceView.frame = CGRect.init(x: 0, y: 0, width: SW, height: 64)
            self.replaceView.backgroundColor = commonBtnColor
            
            self.view.addSubview(self.replaceView)
        }
        
        self.navigationItem.title = "正在加载中~~~"
        
        if self.webView == nil {
            self.SETUI()
            return
        } else {
            return
        }
        
        
    }
    
    // MARK:- wkwebview代理方法
    /// 没网络发起
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        CCog(message: NetStatusModel.netStatus)
        
        if NetStatusModel.netStatus == 0 {
            if let webTitle = webView.title {
                if webTitle.characters.count == 0 {
                    CCog()
                    self.imgView.isHidden = false
                }
            }
        }
        
        
        //赋值，表示失败，供刷新使用
        self.situationMark = "true"
        
        netStatus = "false"
        
        refreshControl.endRefreshing()
        
    }
    
    var isLoded  = false
    
    // MARK:- webview加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoded = true
        CCog(message: isLoded)
        
        
        self.imgView.isHidden = true
        
        UIView.animate(withDuration: 0.5) {
            
            if SH == 812 {
                XFLog(message: "")
                self.compassView.removeFromSuperview()
                self.compassView.frame = CGRect.init(x: 0, y: 0, width: SW, height: 44)
                self.view.addSubview(self.compassView)
                self.compassView.alpha = 1
            } else {
                self.compassView.removeFromSuperview()
                self.compassView.frame = CGRect.init(x: 0, y: 0, width: SW, height: 20)
                self.view.addSubview(self.compassView)
                self.compassView.alpha = 1
            }
        }
        
        
        let tababrVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
        
        if tababrVC?.selectedIndex == 0 && self.navigationController?.childViewControllers.count == 1 {
            
            self.replaceView.isHidden = true
        }
        
        refreshControl.endRefreshing()
    
        
        //改变刷新标识符
        self.situationMark = "false"
        
        netStatus = "true"
        
        self.progressView.progress = Float(webView.estimatedProgress)
        self.navigationItem.title = self.webView.title
        
        
        //走满进度条，停止选择
        if self.webView.isLoading == false {
            UIView.animate(withDuration: 0.5, animations: {
                self.progressView.alpha = 0
            })
        }
        
        /// 显示优惠券
        if NSStringFromClass(self.classForCoder).contains("MainPageViewController") {
            if let nav = navigationController?.viewControllers.count {
                if nav == 1 {
                    CCog()
                    loadYHJ()
                }
            }
        }
    }
    
    
    
    
    // MARK:- js交互
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let msg = message.name
        
        
        
        //微信分享
        if  msg == "shareWeixinInfo" {
            
            //将获取到的数据解析成字典
            let messageDic = message.body as! NSDictionary
            
            
            //解析取回的字典数据
            titleStr = messageDic["title"] as! String
            desc = messageDic["desc"] as! String
            link = messageDic["link"] as! String
            imgURL = messageDic["imgUrl"] as! String
            
            
            viewController = ShareViewController()
            viewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            viewController.delegate = self
            
            self.present(viewController, animated: true, completion: nil)
            
            
            
            //微信支付
        } else if msg == "wxpay" {
            
            
            
            let wxDic = message.body as! NSDictionary
            
            //XFLog(message: wxDic)
            
            
            ///微信支付
            WXTool.shared.sendWXPay(wxDict: wxDic, _com: { (result) in
                
                switch result {
                case "-2":
                    let vc = PayFailViewController()
                    vc.url = payFailURL
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                    
                case "0":
                    let vc = PaySuccessVC()
                    vc.url = paySuccessURL
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                    
                case "-1":
                    let vc = PayFailViewController()
                    vc.url = payFailURL
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                    
                default:
                    break
                }
                
                //清除URL保存的值
                mainIndexArray.removeAllObjects()
                fwqArray.removeAllObjects()
                commuArray.removeAllObjects()
                shoppingCarArray.removeAllObjects()
                jiaoYIArray.removeAllObjects()
                zhongjiangArray.removeAllObjects()
                duihuanArray.removeAllObjects()
                fenxiangArray.removeAllObjects()
                
            })
            
            
            ///支付宝
        } else if msg == "alipay" {
            let dic = message.body as! NSDictionary
            
            var signStr = ""
            
            if ((dic["sign"] as? String) != nil) {
                signStr = dic["sign"] as! String
            } else {
                //回调返回值处理
                return
            }
            
            //接收Web支付回调
            PaymenyModel.shared.alipay(orderString: signStr, comfun: { (result) in
                
                
                switch result {
                case "用户中途取消":
                    // FIXME: - 支付成功回调错误
                    let vc = PayFailViewController()
                    vc.url = payFailURL
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    break
                    
                case "网页支付成功":
                    
                    let vc = PaySuccessVC()
                    vc.url = paySuccessURL
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                    
                case "正在处理中":
                    CustomAlertView.shared.alertWithTitle(strTitle: "正在处理中")
                    break
                    
                case "网络连接出错":
                    CustomAlertView.shared.alertWithTitle(strTitle: "网络连接出错")
                    break
                    
                case "订单支付失败":
                    let vc = PayFailViewController()
                    vc.url = payFailURL
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                default:
                    break
                }
                
                
                //清除URL保存的值
                mainIndexArray.removeAllObjects()
                fwqArray.removeAllObjects()
                commuArray.removeAllObjects()
                shoppingCarArray.removeAllObjects()
                jiaoYIArray.removeAllObjects()
                zhongjiangArray.removeAllObjects()
                duihuanArray.removeAllObjects()
                fenxiangArray.removeAllObjects()
            })
            
            ///接收appdelegate代理传回的值
            NotificationCenter.default.addObserver(self, selector: #selector(WKBaseViewController.info(notification:)), name: NSNotification.Name(rawValue: "123"), object: nil)
            
        } else if msg == "gotoCart" {
            
            jumpToShop()
        } else if msg == "login" {
            
            self.navigationController?.pushViewController(LoginView(), animated: true)
            
        } else if msg == "submit" {
            
            self.wkDelegate?.server()
            
        } else if msg == "detailRocord" {
            
            jumpDetaiRecord()
            
        } else if msg == "backToMain" {
            
            backToMain()
            
            //调到购物车
        } else if msg == "getCartList" {
            
            shopList = message.body as? String
            
            
            ///选择地址
        } else if msg == "chooseAddress" {
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(chuangei(notification:)), name: NSNotification.Name(rawValue: "addressSet"), object: nil)
            
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(DetailAddressVC(), animated: true)
            
        } else if msg == "refreshWeb" {
            
            //XFLog(message: "刷新网页")
            self.webView.reload()
        } else if msg == "personInfo" {
            
            gotoPerson()
        } else if msg == "backToIndex" {
            gotoMain()
        } else if msg == "call" {
            XFLog(message: message.body)
            
            if let callStr = message.body as? String {
                self.call(callNum: callStr)
            }
        } else if msg == "payBack" {
            CCog(message: message.body)
            
            if let keyStr = message.body as? Int {
                keyPath = keyStr
                if keyStr == 1 {
                    
                    ExcuteWebModel.mark = keyStr
                    let btnn = UIButton()
                    btnn.frame = CGRect(x: 15, y: 64, width: 20, height: 20)
                    
                    btnn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
                    btnn.addTarget(self, action: #selector(orderObj), for: .touchUpInside)
                    self.rightFooBarButtonItem = UIBarButtonItem.init(customView: btnn)
                    self.navigationItem.setLeftBarButton(rightFooBarButtonItem, animated: true)
                }
            }
        }
    }
    
    
    private var keyPath : Int = 0
    
    @objc private func orderObj() {
        CCog(message: "===")
        self.webView.evaluateJavaScript("orderObj.mainPage() ", completionHandler: nil)
        let btnn = UIButton()
        btnn.frame = CGRect(x: 15, y: 64, width: 20, height: 20)
        
        btnn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        self.rightFooBarButtonItem = UIBarButtonItem.init(customView: btnn)
        self.navigationItem.setLeftBarButton(rightFooBarButtonItem, animated: true)
        btnn.addTarget(self, action:#selector(BaseViewController.fooButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func call(callNum :String) {
        let alettVC = ZDXAlertController.init(title: "", message:"是否拨打此电话 \(callNum)", preferredStyle: .alert)
        alettVC.addAction(UIAlertAction.init(title: "好的", style: .default, handler: { (action) in
            UIApplication.shared.openURL(URL.init(string: "tel:" + callNum)!)
        }))
        alettVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        navigationController?.present(alettVC, animated: true, completion: nil)
    }
    
    // MARK:- 收货地址@objc
    @objc func chuangei(notification : Notification) -> Void {
        
        let dic = notification.userInfo
        
        let _adrid = dic?["adrid"] as! String
        
        ///地址编号
        let yinhaoadrid = "\"" + _adrid + "\""
        
        ///名字
        let _name = dic?["name"] as! String
        let yinhaoname = "\"" + _name + "\""
        
        
        let _tel = dic?["tel"] as! String
        let yintel = "\"" + _tel + "\""
        
        
        let _area = dic?["area"] as! String
        let yinarea = "\"" + _area + "\""
        
        
        let _address = dic?["address"] as! String
        let yinaddress = "\"" + _address + "\""
        
        
        let jsonStr : NSString = "{\("\"adrid\"") : \(yinhaoadrid),\("\"name\"") : \(yinhaoname),\("\"tel\"") : \(yintel),\("\"area\"") : \(yinarea),\("\"address\"") : \(yinaddress)}" as NSString
        
        self.webView.evaluateJavaScript("addrCheck('\(jsonStr)')", completionHandler: nil)
        
        if self.navigationController == nil {
            return
        } else {
            
        }
        
        //地址收获的刷新标识
        _symbolForH5chosssedef = "true"
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addressSet"), object: nil)
    }
    
    
    // MARK:- 交互函数
    /// 返回首页
    func jumpDetaiRecord() -> Void {
        self.navigationController?.pushViewController(ChangedRecordVC(), animated: true)
    }
    
    // MARK:- 返回首页
    func backToMain() -> Void {
        self.webView = nil
        
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
        mainVC.mvc = LoginView()
        UIApplication.shared.keyWindow?.rootViewController = mainVC
    }
    
    // MARK:- 跳转到购物车页面
    func jumpToShop() -> Void {
        
        let mainVC = MainViewController()
        
        UIApplication.shared.keyWindow?.rootViewController = mainVC
        
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        
        
        tabBarController.selectedIndex = 2
        //移除先前存储的数组，以免跳转不正确
        shoppingCarArray.removeAllObjects()
        mainIndexArray.removeAllObjects()
    }
    
    // MARK:- 刷新函数
    @objc func refreshWebView(sender: UIRefreshControl) {
        
        if isLoded {
            self.webView.reload()
            sender.endRefreshing()
        } else {
            self.webView.load(URLRequest.init(url: URL.init(string: self.url)!))
            CCog(message: self.url)
            sender.endRefreshing()
        }
    }
}

// MARK:- 分享类型
extension WKBaseViewController {
    func shareType(__data: Int) {
        
        viewController.dismiss(animated: true, completion: nil)
        
        switch __data {
        case 100:
            
            if NetStatusModel.netStatus == 0 {
                MBManager.hideAlert()
                MBManager.showBriefAlert("请检查网络")
            } else {
                if QQApiInterface.isQQInstalled() == true {
                    MBManager.showBriefAlert("加载分享资源中...")
                    QQTool.shared.qqShare(title: self.titleStr, desc: self.desc, link: self.link, imgUrl: self.imgURL, type: QQApiURLTargetTypeAudio)
                } else {
                    MBManager.showBriefAlert("未安装QQ或版本不支持")
                }
            }
            
            
        case 101:
            
            if NetStatusModel.netStatus == 0 {
                
                MBManager.hideAlert()
                MBManager.showBriefAlert("请检查网络")
            } else {
                
                if QQApiInterface.isQQInstalled() == true {
                    MBManager.showBriefAlert("加载分享资源中...")
                    QQTool.shared.qqShare(title: self.titleStr, desc: self.desc, link: self.link, imgUrl: self.imgURL, type: QQApiURLTargetTypeAudio)
                } else {
                    MBManager.showBriefAlert("未安装QQ或版本不支持")
                }
            }
            
            if !netThrough {
                
                
            } else {
                
            }
            
        case 102:
            
            if NetStatusModel.netStatus == 0 {
                MBManager.hideAlert()
                MBManager.showBriefAlert("请检查网络")
                
            } else {
                if WXApi.isWXAppInstalled() == true {
                    MBManager.showBriefAlert("加载分享资源中...")
                    
                    WXTool.shared.shareText(title: self.titleStr, desc:self.desc, link: self.link, imgUrl: self.imgURL, shareType: 1)
                } else {
                    MBManager.showBriefAlert("未安装微信或版本不支持")
                }
            }
        case 103:
            if NetStatusModel.netStatus == 0 {
                MBManager.hideAlert()
                MBManager.showBriefAlert("请检查网络")
                
            } else {
                if WXApi.isWXAppInstalled() == true {
                    MBManager.showBriefAlert("加载分享资源中...")
                    
                    WXTool.shared.shareText(title: self.titleStr, desc:self.desc, link: self.link, imgUrl: self.imgURL, shareType: 0)
                } else {
                    MBManager.showBriefAlert("未安装微信或版本不支持")
                }
            }
        default:
            break
        }
    }
}

// MARK:- 处理收到内存警告---释放webview
extension WKBaseViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.webView = nil
    }
    
    
}

// MARK:- 购物车交互事件
extension WKBaseViewController {
    ///个人中心
    func gotoPerson() -> Void {
        let tabbarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        tabbarController.selectedIndex = 3
        
        
        Animated.vcWithTransiton(vc: tabbarController, animatedType: "kCATransitionFade", timeduration: 0.5)
    }
    
    ///前往首页
    func gotoMain() -> Void {
        let tabbarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        tabbarController.selectedIndex = 0
        
        Animated.vcWithTransiton(vc: tabbarController, animatedType: "kCATransitionFade", timeduration: 0.5)
    }
    
}

// MARK:- 接收支付宝app接收结果
extension WKBaseViewController {
    @objc func info(notification : NSNotification) -> Void {
        
        let dic = notification.userInfo as! [AnyHashable : NSObject] as NSDictionary
        
        let result = dic["re"] as! String
        
        switch result {
        case "用户中途取消":
            
            self.navigationController?.pushViewController(PayFailViewController(), animated: true)
            break
            
        case "支付成功":
            
            //清楚购物车信息
            shopList = nil
            self.navigationController?.pushViewController(PaySuccessVC(), animated: true)
            break
            
        case "正在处理中":
            CustomAlertView.shared.alertWithTitle(strTitle: "正在处理中")
            break
            
        case "网络连接出错":
            CustomAlertView.shared.alertWithTitle(strTitle: "网络连接出错")
            
            break
            
        case "订单支付失败":
            self.navigationController?.pushViewController(PayFailViewController(), animated: true)
            break
        default:
            break
        }
        
        //清除URL保存的值
        mainIndexArray.removeAllObjects()
        fwqArray.removeAllObjects()
        commuArray.removeAllObjects()
        shoppingCarArray.removeAllObjects()
        jiaoYIArray.removeAllObjects()
        zhongjiangArray.removeAllObjects()
        duihuanArray.removeAllObjects()
        fenxiangArray.removeAllObjects()
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "123"), object: nil)
    }
}

// MARK:- 解决蜂窝网受限
extension WKBaseViewController {
    @objc func gotoSet() -> Void {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(AutoSolVC(), animated: true)
    }
    
}

// MARK:- 设置webview
extension WKBaseViewController {
    @objc func setWebView() -> Void {
        self.webView = WKWebView.init(frame: self.view.bounds)
        view.addSubview(self.webView)
    }
}

// MARK:- 设置界面
extension WKBaseViewController {
    func SETUI() -> Void {
        // Do any additional setup after loading the view.
        
        
        self.setWebView()
        ///http://www.jianshu.com/p/879fe48b0eb7
        ///edgesForExtendedLayout------见网页链接
        self.edgesForExtendedLayout = UIRectEdge()
        
        //配置webview
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        //添加交互条目
        //分享到微信
        userContentController.add(self as WKScriptMessageHandler, name: "shareWeixinInfo")
        
        //微信支付
        userContentController.add(self as WKScriptMessageHandler, name: "wxpay")
        
        //支付宝支付
        userContentController.add(self as WKScriptMessageHandler, name: "alipay")
        //登陆
        userContentController.add(self as WKScriptMessageHandler, name: "login")
        
        //跳转到购物车
        userContentController.add(self as WKScriptMessageHandler, name: "gotoCart")
        
        //确认提交建议
        userContentController.add(self as WKScriptMessageHandler, name: "submit")
        
        //交易记录
        userContentController.add(self as WKScriptMessageHandler, name: "detailRocord")
        
        //返回首页
        userContentController.add(self as WKScriptMessageHandler, name: "backToMain")
        
        //购物车列表
        userContentController.add(self as WKScriptMessageHandler, name: "getCartList")
        
        ///选择地址
        userContentController.add(self as WKScriptMessageHandler, name: "chooseAddress")
        ///刷新网页 - refreshWeb
        userContentController.add(self as WKScriptMessageHandler, name: "refreshWeb")
        
        ///个人中心
        userContentController.add(self as WKScriptMessageHandler, name: "personInfo")
        ///随便逛逛（首页）
        userContentController.add(self as WKScriptMessageHandler, name: "backToIndex")
        
        /// 打电话
        userContentController.add(self as WKScriptMessageHandler, name: "call")
        
        
        ///  优惠券 payBack
        userContentController.add(self as WKScriptMessageHandler, name: "payBack")
        
        configuration.userContentController = userContentController
        
        // 设置偏好设置
        let preferences = WKPreferences()
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        preferences.javaScriptCanOpenWindowsAutomatically = true
        preferences.minimumFontSize = 10.0
        configuration.preferences = preferences
        configuration.preferences.javaScriptEnabled = true
        configuration.processPool = WKProcessPool()
        
        
        // 禁止选择CSS
        let css = "body{-webkit-user-select:none;-webkit-user-drag:none;}"
        
        // CSS选中样式取消
        let javascript = NSMutableString.init()
        
        javascript.append("var style = document.createElement('style');")
        javascript.append("style.type = 'text/css';")
        javascript.appendFormat("var cssContent = document.createTextNode('%@');", css)
        javascript.append("style.appendChild(cssContent);")
        javascript.append("document.body.appendChild(style);")
        
        
        // javascript注入
        let noneSelectScript = WKUserScript.init(source: javascript as String, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        userContentController.addUserScript(noneSelectScript)
        
        if let nav = self.navigationController?.viewControllers.count  {
            if nav >= 2 {
                let rect = CGRect(x: 0, y: 0, width: SW, height: SH - 64)
                webView = WKWebView.init(frame: rect, configuration: configuration)
            } else {
                let rect = CGRect(x: 0, y: 0, width: SW, height: SH - 112)
                
                webView = WKWebView.init(frame: rect, configuration: configuration)
                
            }
        }
        
        
        
        ///配置wkwebview代理
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.bounces = true
        
        //动画过度
        self.webView.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            self.webView.alpha = 1.0
        }
        view.addSubview(webView)
        
        //添加进度条
        self.progressView = UIProgressView()
        
        self.progressView.frame = view.bounds
        view.addSubview(self.progressView)
        
        //默认进度条
        self.progressView.progressTintColor = commonBtnColor
        
        
        //添加刷新控件8
        self.refreshControl = UIRefreshControl()
        
        //设置刷新控件的位置
        let offset = -0
        self.refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: CGFloat(offset),
                                            width: refreshControl.bounds.size.width,
                                            height: refreshControl.bounds.size.height)
        self.refreshControl.addTarget(self, action: #selector(refreshWebView(sender:)), for: UIControlEvents.valueChanged)
        self.webView.scrollView.addSubview(refreshControl)
        
        //监听KVO
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil) // add observer for key path
    }
}

class LeakAvoider : NSObject, WKScriptMessageHandler {
    weak var delegate : WKScriptMessageHandler?
    init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(
            userContentController, didReceive: message)
    }
    
}


class ExcuteWebModel : NSObject {
    static var mark : Int?
}
