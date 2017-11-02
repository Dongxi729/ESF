//
//  TestAlert.swift
//  Alili
//
//  Created by 郑东喜 on 2017/2/16.
//  Copyright © 2017年 郑东喜. All rights reserved.
//

import UIKit

class TestAlert: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.backgroundColor = UIColor.white
        
        
        
        
        showWithAlert(alertStr:"\((#file as NSString).lastPathComponent):(\(#line))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
