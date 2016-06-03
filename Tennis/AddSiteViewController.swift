//
//  AddSiteViewController.swift
//  Tennis
//
//  Created by seasong on 16/5/16.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class AddSiteViewController: UIViewController {
    
    var serverMessageIdentity: String!
    private let messageIdentity = "addSiteViewMessageIdentity"
    

    @IBOutlet weak var siteTitleTextField: UITextField!
    @IBOutlet var imageButtons: [AddSiteImageButton]!
    
    
    //上传图片的最大数量
    var maxImageCount = 4
    //已有的图片
    var images = Array<UIImage>()
    var tempSelectedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏navigationBar下的黑线
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.hideBottomHairline()

        //接收子场景的消息步骤一 注册一个observer来响应子控制器的消息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getMessage), name: messageIdentity, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //取消按钮
    @IBAction func cancelBarButtonClick(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    //确认按钮
    @IBAction func doneBarButtonClick(sender: UIBarButtonItem) {
        if siteTitleTextField.text == "" {
            UIView.animateWithDuration(0.1, animations: {
                self.siteTitleTextField.center.x -= 30
            }) { (true) in
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 25, options: [], animations: {
                    self.siteTitleTextField.center.x += 30
                    }, completion: { (true) in
                        self.siteTitleTextField.becomeFirstResponder()
                })
            }
        }
//        if images.count == 0 {
//            UIView.animateWithDuration(0.1, animations: {
//                self.imageButtons[0].center.x -= 20
//            }) { (true) in
//                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 25, options: [], animations: {
//                    self.imageButtons[0].center.x += 20
//                    }, completion: nil)
//            }
//        }

        else {
            //上传场地数据
            let activityView = RHActivityView(ownerView: self.view)
            activityView.setTitleWithActivity("处理中...")
            self.view.addSubview(activityView)
            
            //上传场地名
            let submitSite = NetworkTool.AddSite(siteName: self.siteTitleTextField.text!)
            submitSite.getResult({ (r, error) in
                if r != nil {
                    let submitSiteResult = AddPlaceResult(fromDictionary: r!)
                    if submitSiteResult.state == 1 {

                            
                            let placeId = String(submitSiteResult.list)
                            let submitSitePhoto = NetworkTool.SubmitSitePhoto(placeId: placeId, imageArray: self.images)
                            submitSitePhoto.getResult({ (pr, perror) in
                                if pr != nil {
                                    let submitPhotoResult = GeneralSubmitResult(fromDictionary: pr!)
                                    print(submitPhotoResult)
                                    if submitPhotoResult.state == 0 {
                                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                            //数据出错
                                            activityView.stopActivityWithTitle(submitSiteResult.msg)
                                        })
                                    }
                                    if submitSiteResult.state == 1 {
                                    activityView.stopActivityWithTitle("添加成功")
                                    UIView.animateWithDuration(1, animations: {
                                        activityView.alpha = activityView.alpha - 0.01
                                        }, completion: { (true) in
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                            let notification = NSNotificationCenter.defaultCenter()
                                            notification.postNotificationName(self.serverMessageIdentity, object: nil)
                                    })
                                    }
                                }
                                else {
                                    NSOperationQueue.mainQueue().addOperationWithBlock({
                                        //服务器出错
                                        activityView.stopActivityWithTitle(perror!)
                                    })
                                }
                            })

                            
                            
    

//                        activityView.stopActivityWithTitle("添加成功")
//                        UIView.animateWithDuration(1, animations: {
//                            activityView.alpha = activityView.alpha - 0.01
//                            }, completion: { (true) in
//                            self.dismissViewControllerAnimated(true, completion: nil)
//                        })
                    }
                    else {
                         NSOperationQueue.mainQueue().addOperationWithBlock({
                            //数据出错
                            activityView.stopActivityWithTitle(submitSiteResult.msg)
                         })
                    }
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        //服务器出错
                        activityView.stopActivityWithTitle(error!)
                    })
                }
            })
        }
    }
    
