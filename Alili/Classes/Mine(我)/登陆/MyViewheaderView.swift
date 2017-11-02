//
//  MyViewheaderView.swift
//  MD5
//
//  Created by 郑东喜 on 2016/11/24.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  我的模块头视图

import UIKit

//代理
protocol MyViewheaderViewDelegate {
    ///跳转待付款
    func jumpTopay()
    
    ///跳转待发货
    func jumpTosend()
}

class MyViewheaderView: UIView {
    
    static let shared = MyViewheaderView()
    //设置代理监听按钮事件
    var delegate : MyViewheaderViewDelegate?
    
    //默认背景视图
    lazy var headerBgImg : UIImageView = {
        let v = UIImageView()
        v.contentMode = UIViewContentMode.scaleAspectFill
        if SH == 812 {
            v.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180 + 44)
        } else {
            v.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180)
        }
        
        v.image = UIImage.init(named: "jifenBg")
        return v
    }()
    
    // 标题
    var titleLabel : UILabel = {
        var lab = UILabel()
        if SH == 812 {
            lab.frame = CGRect(x: 0, y: 15 + 20, width: UIScreen.main.bounds.width, height: 44)
        } else {
            lab.frame = CGRect(x: 0, y: 15, width: UIScreen.main.bounds.width, height: 44)
        }
        
//        lab.backgroundColor = UIColor.gray
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.textAlignment = NSTextAlignment.center
        lab.textColor = UIColor.white
        lab.text = "我的"
        return lab
    }()
    
    //头像
    lazy var headImg : UIImageView = {
        let img = UIImageView()
        img.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 30, y: 80, width: 60, height: 60)
        img.layer.cornerRadius = 30
        img.backgroundColor = UIColor.clear
        img.layer.masksToBounds = true
        
        return img
    }()
    
    // 姓名
    var nickName : UILabel = {
        var lab = UILabel()
        lab.frame = CGRect(x: 0, y: 135, width: UIScreen.main.bounds.width, height: 44)
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.textAlignment = NSTextAlignment.center
        lab.textColor = UIColor.white

        return lab
    }()
    
    //默认背景视图
    lazy var donwView : UIView = {
        let v = UIView()
        v.contentMode = UIViewContentMode.scaleAspectFill
        v.frame = CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width, height: 60)
        v.backgroundColor = UIColor.white
        return v
    }()
    
    
    //========================================================================
    //第一组第二行
    //========================================================================
    //前面的view
    //后面的view
    lazy var oneViewFrontView : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width * 0.5, height: 60)
        
        return view
    }()
    
    //后面的view
    lazy var oneViewBackView : UIView = {
        let view = UIView()
        view.frame = CGRect(x:  UIScreen.main.bounds.width * 0.5, y: 180, width: UIScreen.main.bounds.width * 0.5, height: 60)
        
        return view
    }()
    
    
    
    //========================================================================
    //开始塞控件
    ///待付款
    lazy var waitPay : UIImageView = {
        let v = UIImageView()
        
        return v
    }()
    
    ///待付款文本
    lazy var waitPaylab : UILabel = {
        let v = UILabel()

        return v
    }()
    
    
    ///待发货
    lazy var waitSend : UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    ///待发货文本
    lazy var waitSendLab : UILabel = {
        let v = UILabel()
        return v
    }()
    

    //========================================================================
    //第一组第二行 添加按钮单击事件(前面)
    //========================================================================
    lazy var frontBtn : UIButton = {
        let btn = UIButton()
//                btn.backgroundColor = UIColor.lightGray
        //frontBtnSEL
        btn.frame = CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width, height: 60)
        btn.addTarget(self, action: #selector(MyViewheaderView.frontBtnSEL), for: .touchUpInside)
        return btn
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyViewheaderView {
    func initView() -> Void {

        //========================================================================
        //前面的view
        
        ///图标
        waitPay.frame = CGRect(x: (oneViewFrontView.Width) * 0.5 - 15, y: 5, width: 30, height: 30)
        waitPay.image = UIImage.init(named: "page")
        oneViewFrontView.addSubview(waitPay)
        
        
        
        ///文字
        waitPaylab.frame = CGRect(x: 0, y: waitPay.BottomY + 3, width: oneViewBackView.Width, height: 20)
        waitPaylab.text = "待付款"
        waitPaylab.textColor = UIColor.gray
        waitPaylab.textAlignment = .center
        waitPaylab.font = UIFont.systemFont(ofSize: 13)
        
        oneViewFrontView.addSubview(waitPaylab)
        
        ///小红点
        let btn = UIButton.init(frame: CGRect(x: (oneViewFrontView.Width) * 0.5 + 5, y: 2, width: 20, height: 20))
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        btn.layer.cornerRadius = 10
        btn.setTitle("1", for: .normal)
        btn.backgroundColor = commonBtnColor
        oneViewFrontView.addSubview(btn)
        
        //========================================================================

        
        //========================================================================
        //后面的view
        waitSend.frame = CGRect(x: (oneViewBackView.Width) * 0.5 - 15, y: 5, width: 30, height: 30)
        waitSend.image = UIImage.init(named: "car")
        oneViewBackView.addSubview(waitSend)
        
        
        
        waitSendLab.frame = CGRect(x: 0, y: waitPay.BottomY + 3, width: oneViewBackView.Width, height: 20)
        waitSendLab.text = "待发货"
        waitSendLab.textColor = UIColor.gray
        waitSendLab.textAlignment = .center
        waitSendLab.font = UIFont.systemFont(ofSize: 13)
        oneViewBackView.addSubview(waitSendLab)
        
        
        ///小红点
        let rightBtn = UIButton.init(frame: CGRect(x: (oneViewBackView.Width) * 0.5 + 5, y: 2, width: 20, height: 20))
        rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        rightBtn.layer.cornerRadius = 10
        rightBtn.setTitle("1", for: .normal)
        rightBtn.backgroundColor = commonBtnColor
        oneViewBackView.addSubview(rightBtn)

        
        
        
        //单例获取值,程序运行时
        if PersonInfoModel.shared.nickName != nil {
            
            self.nickName.text = PersonInfoModel.shared.nickName
            
        } else if PersonInfoModel.shared.personImg != nil {

            let imgURL = LoginModel.shared.personData?["img"] as! String

            if localSave.object(forKey: headImgCache) != nil {
                let data = localSave.object(forKey: headImgCache) as! Data
                headImg.image = UIImage.init(data: data)
                headImg.alpha = 0
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.headImg.alpha = 1
                })
                
            } else {
                //主线程 执行，防止阻塞
                DispatchQueue.main.async(execute: {
                    
                    if imgURL.characters.count == 0 {
                        self.headImg.image = #imageLiteral(resourceName: "nav_5")
                    } else {
                        DownImgTool.shared.downImgWithURLShowToImg(urlStr: imgURL, imgView: self.headImg)
                    }
                    
                })
            }
            
        } else if PersonInfoModel.shared.jifen != nil {
            

            //第二次启动程
        } else if LoginModel.shared.personData?.count == nil {
            
            //本地加载
            guard let ppData = localSave.object(forKey: personInfo) as? NSDictionary else {
                return
            }
            
            //昵称
            PersonInfoModel.shared.nickName = ppData["nickname"] as? String
            
            //头像地址
            if let headUrl = ppData["img"] as? String {
                PersonInfoModel.shared.personImg = "http://" + comStrURL + headUrl
            } else {
                PersonInfoModel.shared.personImg = ""
            }
            
            //积分
            PersonInfoModel.shared.jifen = ppData["integral"] as? String
            
            //昵称
            nickName.text = PersonInfoModel.shared.nickName
            

            //异步加载图片
            DispatchQueue.main.async(execute: {
                if let imgUrl = PersonInfoModel.shared.personImg {
                    if imgUrl.characters.count > 0 {
                        DownImgTool.shared.downImgWithURLShowToImg(urlStr: imgUrl, imgView: self.headImg)
                    } else {
                        self.headImg.image = #imageLiteral(resourceName: "nav_5")
                    }
                }
            })
        }
        
        //不为空，刷新
        if let heaUrl = PersonInfoModel.shared.personImg {
            if heaUrl.characters.count > 0 {
                DownImgTool.shared.downImgWithURLShowToImg(urlStr:PersonInfoModel.shared.personImg! , imgView: self.headImg)
            } else {
                self.headImg.image = #imageLiteral(resourceName: "nav_5")
            }
        }
        
        
        self.addSubview(headerBgImg)
        //添加标题
        self.addSubview(titleLabel)
        
        self.addSubview(headImg)
        
        self.addSubview(nickName)
        
        //添加积分、充值
//        self.addSubview(donwView)
        
        //第一组第二行

//        self.addSubview(oneViewBackView)
//
//        self.addSubview(oneViewFrontView)
        
        //中间线条
        let centerline = UIView.init(frame: CGRect(x:SW * 0.5, y: 190, width: 0.5, height: 40))
        centerline.backgroundColor = UIColor.gray
//        addSubview(centerline)
        
        ///添加按钮
        let fontViewBtn = UIButton()
        fontViewBtn.frame = CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width * 0.5, height: 60)
        fontViewBtn.addTarget(self, action: #selector(frontBtnSEL), for: .touchUpInside)
        
//        addSubview(fontViewBtn)
        
        ///后面添加按钮
        let backViewBtn = UIButton()
        backViewBtn.frame = CGRect(x:  UIScreen.main.bounds.width * 0.5, y: 180, width: UIScreen.main.bounds.width * 0.5, height: 60)
        
        backViewBtn.addTarget(self, action: #selector(backBtnSel), for: .touchUpInside)
//        addSubview(backViewBtn)
    }
}

// MARK:- 单击事件
extension MyViewheaderView {
    func clickImgSEL() -> Void {
    }
    
    //第一组第二行 前面按钮单机事件
    @objc func frontBtnSEL() -> Void {

        delegate?.jumpTopay()
    }
    //第一组第二行 后面按钮单机事件
    
    @objc func backBtnSel() -> Void {
        delegate?.jumpTosend()
    }
}
