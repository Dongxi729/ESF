//
//  NineView.swift
//  TTT
//
//  Created by 郑东喜 on 2017/1/21.
//  Copyright © 2017年 郑东喜. All rights reserved.
//  右边的视图view

import UIKit

protocol NineViewDelegate {
    func getJumpUrl(str : String)
}

class NineView: UIView {
    
    var delegate : NineViewDelegate?

    let col = 3
    
    var button :RightBtn?
    var image :UIImage?
    ///图片
    var imgView :UIImageView?
    
    ///图片链接
    let _imageURL = NSMutableArray()
    
    
    ///按钮标识
    var btnTag = 100
    
    var hhhheight : CGFloat?
    
    ///图片数据数组
    let _imageViews = NSMutableArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NineView {
    func setUI(numberof : NSArray) -> Void {
        // 设置格子的高和宽

        let heigth:CGFloat = UIScreen.main.bounds.width * 0.20
        let width:CGFloat = heigth
        //        设置格子的间距
        
        // 设置格子的间距
        let screenSize:CGSize = UIScreen.main.bounds.size
        
        let hMargin:CGFloat = (screenSize.width * 0.75 - (CGFloat(col) * width)) / CGFloat((col+1))
        let vMargin:CGFloat = hMargin
        //        创建九宫格
        
        var row:Int = 0
        for (idx,che) in numberof.enumerated() {
            
            self.button = RightBtn()
            self.imgView = UIImageView()
            
            ///添加图片
            let imgView = UIImageView.init(frame: (self.button?.frame)!)
            imgView.backgroundColor = UIColor.red
            
            self.button?.addSubview(imgView)
            
            ///获取图片路径
            let imgURL = (che as? NSDictionary)?["two_img"] as? String
            
            //加入图片数组
//            _imageURL.add(imgURL as Any)
            
            self.button?.setTitle((che as? NSDictionary)?["two_title"] as? String , for: .normal)

            self.button?.titleLabel?.textColor = UIColor.black
            self.button?.tag = idx + btnTag
            
            self.button?.liiinKSre = (che as? NSDictionary)?["two_id"] as? String
            
            self.button?.addTarget(self, action: #selector(btnTapped(sender:)), for: .touchUpInside)
            
            if idx % col == 0 {
                row += 1
            }
            
            let x:CGFloat = hMargin + (width + hMargin) * CGFloat(idx % col)
            let y:CGFloat = vMargin + (heigth + vMargin) * CGFloat(row)
            
            //显示的图片
            
            self.button?.frame = CGRect.init(x: x, y: y, width: width, height: heigth)
            
            self.addSubview(self.button!)
            
            self.imgView?.frame = CGRect.init(x: x, y: y, width: width, height: heigth * 0.65)
            self.imgView?.contentMode = .scaleAspectFit
            
            
            self.addSubview(self.imgView!)
        
            
           self.imgView?.sd_setImage(with: URL.init(string:imgURL!), placeholderImage: UIImage.init(), options: .allowInvalidSSLCertificates)
//            self.imgView?.sd_setImage(with: imgURL, placeholderImage: UIImage.init(), options: .allowInvalidSSLCertificates)
            
            ///添加到数组
//            _imageViews.add(self.button!)

//            StatusBarCheck.shared.networkingStatesFromStatebar(_com: { (result) in
//                if result == "notReachable" {
//                    ///断网操作
//                    return
//                } else {
//                    
//                    let thread = Thread.init(target: self, selector: #selector(self.loadImage(index:)), object: NSNumber.init(value: idx))
//                    thread.name = String.localizedStringWithFormat("myThread%i", idx)
//                    
//                    thread.start()
//                }
//            })
            
        }

    }
    
    func loadImage(index : NSNumber) -> Void {
        
        let i = index.intValue

        let dataaa = requestData(index: i,lingURl : (_imageURL[i] as? String)!)
        let imgDatta = DDDD()
        
        imgDatta.imageData = dataaa
        imgDatta.index = i
        
        self.performSelector(onMainThread: #selector(updateImage(imgData:)), with: imgDatta, waitUntilDone: true)    
    }
    
    // MARK:-将图片显示到界面
    @objc func updateImage(imgData : DDDD) -> Void {
        let img = UIImage.init(data: imgData.imageData! as Data)
        
        let imageView = _imageViews[imgData.index] as! UIButton
        imageView.setImage(img, for: .normal)
    }
    
    // MARK:- 请求图片数据
    func requestData(index : Int,lingURl : String) -> NSData {
    
        let url = lingURl

        let dataaa = NSData.init(contentsOf: URL.init(string: url)!)
        
        return dataaa!
    }
}

extension NineView  {
    @objc func btnTapped(sender : RightBtn) -> Void {
        self.delegate?.getJumpUrl(str: sender.liiinKSre!)
    }

}
 
