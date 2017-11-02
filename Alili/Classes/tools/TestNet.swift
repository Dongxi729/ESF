//
//  TestNet.swift
//  Fuck
//
//  Created by 郑东喜 on 2016/12/11.
//  Copyright © 2016年 郑东喜. All rights reserved.
//

import UIKit

enum PaymentType : String {
    case worked,lost
}


class TestNet: NSObject {
    static let shared = TestNet()
    
    //接收测试接口返回的值
    
    //func paymentSuccess(paymentType paymentType:PaymentType)
    
//    var comfun:((_ _data:String)->Void)?

    var comfun:((_ _paymentType:PaymentType)->Void)?
    
    var result : String = ""
}

extension TestNet {
    func getNetStatus(comfun:((_ _paymentType:PaymentType)->Void)?) -> Void {
        self.comfun = comfun
        
        
        let logouURL = "https://api.heweather.com/x3/weather?cityid=CN101130701&key=7747e655cce84f3eb3a921c58e13123"
        
        
        getWithPath(path: logouURL, paras: nil, success: { (response) in
            
            //判读返回值是否为空
            guard let dic = response as? NSDictionary else {
                return
            }
            
            if dic.count == 1 {
//                self.result = PaymentType.worked.rawValue
                comfun!(PaymentType.worked)
            }
            
            
        }) { (error) in


            var erro = error.localizedDescription
            if erro.characters.count != 0 {
//                print("网络断了")
//                self.result = PaymentType.lost.rawValue
                comfun!(PaymentType.lost)
            }

        }
    }
}

