//
//  HomeViewController.swift
//  Tennis
//
//  Created by seasong on 16/4/10.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

let detailViewCGRect = CGRect(x: 80.5, y: 0, width: UIScreen.mainScreen().bounds.width - 80.5, height: UIScreen.mainScreen().bounds.height)
let myGreen = UIColor(red: 44/255, green: 193/255, blue: 93/255, alpha: 1)
var superViewController: UIViewController!

class HomeViewController: UIViewController {
    
    private var setStatusBarToHide = false
   
    @IBOutlet weak var personalView: UIView!
    @IBOutlet weak var personalViewLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var settingViewLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet var itemImageList: [UIImageView]!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var timer: NSTimer!
    let width = CGFloat(602)
    
    var venueView: VenueView!
    var competitionView: CompetitionView!
    var memberView: MemberView!
    var selectedButton: UIButton!
    var selectedButtonImageName: String!
    var shadeView: UIVisualEffectView!
    var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        superViewController = self
        
        detailView = UIView(frame: detailViewCGRect)
        
        selectedButton = homeButton
        selectedButton.setTitleColor(myGreen, forState: .Normal)
        
        itemImageList[0].image = UIImage(named: "home_pressed")
        selectedButtonImageName = "home_normal"
        
        venueView = VenueView(frame: detailViewCGRect, fatherViewController: self)
        competitionView = CompetitionView(frame: detailViewCGRect, fatherViewController: self)
        memberView = MemberView(frame: detailViewCGRect)
        
        shadeView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        shadeView.alpha = 0
        shadeView.frame = self.view.frame
        
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
        //接收imageCell的消息步骤一 注册一个observer来响应子控制器的消息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getMessage), name: "hideStatusBar", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return setStatusBarToHide
    }
    
    @IBAction func menuButtonClick(sender: UIButton) {
        
        itemImageList[selectedButton.tag - 1].image = UIImage(named: selectedButtonImageName)
        selectedButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        sender.setTitleColor(myGreen, forState: .Normal)
        switch sender.tag {
        case 1:
            detailView.removeFromSuperview()
            itemImageList[0].image = UIImage(named: "home_pressed")
            selectedButtonImageName = "home_normal"
        case 2:
            detailView.removeFromSuperview()
            detailView = venueView
            self.view.addSubview(detailView)
            itemImageList[1].image = UIImage(named: "venue_pressed")
            selectedButtonImageName = "venue_normal"
        case 3:
            detailView.removeFromSuperview()
            detailView = memberView
            self.view.addSubview(detailView)
            itemImageList[2].image = UIImage(named: "member_pressed")
            selectedButtonImageName = "member_normal"
        case 4:
            detailView.removeFromSuperview()
            detailView = competitionView
            self.view.addSubview(detailView)
            itemImageList[3].image = UIImage(named: "competition_pressed")
            selectedButtonImageName = "competition_normal"
        default:
            break
        }
        selectedButton = sender
    }
    
    @IBAction func logoButtonClick(sender: UIButton) {

        if personalViewLeadingConstrains.constant != 0 {
            self.view.addSubview(shadeView)
            self.view.bringSubviewToFront(personalView)
            UIView.animateWithDuration(0.3, animations: {
                self.personalView.frame.origin.x = 0
                self.shadeView.alpha = 1.0
            })
            personalViewLeadingConstrains.constant = 0
        }
        else {
            UIView.animateWithDuration(0.3, animations: {
                self.personalView.frame.origin.x = -self.personalView.frame.width
                self.shadeView.alpha = 0
            })
            shadeView.removeFromSuperview()
            personalViewLeadingConstrains.constant = -self.personalView.frame.width
        }
    }
    
    @IBAction func settingButtonClick(sender: UIButton) {
        if settingViewLeadingConstrains.constant != 0 {
            self.view.addSubview(shadeView)
            self.view.bringSubviewToFront(settingView)
            UIView.animateWithDuration(0.3, animations: {
                self.settingView.frame.origin.x = 0
                self.shadeView.alpha = 1.0
            })
            settingViewLeadingConstrains.constant = 0
        }
        else {
            UIView.animateWithDuration(0.3, animations: {
                self.settingView.frame.origin.x = -self.settingView.frame.width
                self.shadeView.alpha = 0
            })
            shadeView.removeFromSuperview()
            settingViewLeadingConstrains.constant = -self.settingView.frame.width
        }
    }
    
    //退出登录
    @IBAction func logoutButtonClick(sender: UIButton) {
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginViewController")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if touch?.view == shadeView && personalViewLeadingConstrains.constant == 0 {
            UIView.animateWithDuration(0.3, animations: {
                self.personalView.frame.origin.x = -self.personalView.frame.width
                self.shadeView.alpha = 0
            })
            shadeView.removeFromSuperview()
            personalViewLeadingConstrains.constant = -self.personalView.frame.width
        }
        if touch?.view == shadeView && settingViewLeadingConstrains.constant == 0 {
            UIView.animateWithDuration(0.3, animations: {
                self.settingView.frame.origin.x = -self.settingView.frame.width
                self.shadeView.alpha = 0
            })
            shadeView.removeFromSuperview()
            settingViewLeadingConstrains.constant = -self.settingView.frame.width
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let offsetX = scrollView.contentOffset.x
            
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
        self.timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
    }
    
    
    func addTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
    }
    
    func nextImage(sender: AnyObject) {
        
        if self.pageControl.currentPage != 3 {
            UIView.animateWithDuration(0.8) {
                self.scrollView.contentOffset.x += self.width//注意：contentOffset就是设置ScrollView的偏移
            }
        }
        else {
            UIView.animateWithDuration(0.8, animations: {
                self.scrollView.contentOffset.x += self.width - 1//注意：contentOffset就是设置ScrollView的偏移
                }, completion: { (true) in
                    self.scrollView.contentOffset.x += 1
            })
        }
    }
    
    //接收imageCell的消息步骤二 消息响应函数
    func getMessage(notification:NSNotification) {
        setStatusBarToHide = notification.object as! Bool
        prefersStatusBarHidden()
    }
    
    //接收imageCell的消息步骤三 移除observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
