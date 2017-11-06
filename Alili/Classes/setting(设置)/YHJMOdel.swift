//
//  YHJMOdel.swift
//  Alili
//
//  Created by 郑东喜 on 2017/10/26.
//  Copyright © 2017年 郑东喜. All rights reserved.
//

import UIKit

/// 优惠券模型
class YHJMOdel : NSObject {
    
    var coupon_id : Any?
    
    var limit_date : Any?
    
    var reduce_money : Any?
    
    var full_money : Any?
    
    var title : Any?
    
    // KVC 字典转模型
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}

