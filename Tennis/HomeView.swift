//
//  HomeView.swift
//  Tennis
//
//  Created by seasong on 16/5/9.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class HomeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var timer: NSTimer!
    override func drawRect(rect: CGRect) {
        
        let width = scrollView.bounds.width
        let height = width / 2
        
        for index in 0...7 {
            let iv = UIImageView(frame: CGRectMake(width * CGFloat(index) + 3, 0, width - 6, height))
            var picName = "pic"
            switch index {
            case 0:
                picName += "3"
            case 1:
                picName += "4"
            case 6:
                picName += "1"
            case 7:
                picName += "2"
            default:
                //                picName += i.description
                picName += String(index - 1)
            }
            iv.image = UIImage(named: picName)
            iv.contentMode = UIViewContentMode.ScaleAspectFill
            iv.clipsToBounds = true
            iv.userInteractionEnabled = true
            iv.layer.borderWidth = 0.5
            iv.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
            self.scrollView.addSubview(iv)
        }
        self.scrollView.contentSize = CGSizeMake(width * 8, height)
        self.scrollView.contentOffset = CGPointMake(width * 2, 0) //指向第三张
        self.scrollView.clipsToBounds = false
        addTimer()

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let offsetX = scrollView.contentOffset.x
            let width = scrollView.bounds.width
            if offsetX == width {
                scrollView.contentOffset = CGPointMake(width * CGFloat(5), 0)
            }
            if offsetX == width * CGFloat(4 + 2) {
                scrollView.contentOffset = CGPointMake(width * 2, 0)
            }
            
            // 此处不能用 offsetX 代替 scrollView.contentOffset.x，这个值在变化
            let currentPage = scrollView.contentOffset.x / width - 1.5
            
            self.pageControl.currentPage = Int(currentPage)
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
    }
    
    
    func addTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
    }
    
    func nextImage(sender: AnyObject) {
        let width = scrollView.bounds.width
        if self.pageControl.currentPage != 3 {
            UIView.animateWithDuration(0.5) {
                self.scrollView.contentOffset.x += width//注意：contentOffset就是设置ScrollView的偏移
            }
        }
        else {
            UIView.animateWithDuration(0.5, animations: {
                self.scrollView.contentOffset.x += width - 1//注意：contentOffset就是设置ScrollView的偏移
                }, completion: { (true) in
                    self.scrollView.contentOffset.x += 1
            })
        }
    }
}
