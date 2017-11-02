//
//  LeftBtnView.swift
//  TTT
//
//  Created by 郑东喜 on 2017/1/21.
//  Copyright © 2017年 郑东喜. All rights reserved.
//  左边的视图-view

import UIKit

protocol LeftBtnViewDelegate {
    func getTappTag(str : String)
}

class LeftBtnView: UIView {

    static let shared = LeftBtnView()
    
    var delegate : LeftBtnViewDelegate?
    
    var linkStr : String?
    
    lazy var caTwoModl = NSMutableArray()

    //外部闭包变量
    var comfun:((_ _data:NSMutableArray)->Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LeftBtnView {
    func setUIIIII(array : NSMutableArray) -> Void {
        for (idx,chr) in array.enumerated() {
            
            let dic = chr as? NSDictionary
            
            let width = UIScreen.main.bounds.width * 0.25
            let height = 45
            
            let btttb = LeftBtn.init(frame: CGRect.init(x: 0, y: 45 * idx, width: Int(width), height: height))
            btttb.layer.borderWidth = 1
            btttb.backgroundColor = UIColor.blue
            btttb.layer.borderColor = UIColor.black.cgColor
            
            btttb.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            ///传递链接
            btttb.linStr = dic?["one_id"] as? String
            
            btttb.setTitle(dic?["one_title"] as? String, for: .normal)
            btttb.addTarget(self, action: #selector(btttnTapped(sender:)), for: .touchUpInside)
            btttb.tag = 100 + idx

            addSubview(btttb)

        }
    }
    
    ///请求右边的
    @objc func btttnTapped(sender : LeftBtn) -> Void {

        self.delegate?.getTappTag(str: sender.linStr!)
    
        
        let params = ["one_id" : sender.linStr!] as [String : Any]
        postWithPath(path: categorTwo, paras: params, success: { (response) in
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
                    
                    self.caTwoModl = (dic2["list"] as! NSArray).mutableCopy() as! NSMutableArray
                    ///测试模型
                    localSave.set(self.caTwoModl, forKey: "caTwoModl")
                    localSave.synchronize()
                    
                    let modelOutside = DDDD()
                    modelOutside.xxxxx = (dic2["list"] as! NSArray).mutableCopy() as? NSMutableArray


                } else {
                    CustomAlertView.shared.alertWithTitle(strTitle: unKnown)
                }
                
            } else {
                
            }
            
        }) { (error) in
            //XFLog(message: error.localizedDescription)
        }

    }
}
