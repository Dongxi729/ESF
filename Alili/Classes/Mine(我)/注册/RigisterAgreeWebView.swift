//
//  RigisterAgreeWebView.swift
//  Alili
//
//  Created by 郑东喜 on 2016/12/26.
//  Copyright © 2016年 郑东喜. All rights reserved.
//

import UIKit

class RigisterAgreeWebView: WKBaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.urlRequestCache = NSURLRequest.init(url: URL.init(string: self.url)!)
        
        self.webView.load(self.urlRequestCache as URLRequest)
    }


}
