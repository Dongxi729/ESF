//
//  WKV+YHJExtension.swift
//  Alili
//
//  Created by 郑东喜 on 2017/11/5.
//  Copyright © 2017年 郑东喜. All rights reserved.
//

import Foundation
extension WKBaseViewController : GetCardVDelegate {
    @objc func loadYHJ() {
        /// 判断当前是否领过优惠券

        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        let now = Date.init()
        let nowStr = dformatter.string(from: now)
        let agoStr = userDefault.object(forKey: "nowDate") as? String ?? ""

        if nowStr != agoStr {
            ZDXRequestTool.requestYHJ { (model) in
                // 创建一个日期格式器
                let dformatter = DateFormatter()
                dformatter.dateFormat = "yyyy-MM-dd"
                let timeStr = dformatter.string(from: now)
                self.userDefault.set(timeStr, forKey: "nowDate")
                self.userDefault.synchronize()
                
                if model.count > 0 {
                    // 497 × 503
                    self.getCards = GetCardV.init(frame: UIScreen.main.bounds)
                    UIApplication.shared.keyWindow?.addSubview(self.getCards)
                    self.getCards.center = (UIApplication.shared.keyWindow?.center)!
                    self.getCards.getCardVDelegate = self
                    self.getCards.dataSource = model
                }
            }
        }
    }
    
    func getCardV() {
        removeMask()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        let vc = YHJMainVC()
        vc.url = self.commaddURl(adUrl: coupon_URl)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func removeMask() {
        if (getCards != nil) {
            getCards.removeFromSuperview()
        }
    }
}
