//
//  PaySuccessVC.swift
//  Alili
//
//  Created by 郑东喜 on 2016/12/16.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  支付成功

import UIKit

class PaySuccessVC: WKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
        if self.webView == nil {
            self.title = "支付"
        } else {
            
            //支付成功路径
            let urlStr : URL = URL.init(string: paySuccessURL)!
            
            self.urlRequestCache = NSURLRequest.init(url: urlStr)
            
            self.webView.load(self.urlRequestCache as URLRequest)
            
        }
        

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
