//
//  CustomTabBarController.swift
//  DollarBuy
//
//  Created by 郑东喜 on 2016/11/6.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  自定义tabbar控制器

import UIKit

class CustomTabBarController: UITabBarController {
    
    
//    var customTabBar = TabBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
//        setUptabbar()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        print("viewwillappear")
//        
//        for child in self.tabBar.subviews {
//            if child.isKind(of: UIControl.self) {
//                child.removeFromSuperview()
//            }
//        }
//    }
}

// MARK:- 设置tabbar
extension CustomTabBarController {


    //添加子页面
    func setupChildVC(_ childVC: UIViewController,title: String,imageName: String,selectImageName: String){
        
        childVC.title = title
        childVC.tabBarItem.image = UIImage.init(named: imageName)
        //        不在渲染图片
        childVC.tabBarItem.selectedImage = UIImage.init(named: selectImageName)?.withRenderingMode(.alwaysOriginal)

        self.addChildViewController(childVC)

        
    }
    
//    //添加子页面
//    func setupChildVC(_ childVC: UIViewController,title: String,imageName: String,selectImageName: String){
//        
//        childVC.title = title
//        childVC.tabBarItem.image = UIImage.init(named: imageName)
//        //        不在渲染图片
//        childVC.tabBarItem.selectedImage = UIImage.init(named: selectImageName)?.withRenderingMode(.alwaysOriginal)
//        
//        self.addChildViewController(childVC)
//        //        添加tabbar内部按钮
//        //        self.customTabBar.addTabbarButtonWith(childVC.tabBarItem)
//        
//    }


}
