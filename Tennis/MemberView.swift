//
//  MemberView.swift
//  Tennis
//
//  Created by seasong on 16/4/11.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class MemberView: UIView, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let allInformationView = UIView(frame: CGRectMake(20, 22, 280, frame.height - 42))
        allInformationView.backgroundColor = UIColor.whiteColor()
        
        let memberCount = UILabel(frame: CGRectMake(60, 220, 160, 30))
        memberCount.text = "会员总人数：100人"
        memberCount.font = UIFont.systemFontOfSize(16)
        allInformationView.addSubview(memberCount)
        
        let allMemberManney = UILabel(frame: CGRectMake(60, 280, 160, 30))
        allMemberManney.text = "会员总余额：¥10000"
        allMemberManney.font = UIFont.systemFontOfSize(16)
        allInformationView.addSubview(allMemberManney)
        
        let addButton = UIButton(type: .System)
        addButton.frame = CGRectMake(90, 360, 100, 30)
        addButton.setTitle("添加会员", forState: .Normal)
        addButton.tintColor = myGreen
        addButton.layer.cornerRadius = 15
        addButton.layer.borderWidth = 0.5
        addButton.layer.borderColor = myGreen.CGColor
        allInformationView.addSubview(addButton)
        
        self.addSubview(allInformationView)
        
        let seachBar = UISearchBar(frame: CGRectMake(312.5, 15, frame.width - 325, 44))
        seachBar.backgroundImage = UIImage()
        seachBar.barTintColor = UIColor.groupTableViewBackgroundColor()
        let searchField = seachBar.valueForKey("searchField") as? UITextField
        if searchField != nil {
            searchField?.backgroundColor = UIColor.whiteColor()
            searchField?.layer.cornerRadius = 14
            searchField?.layer.borderWidth = 0.5
            searchField?.layer.borderColor = UIColor.lightGrayColor().CGColor
            searchField?.layer.masksToBounds = true
        }
        seachBar.tintColor = myGreen
        seachBar.placeholder = "会员编号或会员名"
        seachBar.delegate = self
        self.addSubview(seachBar)
        
        loadMemberCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    func loadMemberCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 13
        flowLayout.minimumLineSpacing = 13
        flowLayout.itemSize = CGSizeMake(295, 141)
        flowLayout.scrollDirection = .Vertical
        
        let collectionView = UICollectionView(frame: CGRectMake(320, 62, frame.width - 340, frame.height - 82), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "MemberCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PCell")
        
        self.addSubview(collectionView)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PCell", forIndexPath: indexPath)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        return cell
    }
}
