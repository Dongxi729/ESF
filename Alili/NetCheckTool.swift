//
//  NetCheck.swift
//  NetworkStatus
//
//  Created by 郑东喜 on 2017/3/31.
//  Copyright © 2017年 com.personal. All rights reserved.
//  检查网络连通状态

import UIKit

class NetCheckTool: NSObject {
    
    
    static let shared = NetCheckTool()
    
    var comfun:((_ connectResult : Bool)->Void)?
    
    
    
    /// 网络鉴别
    ///
    /// - Parameter _com: 返回NetCode(0,1,2)
    /// - Parameter _com: 0 为没网络  1无线网络  2WWAN(蜂窝)
    func returnNetStatus(getNetCode _com: @escaping (_ connectResult : Bool)->Void) -> Void {
        
        self.comfun = _com
//
//        AFNetworkReachabilityManager.shared().startMonitoring()
//        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (sddd) in
//
//            if sddd.rawValue == 0 {
//                self.comfun!(false)
//            } else {
//                self.comfun!(true)
//            }
//        }
    }
    
}
