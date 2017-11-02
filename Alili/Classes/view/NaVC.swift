//
//  NaVC.swift
//  Alili
//
//  Created by 郑东喜 on 2016/12/20.
//  Copyright © 2016年 郑东喜. All rights reserved.
//

import UIKit

class NaVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.navigationBar.barTintColor = commonBtnColor
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
//        UINavigationBar.appearance().isTranslucent = false
    }

}
