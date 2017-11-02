//
//  Nine.swift
//  TTT
//
//  Created by 郑东喜 on 2017/1/23.
//  Copyright © 2017年 郑东喜. All rights reserved.
//

import UIKit

///右侧试图cell设置
private let kGameItemMargin : CGFloat = 4
private let kItemW = (SW * 0.75 - kGameItemMargin * 4) / 3
private let kItemH = SW / 2
private let kGameCellID = "kGameCellID"

class Nine: WKBaseViewController,LeftBtnViewDelegate,NineViewDelegate {
    
    ///左边数据
    lazy var leftArray = NSArray()
    
    ///右边数据
    lazy var dic = NSArray()
    
    lazy var scVIew = UIScrollView()
    
    ///离线字典,保存请求数据
    lazy var offLine = NSMutableDictionary()
    
    ///右边的视图
    lazy var rightView : UIView = NineView()
    
    ///左边视图
    lazy var letfView : UIView = LeftBtnView()
    
    fileprivate lazy var offlineDddd : NSMutableDictionary = NSMutableDictionary()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.progressView.isHidden = true
        UIApplication.shared.statusBarStyle = .default

        //若导航栏的子页面数量大于1，则设置第一面的导航栏颜色为白色，其他为橘色
        if (self.navigationController?.viewControllers.count)! > 1 {
            
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            
            UIApplication.shared.statusBarStyle = .default
            
        } else {
            
            ///状态栏背景色
            self.navigationController?.navigationBar.barTintColor = commonBtnColor
            
            
            //文字颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        self.setUI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        UINavigationBar.appearance().backgroundColor = UIColor.white
        
        title = "商品分类"
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        ///设置右边的视图
        setRightVCiew()
    }
    
}

// MARK:- 左边的表格
extension Nine : UITableViewDelegate,UITableViewDataSource {
    func setTable() -> Void {
        
        let leftRect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height - 128)
        let tableView = UITableView.init(frame: leftRect)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = commonBgColor
        
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        ///默认选择第一行
        if leftArray.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            
            let one_id : String = (self.leftArray[indexPath.row] as? NSDictionary)?["one_id"] as! String
            
            ///传出对应的商品ID
            requestRight(rightIndex: one_id)
        } else {}
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellID")
        }
        
        cell?.layer.borderWidth = 0.5
        cell?.layer.borderColor = commonBgColor.cgColor
        
        cell?.textLabel?.textAlignment = .center
        
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.text = (leftArray[indexPath.row] as? NSDictionary)?["one_title"] as? String
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if leftArray.count == 0 {
            return 0
        } else {
            return leftArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let one_id : String = (self.leftArray[indexPath.row] as? NSDictionary)?["one_id"] as! String
        
        ///传出对应的商品ID
        requestRight(rightIndex: one_id)
        
        
    }
    
}

