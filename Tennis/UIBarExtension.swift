//
//  UIBarExtension.swift
//  Tennis
//
//  Created by seasong on 16/4/23.
//  Copyright © 2016年 seasong. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.hidden = true
    }
    
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.hidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}

extension UIToolbar {
    
    func hideHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = true
    }
    
    func showHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = false
    }
    
    private func hairlineImageViewInToolbar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInToolbar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}