//    func saveImage(currentImage:UIImage,imageName:NSString){
//        let imageData:NSData = UIImageJPEGRepresentation(currentImage, 0.5)!
////        let fullPath:String = NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent(imageName as String)
//        let path = NSURL.fileURLWithPathComponents(["Documents", String(imageName)])
//        imageData.writeToFile(path, atomically: false)d
//        var fileURL = NSURL(fileURLWithPath: path)     //开始上传操作
//    }
    
    
    //点击图片按钮
    @IBAction func imageButtonClick(sender: AddSiteImageButton) {
        if sender.imageView?.image == UIImage(named: "addSite2") || sender.imageView?.image == UIImage(named: "addSite1") {
            self.performSegueWithIdentifier("imageLibrary", sender: self)
        }
        else if sender.imageView?.image != UIImage(named: "addSite3") {
            let photoDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("photoDetailViewController") as! PhotoDetailViewController
            photoDetailViewController.serverMessageIdentity = messageIdentity
            photoDetailViewController.image = images[sender.tag]
            self.presentViewController(photoDetailViewController, animated: true, completion: nil)
            tempSelectedButton = sender
        }
    }
    
    //
    func loadActivityView(sender: UIView, isAnimation: Bool, title: String) {
        let backgroudView = UIView()
        backgroudView.frame = sender.frame
        
        let activityView = UIView()
        activityView.frame.size = CGSizeMake(140, 120)
        activityView.center = backgroudView.center
        activityView.layer.cornerRadius = 12
        activityView.layer.masksToBounds = true
        
        let eff = UIBlurEffect(style: .Dark)
        let shade = UIVisualEffectView(effect: eff)
        shade.frame = activityView.bounds
        activityView.addSubview(shade)
        
        let titleLabel = UILabel(frame: activityView.bounds)
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = title
        activityView.addSubview(titleLabel)
        
        if isAnimation {
            titleLabel.frame.origin.y += 30
            let activityIndecator = UIActivityIndicatorView()
            activityIndecator.frame = CGRectMake(50, 30, 40, 40)
            activityIndecator.hidesWhenStopped = false
            activityIndecator.activityIndicatorViewStyle = .WhiteLarge
            activityIndecator.startAnimating()
            activityView.addSubview(activityIndecator)
        }
        backgroudView.addSubview(activityView)
        sender.addSubview(backgroudView)
    }
    
    
    //接收子场景的消息步骤二 消息响应函数
    func getMessage(notification:NSNotification) {
        //查看图片细节时删除图片触发
        if notification.object == nil {
            images.removeAtIndex(tempSelectedButton.tag)
            if images.count == 0 {
                tempSelectedButton.setImage(UIImage(named: "addSite1"), forState: .Normal)
            }
            else {
                for index in 0..<images.count {
                    let smallImage = scaleFromImage(images[index], tosize: imageButtons[images.count].bounds.size)
                    self.imageButtons[index].setImage(smallImage, forState: .Normal)
                }
                self.imageButtons[images.count].setImage(UIImage(named: "addSite2"), forState: .Normal)
            }
            if images.count + 1 < maxImageCount {
                self.imageButtons[images.count + 1].setImage(UIImage(named: "addSite3"), forState: .Normal)
            }
        }
        //进入图片数据库时获取图片后返回触发
        else {
            let getImages = notification.object as! Array<UIImage>
            for index in getImages {
//                let smallImage = scaleFromImage(index, tosize: imageButtons[images.count].bounds.size)
                self.imageButtons[images.count].setImage(index, forState: .Normal)
                images.append(index)
            }
            if images.count < maxImageCount {
                self.imageButtons[images.count].setImage(UIImage(named: "addSite2"), forState: .Normal)
            }
        }
    }
    //传入头像图片UIImage和需要的图片大小CGSize，返回修改大小后的UIImage
    func scaleFromImage(image: UIImage, tosize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(tosize)
        image.drawInRect(CGRectMake(0, 0, tosize.width, tosize.height))
        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    //接收子场景的消息步骤三 移除observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let distin = segue.destinationViewController as! PhotoLibraryViewController
        distin.serverMessageIdentity = messageIdentity
        distin.pickImageCount = maxImageCount - images.count
    }
}
