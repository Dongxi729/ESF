//
//  PayFailViewController.swift
//  Alili
//
//  Created by 郑东喜 on 2016/12/16.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  支付失败页面

import UIKit

class PayFailViewController: WKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadFirst(loadURl: self.url, firstUrl: payFailURL)
//        webView.load(URLRequest.init(url: URL.init(string: commaddURl(adUrl: payFailURL))!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
