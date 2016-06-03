//
//  RHActivityView.swift
//  ActivityTest
//
//  Created by seasong on 16/5/24.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class RHActivityView: UIView {

    private var activityView: UIView!
    private var titleLabel: UILabel!
    private var activityIndecator: UIActivityIndicatorView!
    private var timer: NSTimer!
    
//    override func drawRect(rect: CGRect) {
//    }
    
    init(ownerView: UIView) {
        super.init(frame: ownerView.bounds)

        activityView = UIView()
        activityView.frame.size = CGSizeMake(140, 120)
        activityView.center = self.center
        activityView.layer.cornerRadius = 12
        activityView.layer.masksToBounds = true

        let eff = UIBlurEffect(style: .Dark)
        let shade = UIVisualEffectView(effect: eff)
        shade.frame = activityView.bounds
        shade.alpha = 0.8
        activityView.addSubview(shade)

        titleLabel = UILabel(frame: activityView.bounds)
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textColor = UIColor(white: 1, alpha: 0.8)
        titleLabel.textAlignment = .Center
        activityView.addSubview(titleLabel)
        
        self.addSubview(activityView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitleWithActivity(title: String) {
        if timer != nil {
            timer.invalidate()
        }
        titleLabel.text = title
        titleLabel.frame.origin.y += 30
        activityIndecator = UIActivityIndicatorView()
        activityIndecator.frame = CGRectMake(50, 28, 40, 40)
        activityIndecator.activityIndicatorViewStyle = .WhiteLarge
        activityIndecator.startAnimating()
        activityView.addSubview(activityIndecator)
    }
    
    func stopActivityWithTitle(title: String) {
        sleep(1)
        titleLabel.text = title
        titleLabel.alpha = 0
        UIView.animateWithDuration(0.2) { 
            self.titleLabel.alpha = 1
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        titleLabel.frame.origin.y -= 30
        activityIndecator.stopAnimating()
        activityIndecator.removeFromSuperview()
    }
    
//    func setTitle(title: String) {
//        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
//        titleLabel.text = title
//    }
    
    func dismiss() {
        //停止计时器
        timer.invalidate()
        UIView.animateWithDuration(0.3, animations: { 
            self.alpha = 0
        }) { (true) in
            self.removeFromSuperview()
        }
    }
}
