//
//  LineUIView.swift
//  ERecycle1.0
//
//  Created by seasong on 15/12/5.
//  Copyright © 2015年 sea. All rights reserved.
//

import UIKit

class LineUIView: UIView {

    @IBInspectable var isHorizontal: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layoutAttribute = self.isHorizontal ? NSLayoutAttribute.Height : NSLayoutAttribute.Width
        for item in self.constraints {
            let constraint = item as NSLayoutConstraint
            if constraint.firstItem as! UIView == self && constraint.firstAttribute == layoutAttribute {
                self.removeConstraint(constraint)
                constraint.constant = 1 / UIScreen.mainScreen().scale
                self.addConstraint(constraint)
            }
        }
    }
}
