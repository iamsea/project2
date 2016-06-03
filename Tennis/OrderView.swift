//
//  OrderView.swift
//  Tennis
//
//  Created by seasong on 16/4/18.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class OrderView: UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private var fatherViewController: UIViewController!
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        self.fatherViewController = fatherViewController
        backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let toolBarView = UIView(frame: CGRectMake(0, 0, frame.width, 44))
        toolBarView.backgroundColor = UIColor.groupTableViewBackgroundColor()

        let dateButton = UIButton(type: UIButtonType.System)
        dateButton.frame = CGRectMake(20, 8, 150, 28)
        dateButton.backgroundColor = UIColor.whiteColor()
        dateButton.layer.cornerRadius = 14
//        dateButton.layer.borderWidth = 0.5
//        dateButton.layer.borderColor = myGreen.CGColor
        dateButton.setTitle("全部订单", forState: .Normal)
        dateButton.tintColor = myGreen
        toolBarView.addSubview(dateButton)

        let seachBar = UISearchBar(frame: CGRectMake(500, 0, 300, 44))
        seachBar.frame.size = CGSizeMake(300, 44)
        seachBar.center = toolBarView.center
        seachBar.backgroundImage = UIImage()
        seachBar.barTintColor = UIColor.groupTableViewBackgroundColor()
        let searchField = seachBar.valueForKey("searchField") as? UITextField
        if searchField != nil {
            searchField?.backgroundColor = UIColor.whiteColor()
            searchField?.layer.cornerRadius = 14
//            searchField?.layer.borderWidth = 0.5
//            searchField?.layer.borderColor = myGreen.CGColor
            searchField?.layer.masksToBounds = true
        }
        seachBar.tintColor = myGreen
        seachBar.placeholder = "订单号或用户名"
        seachBar.delegate = self
        toolBarView.addSubview(seachBar)
        
        self.addSubview(toolBarView)
        
        let orderTableView = UITableView()
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.frame = CGRectMake(20, 44, frame.width - 40, frame.height - 64)
        orderTableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        orderTableView.registerNib(UINib(nibName: "OrderListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderListTableViewCell")
        
        //tableViewCell分割线、sectionHeader问题
        orderTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        if orderTableView.respondsToSelector(Selector("setSeparatorInset:")){
            orderTableView.separatorInset = UIEdgeInsetsZero
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉以刷新")
        refreshControl.tintColor = myGreen
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        orderTableView.addSubview(refreshControl)
        self.addSubview(orderTableView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh(sender: UIRefreshControl) {
        sender.attributedTitle = NSAttributedString(string: "正在更新...")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in

            sleep(1)//休眠3秒
            
            sender.endRefreshing()
            sender.attributedTitle = NSAttributedString(string: "下拉以刷新")
            
            
        }
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "2016-06-0\(section)"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderListTableViewCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
}
