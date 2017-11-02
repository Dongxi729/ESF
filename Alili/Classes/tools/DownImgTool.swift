//
//  DownImgTool.swift
//  DollBuy
//
//  Created by 郑东喜 on 2016/11/23.
//  Copyright © 2016年 郑东喜. All rights reserved.
//  下载图片工具类

import UIKit

class DownImgTool: NSObject {
    
    static let shared = DownImgTool()

    /**
     ## 下载图片
     - urlStr    下载图片的路径
     - imgView   显示的控件
     */
    func downImgWithURLShowToImg(urlStr : String,imgView : UIImageView) -> Void {
        let catPictureURL = URL(string:urlStr)!
        
        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            
            DispatchQueue.main.async {
                // The download has finished.
                if error != nil {
//                    print("Error downloading cat picture: \(e)")
                } else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if (response as? HTTPURLResponse) != nil {
//                        print("Downloaded cat picture with response code \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            //                        self.headImg.image = image

                            imgView.image = image
                            
                            
                            imgView.alpha = 0
                            
                            UIView.animate(withDuration: 2.0, animations: {
                                imgView.alpha = 1
                            })
                            
                            
                            if imgView.image != nil {
                                let data = UIImageJPEGRepresentation(imgView.image!,1.0) as Data!
                                
                                localSave.set(data, forKey: headImgCache)
                                
                                localSave.synchronize()
                            } else {
                                return
                            }
                            // Do something with your image.


                            
                            
                        } else {
//                            print("Couldn't get image: Image is nil")
                        }
                    } else {
//                        print("Couldn't get response code for some reason")
                    }
                }
            }
            
            
        }
        
        downloadPicTask.resume()

    }
}
