//
//  MainViewController.swift
//  DollarBuy
//
//  Created by 郑东喜 on 2016/11/6.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  用来布局tabbarcontroller 四个子页面

import UIKit


class MainViewController: BaseTabbarVC  {
    
    
    var mvc = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpSubViews()
        
//        self.tabBar.barTintColor = UIColor.white
        
        self.tabBar.isTranslucent = false

    }
    
}

// MARK:- 设置子界面
extension MainViewController {
    func setUpSubViews() -> Void {
        
        //为每个子页面独立添加导航栏
        let mainPageVC = UINavigationController.init(rootViewController: MainPageViewController())
        
        //禁用半透明
        mainPageVC.navigationBar.isTranslucent = false

        let shopVc = UINavigationController.init(rootViewController: ShoppingViewController())
        //禁用半透明
        shopVc.navigationBar.isTranslucent = false
        
        ///分类
        let categoryVC = NaVC.init(rootViewController:CategoryVC())
        categoryVC.navigationBar.isTranslucent = false
        
        if localSave.object(forKey: userToken) != nil {
            //正式页面
            mvc = MyVC()
            
        } else {
            mvc = LoginView()
        }
        
        //我的模块
        let meVC = UINavigationController.init(rootViewController: MyVC())
        //禁用半透明
//        meVC.navigationBar.isTranslucent = false
        
        self.setupChildVC(mainPageVC, title: "首页", imageName: "nav_1", selectImageName: "nav_1_on")

        self.setupChildVC(categoryVC, title: "商品分类", imageName: "nav_2", selectImageName: "nav_2_on")
        
        self.setupChildVC(shopVc, title: "购物车", imageName: "nav_4", selectImageName: "nav_4_on")

        self.setupChildVC(meVC, title: "我的", imageName: "nav_5", selectImageName: "nav_5_on")
    }
    
    
    //添加子页面
    func setupChildVC(_ childVC: UIViewController,title: String,imageName: String,selectImageName: String) {
        
        childVC.title = title
        childVC.tabBarItem.image = UIImage.init(named: imageName)
        //        不在渲染图片
        childVC.tabBarItem.selectedImage = UIImage.init(named: selectImageName)?.withRenderingMode(.alwaysOriginal)
        
        self.addChildViewController(childVC)
    }
}
