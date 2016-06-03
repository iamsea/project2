//
//  PhotoLibraryViewController.swift
//  Tennis
//
//  Created by seasong on 16/5/4.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit
import Photos

var checkedImageNOList = Dictionary<Int, Int>()
var libraryNeedImageCount = 0

class PhotoLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var checkImageNumberView: UIView!
    @IBOutlet weak var checkImageNumberLabel: UILabel!
    @IBOutlet weak var cancelOrDoneButton: UIButton!
    
    //所需图片数量
    var pickImageCount = 0
    
    //保存照片集合
    var assets = [PHAsset]()
    var checkImageAssets = [PHAsset]()
    
    //父视图接受消息标志
    var serverMessageIdentity: String!
    
    var imageScrollView: UIScrollView!
    var imageDetailView: UIImageView!
    var imageOriginalFrame: CGRect!
    var toolBarView: UIView!
    var footToolBarView: UIView!
    var tempCollectionItem: Int!
    var detailCheckImageCountLabel: UILabel!
    var detailChekDoneButton: UIButton!
    var collectionCellIsCheck = false
    var tempIndexPath: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        libraryNeedImageCount = pickImageCount
        
        var fetchResult: PHFetchResult
        let smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(.Moment, subtype: .AlbumRegular, options: nil)
        for index in 0..<smartAlbums.count {
            let collect = smartAlbums[index]
            if collect.isKindOfClass(PHAssetCollection) {
                let assetCollection = collect as! PHAssetCollection
                let fetchOptions = PHFetchOptions()
                fetchResult = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: fetchOptions)
                for index in 0..<fetchResult.count {
                    assets.append(fetchResult[index] as! PHAsset)
                }
            }
                
            else {
                print("Fetch collection not PHCollection")
            }
            
        }
        let shadeView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        shadeView.frame = self.checkImageNumberView.frame
        checkImageNumberView.addSubview(shadeView)
        
        //接收imageCell的消息步骤一 注册一个observer来响应子控制器的消息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getMessage), name: "messageFromImageLibraryCollectionViewCell", object: nil)
        
        let notification = NSNotificationCenter.defaultCenter()
        notification.postNotificationName("hideStatusBar", object: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        checkedImageNOList.removeAll()
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewWillDisappear(animated: Bool) {
        let notification = NSNotificationCenter.defaultCenter()
        notification.postNotificationName("hideStatusBar", object: false)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return assets.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PCell", forIndexPath: indexPath) as! ImageLibraryCollectionViewCell
        cell.cellNo = indexPath.item 
        if indexPath.item == 0 {
            cell.imageView.image = UIImage(named: "camera_normal")!
            if cell.checkImageButton != nil {
                cell.checkImageButton.removeFromSuperview()
            }
        }
        else {
            let initialRequestOptions = PHImageRequestOptions()
            initialRequestOptions.synchronous = true
            initialRequestOptions.resizeMode = .Fast
            initialRequestOptions.deliveryMode = .FastFormat
            let manager = PHImageManager.defaultManager()
            manager.requestImageForAsset(self.assets[indexPath.item - 1], targetSize: CGSize(width: 250.0, height: 250.0), contentMode: .AspectFit, options: initialRequestOptions, resultHandler: { (initialResult, _) in
                cell.imageView.image = initialResult
            })
        }

        if checkedImageNOList.count != 0 {
            if (checkedImageNOList.indexForKey(indexPath.item) != nil) {
                cell.cellIsCheck = true
                cell.checkImageButton.setImage(UIImage(named: "check_pressed"), forState: .Normal)
            }
            else {
                cell.cellIsCheck = false
                cell.checkImageButton.setImage(UIImage(named: "check_normal"), forState: .Normal)
            }
            checkImageNumberLabel.text = "\(checkedImageNOList.count)"
            checkImageNumberLabel.transform = CGAffineTransformIdentity
            checkImageNumberLabel.alpha = 1
            cancelOrDoneButton.setTitle("完成", forState: .Normal)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        tempIndexPath = indexPath
        
        if indexPath.item == 0 {
            let picker: UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                picker.sourceType = .Camera
                self.presentViewController(picker, animated: true, completion: nil)
            }
            else {
                print("不支持拍照")
            }
        }
        else {
            tempCollectionItem = indexPath.item
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageLibraryCollectionViewCell
            collectionCellIsCheck = cell.cellIsCheck
            imageOriginalFrame = cell.frame
//            imageOriginalFrame.origin.y += 20
            imageScrollView = UIScrollView(frame: imageOriginalFrame)
            imageScrollView.backgroundColor = UIColor.blackColor()
            
            imageDetailView = UIImageView(frame: imageScrollView.bounds)
            imageDetailView.contentMode = .ScaleAspectFit
            imageDetailView.clipsToBounds = true
            imageScrollView.maximumZoomScale = 5.0
            imageScrollView.minimumZoomScale = 1.0
            imageScrollView.delegate = self
            imageScrollView.showsVerticalScrollIndicator = false
            imageScrollView.showsHorizontalScrollIndicator = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapBegan))
            imageScrollView.addGestureRecognizer(tap)
            
            //获取原图
            let initialRequestOptions = PHImageRequestOptions()
            initialRequestOptions.synchronous = true
            initialRequestOptions.resizeMode = .None
            initialRequestOptions.deliveryMode = .HighQualityFormat
            let manager = PHImageManager.defaultManager()
            manager.requestImageForAsset(self.assets[indexPath.item - 1], targetSize: CGSize(width: 800, height: 800), contentMode: .AspectFill, options: initialRequestOptions, resultHandler: { (initialResult, _) in
                self.imageDetailView.image = initialResult
            })

            imageScrollView.addSubview(imageDetailView)
            imageScrollView.contentSize = imageDetailView.bounds.size
            self.view.addSubview(imageScrollView)
            
            let width = self.view.bounds.width
            let height = self.view.bounds.height
            let imageWidth = imageDetailView.image?.size.width
            let imageHeight = imageDetailView.image?.size.height
            let imageViewWidth = width
            let imageViewHeight = min(imageViewWidth * imageHeight! / imageWidth!, height)
            
            UIView.animateWithDuration(0.3, animations: {
                self.imageScrollView.center.x = self.view.center.x
                self.imageScrollView.center.y = self.view.center.y
                self.imageScrollView.bounds.size = self.view.bounds.size
                self.imageDetailView.center.x = self.view.center.x
                self.imageDetailView.center.y = self.view.center.y
                self.imageDetailView.bounds.size = CGSizeMake(imageViewWidth, imageViewHeight)
                }, completion: { (true) in
                    self.loadToolBarView()
                })
        }
    }
    
    //scrollViewDelegete
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageDetailView
    }
    
    //加载查看图片细节时的工具条
    func loadToolBarView() {
        toolBarView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 64))
        let backVisualView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        backVisualView.frame = toolBarView.bounds
        toolBarView.addSubview(backVisualView)
        let backButton = UIButton(frame: CGRectMake(15, 5, 54, 54))
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(breakImageDetailView), forControlEvents: .TouchUpInside)
        toolBarView.addSubview(backButton)
        let chekButton = UIButton(frame: CGRectMake(self.view.bounds.width - 60, 12, 40, 40))
        if collectionCellIsCheck {
            chekButton.setImage(UIImage(named: "check_pressed"), forState: .Normal)
        } else {
            chekButton.setImage(UIImage(named: "check_normal"), forState: .Normal)
        }
        chekButton.addTarget(self, action: #selector(checkButtonClick), forControlEvents: .TouchUpInside)
        toolBarView.addSubview(chekButton)
        
        
        footToolBarView = UIView(frame: CGRectMake(0, self.view.bounds.height - 44, self.view.bounds.width, 44))
        let backVisualView2 = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        backVisualView2.frame = footToolBarView.bounds
        footToolBarView.addSubview(backVisualView2)
        detailCheckImageCountLabel = UILabel(frame: CGRectMake(self.view.bounds.width - 106, 11, 24, 24))
        detailCheckImageCountLabel.backgroundColor = myGreen
        detailCheckImageCountLabel.layer.cornerRadius = 12
        detailCheckImageCountLabel.layer.masksToBounds = true
        detailCheckImageCountLabel.textAlignment = .Center
        detailCheckImageCountLabel.textColor = UIColor.whiteColor()
        footToolBarView.addSubview(detailCheckImageCountLabel)
        detailChekDoneButton = UIButton(type: .System)
        detailChekDoneButton.frame = CGRectMake(self.view.bounds.width - 90, 0, 83, 44)
        detailChekDoneButton.titleLabel?.textAlignment = .Right
        detailChekDoneButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        detailChekDoneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        detailChekDoneButton.addTarget(self, action: #selector(imageDetailViewDoneButtonClick), forControlEvents: .TouchUpInside)
        footToolBarView.addSubview(detailChekDoneButton)
        toolBarView.frame.origin.y -= 64
        footToolBarView.frame.origin.y += 44
        
        if checkedImageNOList.count == 0 {
            detailCheckImageCountLabel.alpha = 0
            detailChekDoneButton.setTitle("取消", forState: .Normal)
        }
        else {
            detailCheckImageCountLabel.alpha = 1
            detailCheckImageCountLabel.text = "\(checkedImageNOList.count)"
            detailChekDoneButton.setTitle("完成", forState: .Normal)
        }
        
        self.view.addSubview(toolBarView)
        self.view.addSubview(footToolBarView)
        UIView.animateWithDuration(0.4) {
            self.toolBarView.frame.origin.y += 64
            self.footToolBarView.frame.origin.y -= 44
        }
    }
    
    //从查看图片细节返回主视图
    func breakImageDetailView() {
        toolBarView.removeFromSuperview()
        footToolBarView.removeFromSuperview()
        self.imageDetailView.contentMode = .ScaleAspectFill
        UIView.animateWithDuration(0.3, animations: { 
            self.imageScrollView.frame = self.imageOriginalFrame
            self.imageDetailView.frame = self.imageScrollView.bounds
            
//            self.imageScrollView.alpha = 0
            }) { (true) in
                self.imageScrollView.removeFromSuperview()
//                self.photoCollectionView.reloadData()
//                self.collectionViewreloadSections:[NSIndexSetindexSetWithIndex:0]
                
                self.photoCollectionView.reloadItemsAtIndexPaths([self.tempIndexPath])
        }
    }
    //点击图片细节视图中的选中按钮
    func checkButtonClick(sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "check_normal") {
            if checkedImageNOList.count < libraryNeedImageCount {
                sender.setImage(UIImage(named: "check_pressed"), forState: .Normal)
                let transform = CGAffineTransformMakeScale(0.5, 0.5)
                sender.transform = transform
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 10, options: [], animations: {
                    sender.transform = CGAffineTransformIdentity
                    }, completion: nil)
                checkedImageNOList[tempCollectionItem] = tempCollectionItem
                
                if checkedImageNOList.count != 0 {
                    self.detailCheckImageCountLabel.transform = CGAffineTransformMakeScale(0, 0)
                    detailCheckImageCountLabel.alpha = 1
                    detailCheckImageCountLabel.text = String(checkedImageNOList.count)
                    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 8, options: [], animations: {
                        self.detailCheckImageCountLabel.transform = CGAffineTransformIdentity
                        }, completion: nil)
                    detailChekDoneButton.setTitle("完成", forState: .Normal)
                    
                }
                else {
                    if detailCheckImageCountLabel.alpha == 1 {
                        UIView.animateWithDuration(0.3, animations: {
                            self.detailCheckImageCountLabel.transform = CGAffineTransformMakeScale(0.4, 0.4)
                            self.detailCheckImageCountLabel.alpha = 0
                            }, completion: { (true) in
                                //self.checkImageNumberLabel.alpha = 0
                        })
                    }
                    detailChekDoneButton.setTitle("取消", forState: .Normal)
                }
                
            }
            else {
                let alert = UIAlertController(title: "提示", message: "当前最多只能选择\(libraryNeedImageCount)张图片", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "好", style: .Default, handler: nil)
                okAction.setValue(myGreen, forKey: "_titleTextColor")
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: { (true) in
                    return
                })
            }
        }
        else {
            sender.setImage(UIImage(named: "check_normal"), forState: .Normal)
            checkedImageNOList.removeValueForKey(tempCollectionItem)
            
            if checkedImageNOList.count != 0 {
                self.detailCheckImageCountLabel.transform = CGAffineTransformMakeScale(0, 0)
                detailCheckImageCountLabel.alpha = 1
                detailCheckImageCountLabel.text = String(checkedImageNOList.count)
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 8, options: [], animations: {
                    self.detailCheckImageCountLabel.transform = CGAffineTransformIdentity
                    }, completion: nil)
                detailChekDoneButton.setTitle("完成", forState: .Normal)
                
            }
            else {
                if detailCheckImageCountLabel.alpha == 1 {
                    UIView.animateWithDuration(0.3, animations: {
                        self.detailCheckImageCountLabel.transform = CGAffineTransformMakeScale(0.4, 0.4)
                        self.detailCheckImageCountLabel.alpha = 0
                        }, completion: { (true) in
                            //self.checkImageNumberLabel.alpha = 0
                    })
                }
                detailChekDoneButton.setTitle("取消", forState: .Normal)
            }
            
        }
    }
    
    //点击图片细节视图中的完成按钮
    func imageDetailViewDoneButtonClick() {
        if checkedImageNOList.count != 0 {
            var checkedImages = Array<UIImage>()
            for index in checkedImageNOList.keys {
                let temp = checkedImageNOList[index]! - 1
                
                //获取原图
                let initialRequestOptions = PHImageRequestOptions()
                initialRequestOptions.synchronous = true
                initialRequestOptions.resizeMode = .None
                initialRequestOptions.deliveryMode = .HighQualityFormat
                let manager = PHImageManager.defaultManager()
                manager.requestImageForAsset(assets[temp], targetSize: CGSize(width: 800, height: 800), contentMode: .AspectFill, options: initialRequestOptions, resultHandler: { (initialResult, _) in
                    checkedImages.append(initialResult!)
                })
                
//                checkImageAssets.append(assets[temp! - 1])
            }
            self.dismissViewControllerAnimated(true) {
                //发送消息
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName(self.serverMessageIdentity, object: checkedImages)
            }
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //单击图片细节视图中的scrollView
    func tapBegan() {
        if toolBarView.frame.origin.y == 0 && imageScrollView != nil {
            UIView.animateWithDuration(0.4) {
                self.toolBarView.frame.origin.y -= 64
                self.footToolBarView.frame.origin.y += 44
            }
        }
        else {
            UIView.animateWithDuration(0.4) {
                self.toolBarView.frame.origin.y += 64
                self.footToolBarView.frame.origin.y -= 44
            }
        }

    }
    
    //UIImagePickerControllerDelegate代理，拍照完成后调用的函数
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageGet = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        //发送消息
        let notification = NSNotificationCenter.defaultCenter()
        notification.postNotificationName(serverMessageIdentity, object: imageGet)
        picker.dismissViewControllerAnimated(true, completion: nil)
//        self.navigationController?.popViewControllerAnimated(false)
        self.dismissViewControllerAnimated(false) { 
            
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

 
    @IBAction func doneOrCancelButtonClick(sender: AnyObject) {
//        if checkedImageNOList.count != 0 {
//            for index in checkedImageNOList.keys {
//                let temp = checkedImageNOList[index]
//                checkImageAssets.append(assets[temp! - 1])
//            }
//            self.dismissViewControllerAnimated(true) {
//                //发送消息
//                let notification = NSNotificationCenter.defaultCenter()
//                notification.postNotificationName(self.serverMessageIdentity, object: self.checkImageAssets)
//            }
//        }
//        else {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
        if checkedImageNOList.count != 0 {
            var checkedImages = Array<UIImage>()
            for index in checkedImageNOList.keys {
                let temp = checkedImageNOList[index]! - 1
                
                //获取原图
                let initialRequestOptions = PHImageRequestOptions()
                initialRequestOptions.synchronous = true
                initialRequestOptions.resizeMode = .None
                initialRequestOptions.deliveryMode = .HighQualityFormat
                let manager = PHImageManager.defaultManager()
                manager.requestImageForAsset(assets[temp], targetSize: CGSize(width: 800, height: 800), contentMode: .AspectFill, options: initialRequestOptions, resultHandler: { (initialResult, _) in
                    checkedImages.append(initialResult!)
                })
                
                //                checkImageAssets.append(assets[temp! - 1])
            }
            self.dismissViewControllerAnimated(true) {
                //发送消息
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName(self.serverMessageIdentity, object: checkedImages)
            }
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
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
    //接收imageCell的消息步骤二 消息响应函数
    func getMessage(notification:NSNotification) {
        if notification.object != nil {
            let alert = UIAlertController(title: "提示", message: "当前最多只能选择\(libraryNeedImageCount)张图片", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "好", style: .Default, handler: nil)
            okAction.setValue(myGreen, forKey: "_titleTextColor")
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            if checkedImageNOList.count != 0 {
                self.checkImageNumberLabel.transform = CGAffineTransformMakeScale(0, 0)
                checkImageNumberLabel.alpha = 1
                checkImageNumberLabel.text = String(checkedImageNOList.count)
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 8, options: [], animations: {
                    self.checkImageNumberLabel.transform = CGAffineTransformIdentity
                    }, completion: nil)
                cancelOrDoneButton.setTitle("完成", forState: .Normal)
                
            }
            else {
                if checkImageNumberLabel.alpha == 1 {
                    UIView.animateWithDuration(0.3, animations: {
                        self.checkImageNumberLabel.transform = CGAffineTransformMakeScale(0.4, 0.4)
                        self.checkImageNumberLabel.alpha = 0
                        }, completion: { (true) in
                            //                        self.checkImageNumberLabel.alpha = 0
                    })
                }
                cancelOrDoneButton.setTitle("取消", forState: .Normal)
            }
        }
    }
    
    //接收imageCell的消息步骤三 移除observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

}
