//
//  VenueView.swift
//  Tennis
//
//  Created by seasong on 16/4/17.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class VenueView: UIView {

    private var fatherViewController: UIViewController!
    
    private var cenueManageView: CenueManageView!
    private var orderView: OrderView!
    private var priceSettingView: PriceSettingView!
    private var siteManageView: SiteManageView!
    
    private var markView: UIView!
    private var lastOptionButton: UIButton!
    private var lastView: UIView!
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        
        self.fatherViewController = fatherViewController
        
        let optionView = UIView(frame: CGRectMake(0, 0, bounds.width, 55))
        optionView.backgroundColor = UIColor(red: 253/255, green: 253/255, blue: 253/255, alpha: 1)
        for index in 0...3 {
            let button = UIButton(type: .System)
            button.frame = CGRectMake(bounds.width / 4 * CGFloat(index), 0, bounds.width / 4, 55.5)
            button.tag = index
            switch index {
            case 0:
                button.setTitle("场地预定", forState: .Normal)
                button.tintColor = myGreen
                lastOptionButton = button
                lastView = cenueManageView
            case 1:
                button.setTitle("订单管理", forState: .Normal)
                button.tintColor = UIColor.darkGrayColor()
            case 2:
                button.setTitle("场地定价", forState: .Normal)
                button.tintColor = UIColor.darkGrayColor()
            default:
                button.setTitle("场地管理", forState: .Normal)
                button.tintColor = UIColor.darkGrayColor()
            }
            button.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
            button.addTarget(self, action: #selector(VenueView.optionButtonClick(_:)), forControlEvents: .TouchUpInside)
            optionView.addSubview(button)
        }
        
        let bottomLine = UIView(frame: CGRectMake(0, 55, frame.width, 0.5))
        bottomLine.backgroundColor = UIColor.lightGrayColor()
        bottomLine.alpha = 0.3
        optionView.addSubview(bottomLine)
        
        markView = UIView(frame: CGRectMake((bounds.width / 4 - bounds.width / 6) / 2, 54, bounds.width / 6, 1))
        markView.backgroundColor = myGreen
        optionView.addSubview(markView)
        
        self.addSubview(optionView)
        
        cenueManageView = CenueManageView(frame: CGRectMake(0, 55.5, bounds.width, bounds.height - 55), fatherViewController: self.fatherViewController)
        orderView = OrderView(frame: CGRectMake(0, 55.5, bounds.width, bounds.height - 55), fatherViewController: self.fatherViewController)
        priceSettingView = PriceSettingView(frame: CGRectMake(0, 55.5, bounds.width, bounds.height - 55), fatherViewController: self.fatherViewController)
        siteManageView = SiteManageView(frame: CGRectMake(0, 55.5, bounds.width, bounds.height - 55), fatherViewController: self.fatherViewController)
        
        self.addSubview(orderView)
        self.addSubview(priceSettingView)
        self.addSubview(siteManageView)
        self.addSubview(cenueManageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //选项切换点击事件
    func optionButtonClick(sender: UIButton) {
        UIView.animateWithDuration(0.3, animations: {
            self.markView.frame = CGRectMake(self.bounds.width / 4 * CGFloat(sender.tag) + (self.bounds.width / 4 - self.bounds.width / 6) / 2, 54, self.bounds.width / 6, 1)
            self.lastOptionButton.tintColor = UIColor.darkGrayColor()
            sender.tintColor = myGreen
            })
        switch sender.tag {
        case 0:
            bringSubviewToFront(cenueManageView)
        case 1:
            bringSubviewToFront(orderView)
        case 2:
            bringSubviewToFront(priceSettingView)
        default:
            bringSubviewToFront(siteManageView)
        }

        
        lastOptionButton = sender
    }

}

