//
//  ZDXRequestTool.swift
//  Alili
//
//  Created by 郑东喜 on 2017/10/20.
//  Copyright © 2017年 郑东喜. All rights reserved.
//  请求工具类

import Foundation

class ZDXRequestTool: NSObject {
    class func requestYHJ(finished : @escaping (_ systemData : [SomeStruct])->()) {
        if let token = localSave.object(forKey: userToken) as? String {
            let param : [String : Any] = ["token" : token]
            
            
            print(type(of: self),#line,param)
            print(type(of: self),#line,couponURL)
            postWithPath(path: couponURL, paras: param, success: { (result) in
                
                print(type(of: self),#line,result)
   
                
                var model = [SomeStruct]()
                if let resultDic = (((result as? NSDictionary)?.object(forKey: "data") as? NSDictionary)?.object(forKey: "list") as? NSArray) {
                    for value in resultDic {
                        let xxx = SomeStruct.init(name: (value as? [String : Any])!)
                        model.append(xxx)
                        
                        if model.count == resultDic.count {
                            
                            finished(model)
                        }
                        CCog(message: model.count)
                    }
                }
                
            }) { (_) in
                
            }
        }
    }
}

/*
 "coupon_id" = 25;
 "full_money" = "200.00";
 "limit_date" = "2017.10.25-2017.11.01";
 "reduce_money" = "50.00";
 title = test;
 }
 */
struct SomeStruct {
    var name: [String : Any]?
    
    init(name: [String : Any]) {
        
        self.name = name
        
    }
}

