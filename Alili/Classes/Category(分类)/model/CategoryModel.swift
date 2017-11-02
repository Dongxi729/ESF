//
//  CategoryModel.swift
//  Alili
//
//  Created by 郑东喜 on 2017/1/22.
//  Copyright © 2017年 郑东喜. All rights reserved.
//  分级模型

import UIKit

class CategoryModel: NSObject {
    
    static let shared = CategoryModel()
    
    lazy var caOneModl = NSMutableArray()
    
    lazy var accc = NSMutableArray()
    
    //外部闭包变量
    var comfun:((_ _data:NSMutableArray)->Void)?
    
    func categoryOneModel(_com:@escaping (_ _data:NSMutableArray)->Void) -> Void {
        let params = ["" : ""] as [String : Any]
        
        postWithPath(path: "http://shop.ie1e.com/ifs/class_one.ashx", paras: params, success: { (response) in
            
            ///闭包
            self.comfun = _com
            
            //判读返回值是否为空
            guard let dic = response as? NSDictionary else {
                return
            }
            
            //提取提示语
            let resultCode = dic["resultcode"] as! String
            
            //返回正确
            if resultCode == "0" {
                
                //提取提示语
                let alertmsg = dic["resultmsg"] as! String
                
                if alertmsg == "请求成功" {
                    let dic2 = dic["data"] as! NSDictionary
                    
                    self.caOneModl = (dic2["list"] as! NSArray).mutableCopy() as! NSMutableArray
                    
                    self.comfun!(self.caOneModl)

                    
                    UserDefaults.standard.set(self.caOneModl, forKey: "caOneModl")
                    UserDefaults.standard.synchronize()
                    
                } else {
                    
                }
                
            } else {
                
            }
            
        }) { (error) in
            
        }

    }

    
    private override init() {
        super.init()
        
        let params = ["" : ""] as [String : Any]

        postWithPath(path: "http://shop.ie1e.com/ifs/class_one.ashx", paras: params, success: { (response) in
            //判读返回值是否为空
            guard let dic = response as? NSDictionary else {
                return
            }
            
            //提取提示语
            let resultCode = dic["resultcode"] as! String
            
            //返回正确
            if resultCode == "0" {
                
                //提取提示语
                let alertmsg = dic["resultmsg"] as! String
                
                if alertmsg == "请求成功" {
                    let dic2 = dic["data"] as! NSDictionary
                    
                    self.caOneModl = (dic2["list"] as! NSArray).mutableCopy() as! NSMutableArray
                    
                    UserDefaults.standard.set(self.caOneModl, forKey: "caOneModl")
                    UserDefaults.standard.synchronize()

                } else {
                    
                }
                
            } else {
                
            }
            
        }) { (error) in
            
        }
    }
    
}
