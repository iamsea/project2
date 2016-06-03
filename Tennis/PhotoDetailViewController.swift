//
//  PhotoDetailViewController.swift
//  CollectionViewTest
//
//  Created by seasong on 16/5/1.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var image: UIImage!
    var imageView: UIImageView!
    var toolBarView: UIView!
    
    //父视图接受消息标志
    var serverMessageIdentity: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView()
        imageView.image = image
        
        let imageWidth: CGFloat = self.view.bounds.width
        let imageHeight = min(self.view.frame.height, imageWidth * image.size.height / image.size.width)
        imageView.frame.size = CGSizeMake(imageWidth, imageHeight)
        imageView.center = self.view.center
        scrollView.addSubview(imageView)
//        scrollView.contentSize = CGSizeMake(imageWidth, imageHeight)
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapBegan))
        scrollView.addGestureRecognizer(tap)
        
        loadToolBar()
        
        let notification = NSNotificationCenter.defaultCenter()
        notification.postNotificationName("hideStatusBar", object: true)
    }
    
    func loadToolBar() {
        toolBarView = UIView(frame: CGRectMake(0, -64, self.view.bounds.width, 64))
        
        let eff = UIBlurEffect(style: .Dark)
        let shadeView = UIVisualEffectView(effect: eff)
        shadeView.frame = toolBarView.bounds
        toolBarView.addSubview(shadeView)
        
        let backButton = UIButton(frame: CGRectMake(15, 5, 54, 54))
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(backButtonClick), forControlEvents: .TouchUpInside)
        toolBarView.addSubview(backButton)
        
        let deleteButton = UIButton(frame: CGRectMake(self.view.bounds.width - 64, 10, 44, 44))
        deleteButton.setImage(UIImage(named: "delete_normal"), forState: .Normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), forControlEvents: .TouchUpInside)
        toolBarView.addSubview(deleteButton)
        
        self.view.addSubview(toolBarView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        let notification = NSNotificationCenter.defaultCenter()
        notification.postNotificationName("hideStatusBar", object: false)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.4) { 
            self.toolBarView.frame.origin.y += 64
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func backButtonClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func deleteButtonClick() {
        self.dismissViewControllerAnimated(true) { 
            //发送消息
            let notification = NSNotificationCenter.defaultCenter()
            notification.postNotificationName(self.serverMessageIdentity, object: nil)
        }
    }
    
    //单击scrollView
    func tapBegan() {
        if toolBarView.frame.origin.y == 0 {
            UIView.animateWithDuration(0.3, animations: { 
                self.toolBarView.frame.origin.y = -64
            })
        }
        else {
            UIView.animateWithDuration(0.3, animations: { 
                self.toolBarView.frame.origin.y = 0
            })
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