// MARK:- 请求右边的列表
extension Nine {
    func requestRight(rightIndex : String) -> Void {
        let params = ["one_id" : rightIndex] as [String : Any]
        
        //1.离线键名
        let urlID = params["one_id"] as? String
        let offlineKeyName = "http://shop.ie1e.com/app/product_list.aspx?cat=" + urlID!
//        if result {
            //0.判断本地存储是否存在
            
            if localSave.object(forKey: "offlineData") != nil {
                
                self.offlineDddd = localSave.object(forKey: "offlineData") as! NSMutableDictionary
                
                //1.取出保存好的离线字典
                
                //2.拿到字典
                //3.判断是否包含url + id 的链接组合,取出对应的键值
                if self.offlineDddd.count == 0 {
                    return
                    
                } else {
                    if self.offlineDddd[offlineKeyName] != nil {
                        
                        self.dic = (self.offlineDddd[offlineKeyName] as? NSArray)!
                        
                        //若数组个数和为0，则跳出去,不执行
                        if self.dic.count != 0 {
                            self.scVIew.removeFromSuperview()
                            self.setRightVCiew()
                        }
                        
                    } else {
                        return
                    }
                }
                
            }
            
        
            
            self.navigationItem.title = "商品分类"
            
            ///有网络
            postWithPath(path: "http://shop.ie1e.com/ifs/class_two.ashx", paras: params , success: { (response) in
                
                //判读返回值是否为空
                guard let dic = response as? NSDictionary else {
                    return
                }
                
                
                //提取提示语
                let resultCode = dic["resultcode"] as! String
                
                //返回正确
                if resultCode == "0" {
                    
                    //提取提示语
                    let alertmsg = dic["resultmsg"] as! String
                    
                    if alertmsg == "请求成功" {
                        
                        let dic2 = dic["data"] as! NSDictionary
                        
                        self.dic = (dic2["list"] as! NSArray).mutableCopy() as! NSMutableArray
                        
                        localSave.set(self.dic, forKey: "TwoModelData")
                        localSave.synchronize()
                        
                        
                        
                        //先移除旧的控制器，创建新的控制器
                        self.scVIew.removeFromSuperview()
                        self.setRightVCiew()
                        
                        ///存取请求的URL + 商品ID，作为键名保存到一个数组，json作为键值保存到该数组的键值部分，在没网络的时候，从该数组中请求
                        
                        //2.将键名存储到字典
                        self.offLine.setValue(self.dic, forKey: offlineKeyName)
                        
                        //3.将离线字典存到本地
                        localSave.set(self.offLine, forKey: "offlineData")
                        localSave.synchronize()
                        
                    }
                    
                }
            }) { (error) in
                
            }
    
    }
}

// MARK:- 设置右边的视图
extension Nine {
    func setRightVCiew() -> Void {
        
        ///设置右边的视图
        let height = (UIScreen.main.bounds.width * 0.25 - 10 * 5) * CGFloat(dic.count)
        
        let nic = NineView.init(frame: CGRect.init(x: 0, y: -UIScreen.main.bounds.width * 0.25, width: UIScreen.main.bounds.width * 0.75, height: height + UIScreen.main.bounds.width * 0.25))
        
        nic.delegate = self
        
        let scRect = CGRect.init(x: UIScreen.main.bounds.size.width * 0.25, y: 0, width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height)
        
        ///滑动视图
        scVIew = UIScrollView.init(frame: scRect)
        scVIew.decelerationRate = 0.1
        
        scVIew.contentSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height:height)
        
        scVIew.addSubview(nic)
        
        nic.setUI(numberof: dic)
        
        view.addSubview(scVIew)
    }
}


// MARK:- 代理方法
extension Nine {
    
    ///获取到左边数组中链接，发出请求，每次单机，执行跳转 和请求事件
    func getTappTag(str: String) {
        
    }
    
    func getJumpUrl(str: String) {
        
        ///跳转商品链接
        let jumpUrl = "http://shop.ie1e.com/app/product_list.aspx?cat=" + str
        
        aaa(str: jumpUrl)
        
        view.isUserInteractionEnabled = false
        
        //延时，防止pop动画产生偏移
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.view.isUserInteractionEnabled = true
        })
        
        
        //XFLog(message: jumpUrl)
    }
    
    //url---
    func aaa(str : String) -> Void {
        
        let vvv = NineWebView()
        vvv.url = str

        if !netThrough  {
            self.navigationItem.title = "请检查网络"
            
            _leftRight(_view: (self.navigationController?.navigationBar)!)
            
        } else {
            self.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vvv, animated: true)
            
            self.hidesBottomBarWhenPushed = false
        }
    }
    
}


extension Nine {
    @objc fileprivate func setUI() -> Void {
        XFLog(message: "")
        if netThrough == false {
            
            guard let cateOneData = localSave.object(forKey: "caOneModl") as? NSMutableArray else {
                
                return
            }
            
            self.leftArray = cateOneData
            
            self.setTable()
        } else {
            
            CategoryModel.shared.categoryOneModel(_com: { (categoryData) in
                if categoryData.count == 0 {
                    return
                } else {
                    
                    self.leftArray = categoryData
                    
                    ///取出第一个字典
                    let defaultFirstIndex = (categoryData[0] as? NSDictionary)?["one_id"] as? String
                    
                    self.requestRight(rightIndex: defaultFirstIndex!)
                    
                    self.setTable()
                }
            })
        }
        
    }
}
