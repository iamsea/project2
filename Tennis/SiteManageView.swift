//
//  SiteManageView.swift
//  Tennis
//
//  Created by seasong on 16/4/18.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

var siteList = Array<Site>()

class SiteManageView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    private var fatherViewController: UIViewController!
    private var collectionView: UICollectionView!
    var messageIdentity = "siteManageViewIdentity"
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        self.fatherViewController = fatherViewController
        backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        loadSiteList()
        loadSiteCollectionView()
        //接收子场景的消息步骤一 注册一个observer来响应子控制器的消息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getMessage), name: messageIdentity, object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSiteList() {
        for index in 0...7 {
            let site = Site()
            site.siteID = index
            site.siteName = "室内\(index)号硬地"
            siteList.append(site)
        }
    }
    
    func loadSiteCollectionView() {
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 13
        flowlayout.minimumLineSpacing = 14.5
        flowlayout.itemSize = CGSizeMake(215, 144)
        flowlayout.scrollDirection = .Vertical
        
        collectionView = UICollectionView(frame: CGRectMake(20, 20, frame.width - 34, frame.height - 40), collectionViewLayout: flowlayout)
        collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "SiteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PCell")
        
    
        let refreshControl = UIRefreshControl()
//        refreshControl.frame.size = CGSizeMake(909.5, 81.5)
        refreshControl.attributedTitle = NSAttributedString(string: "正在更新...")
        refreshControl.tintColor = myGreen
        refreshControl.addTarget(self, action: #selector(collectionViewRefresh), forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
    

        self.addSubview(collectionView)
    }
    
    //刷新数据
    func collectionViewRefresh(sender: UIRefreshControl) {
        print("%%%%%%%%%%%%%%%")
        print(sender.frame)
        print("%%%%%%%%%%%%%%%")
        sender.attributedTitle = NSAttributedString(string: "正在更新...")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.collectionView.reloadData()
            sleep(1)
            
            sender.endRefreshing()
            sender.attributedTitle = NSAttributedString(string: "下拉以刷新")
        }
    }
    
    //collectionView刷新
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return siteList.count + 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PCell", forIndexPath: indexPath) as! SiteCollectionViewCell
        cell.layer.borderWidth = 0.5
        if let imageView = cell.viewWithTag(100) {
            imageView.removeFromSuperview()
        }
        if indexPath.item == siteList.count {
            let imageView = UIImageView()
            imageView.frame = cell.bounds
            imageView.image = UIImage(named: "addSite_normal")
            imageView.tag = 100
            cell.addSubview(imageView)
            cell.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        }
        else {
            cell.layer.borderColor = myGreen.CGColor
            cell.site = siteList[indexPath.item]
            cell.siteTitleLabel.text = siteList[indexPath.item].siteName
        }

        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == siteList.count {
            let addSiteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("addSiteView")
            addSiteViewController.modalPresentationStyle = .FormSheet
//            addSiteViewController.modalTransitionStyle = .FlipHorizontal
            superViewController.presentViewController(addSiteViewController, animated: true, completion: {
                
            })
        }
        else {
            
        }
    }
    
    //接收子场景的消息步骤二 消息响应函数
    func getMessage(notification:NSNotification) {
        collectionView.reloadData()
    }
    //接收子场景的消息步骤三 移除observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
