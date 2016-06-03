//
//  SiteCollectionViewCell.swift
//  Tennis
//
//  Created by seasong on 16/5/16.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class SiteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var siteTitleLabel: UILabel!
    var site:Site!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func deleteButtonClick(sender: UIButton) {
        let alert = UIAlertController(title: "提示", message: "移除\(site.siteName)?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
        let doneAction = UIAlertAction(title: "确认", style: .Default) { (UIAlertAction) in
            
        }
        cancelAction.setValue(myGreen, forKey: "_titleTextColor")
        doneAction.setValue(myGreen, forKey: "_titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        superViewController.presentViewController(alert, animated: true, completion: nil)
    }
}
