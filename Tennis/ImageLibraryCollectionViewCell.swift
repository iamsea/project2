//
//  ImageCollectionViewCell2.swift
//  Tennis
//
//  Created by seasong on 16/5/2.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class ImageLibraryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImageButton: UIButton!
    var cellNo = -1
    var cellIsCheck = false
    var image = UIImage()
    
    
    override func drawRect(rect: CGRect) {
//        if cellNo == 0 {
//            imageView.image = UIImage(named: "camera_normal")!
//            if checkImageButton != nil {
//                checkImageButton.removeFromSuperview()
//            }
//        }
//
//        if cellNo != 0 {
//            if cellIsCheck {
//                checkImageButton.setImage(UIImage(named: "check_pressed"), forState: .Normal)
//            }
//            else {
//                checkImageButton.setImage(UIImage(named: "check_normal"), forState: .Normal)
//            }
//        }
    }
    
    @IBAction func imageCheckButtonClick(sender: UIButton) {
        if cellIsCheck {
            checkImageButton.setImage(UIImage(named: "check_normal"), forState: .Normal)
            cellIsCheck = false
            checkedImageNOList.removeValueForKey(cellNo)
            //发送消息
            let notification = NSNotificationCenter.defaultCenter()
            notification.postNotificationName("messageFromImageLibraryCollectionViewCell", object: nil)
        }
        else {
            if checkedImageNOList.count < libraryNeedImageCount {
                checkImageButton.setImage(UIImage(named: "check_pressed"), forState: .Normal)
                let transform = CGAffineTransformMakeScale(0.5, 0.5)
                sender.transform = transform
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 10, options: [], animations: {
                    sender.transform = CGAffineTransformIdentity
                    }, completion: nil)
                cellIsCheck = true
                
                checkedImageNOList[cellNo] = cellNo
                //发送消息
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName("messageFromImageLibraryCollectionViewCell", object: nil)
            }
            else {
                //发送消息
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName("messageFromImageLibraryCollectionViewCell", object: "alert")
            }
        }
    }
}
