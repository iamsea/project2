//
//  CenueManageView.swift
//  Tennis
//
//  Created by seasong on 16/4/10.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class CenueManageView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    private var fatherViewController: UIViewController!
    let dateTableViewCellHeight: CGFloat = 40
    var dateButton: UIButton!
    var popover = Popover()
    var dateList = Array<String>()
    let cellWidth: CGFloat = 110
    let cellHeight: CGFloat = 40
    let myGreen = UIColor(red: 44/255, green: 193/255, blue: 93/255, alpha: 1)
    var venuesList = Array<Array<Venue>>()
    var bookVenuesButtonList = Array<VenueUIButton>()
    var bookSureView: UIView!
    var bookVenuesCountLabel: UILabel!
    var bookVenuesPrices: UILabel!
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        self.fatherViewController = fatherViewController
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        bookSureView = UIView(frame: CGRectMake(0, frame.height, frame.width, 44))
        bookSureView.backgroundColor = UIColor(red: 253/255, green: 253/255, blue: 253/255, alpha: 1)
        let label1 = UILabel(frame: CGRectMake(300, 0, 32, 44))
        label1.font = UIFont.systemFontOfSize(16)
        label1.text = "已选"
        label1.textColor = UIColor.darkGrayColor()
        bookVenuesCountLabel = UILabel(frame: CGRectMake(332, 0, 33, 44))
        bookVenuesCountLabel.font = UIFont.systemFontOfSize(18)
        bookVenuesCountLabel.text = "0"
        bookVenuesCountLabel.textAlignment = .Center
        bookVenuesCountLabel.textColor = UIColor.orangeColor()
        let label3 = UILabel(frame: CGRectMake(365, 0, 85, 44))
        label3.font = UIFont.systemFontOfSize(16)
        label3.text = "场        共计"
        label3.textColor = UIColor.darkGrayColor()
        bookVenuesPrices = UILabel(frame: CGRectMake(450, 0, 200, 44))
        bookVenuesPrices.font = UIFont.systemFontOfSize(18)
        bookVenuesPrices.text = "￥0"
        bookVenuesPrices.textColor = UIColor.orangeColor()
        
        let submitOrderButton = UIButton(type: .System)
        submitOrderButton.frame = CGRectMake(frame.width - 140, 4, 120, 36)
//        submitOrderButton.layer.borderWidth = 0.5
//        submitOrderButton.layer.borderColor = myGreen.CGColor
        submitOrderButton.layer.cornerRadius = 18
        submitOrderButton.setTitle("提交订单", forState: .Normal)
        submitOrderButton.tintColor = myGreen
        submitOrderButton.addTarget(self, action: #selector(CenueManageView.submitOrderButtonClick), forControlEvents: .TouchUpInside)
        
        bookSureView.addSubview(label1)
        bookSureView.addSubview(bookVenuesCountLabel)
        bookSureView.addSubview(label3)
        bookSureView.addSubview(bookVenuesPrices)
        bookSureView.addSubview(submitOrderButton)
        self.addSubview(bookSureView)
        
        loadVenueData("0411") //加载今天(0411)的场馆数据
        loadSomeData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSomeData() {
        dateList.append("今天")
        dateList.append("明天")
        for index in 13...15 {
            dateList.append("4月\(index)日")
        }
    }
    
    func loadVenueData(date:String) {
        //场地列表
        var siteList = Array<Site>()
        for index in 0...5 {
            let site = Site()
            site.siteName = "室内\(index)号硬地"
            site.siteID = index
            siteList.append(site)
        }
        
        //某天的场馆打位数据
        for i in 0..<siteList.count {
            var array = Array<Venue>()
            for j in 0...14 {
                let venue = Venue()
                venue.venueID = Int("\(i)\(j)")!
                venue.siteId = i
                array.append(venue)
            }
            venuesList.append(array)
        }
        
        //表头
        for index in 0...venuesList.count {
            let x = (cellWidth - 1) * CGFloat(index) + 20
            let y: CGFloat = 20
            if index == 0 {
                dateButton = UIButton(type: .System)
                dateButton.frame = CGRectMake(x, y, cellWidth, cellHeight)
                dateButton.setTitle("今天", forState: .Normal)
                dateButton.tintColor = myGreen
                dateButton.layer.borderWidth = 0.5
                dateButton.layer.borderColor = myGreen.CGColor
                dateButton.backgroundColor = UIColor.whiteColor()
                dateButton.addTarget(self, action: #selector(CenueManageView.timePickerButtonClick), forControlEvents: .TouchUpInside)
                self.addSubview(dateButton)
            }
            else {
                let label = UILabel()
                label.frame = CGRectMake(x, y, cellWidth, cellHeight)
                label.layer.borderWidth = 0.5
                label.layer.borderColor = myGreen.CGColor
                label.backgroundColor = UIColor.whiteColor()
                label.text = siteList[index - 1].siteName
                label.font = UIFont.systemFontOfSize(14)
                label.textAlignment = .Center
                self.addSubview(label)
            }
        }
        
        //ScrollView
        let scrollView = UIScrollView()
        scrollView.frame = CGRectMake(20, 20 + cellHeight - 1, self.bounds.width - 40, self.bounds.height - 20 - cellHeight + 1)  //设置scrollview的大小
        scrollView.contentSize = CGSizeMake(self.bounds.width - 40, CGFloat(venuesList[0].count + 1) * cellHeight)   //内容大小
    
        //第一列
        for index in 0..<venuesList[0].count {
            let button = UIButton(type: UIButtonType.System)
            let x = CGFloat(0)
            let y = (cellHeight - 1) * (CGFloat)(index)
            button.frame = CGRectMake(x, y, cellWidth, cellHeight)
            button.backgroundColor = UIColor.whiteColor()
            button.layer.borderWidth = 0.5
            button.layer.borderColor = myGreen.CGColor
            button.setTitle(String(format: "%02d", index + 7) + ":00", forState: UIControlState.Normal)
            button.tintColor = UIColor.blackColor()
            
            scrollView.addSubview(button)
        }
        
        for i in 0..<venuesList.count {
            for j in 0..<venuesList[0].count {
                let button = VenueUIButton(type: UIButtonType.System)
                let x = (cellWidth - 1) * CGFloat(i + 1) //表第一列的长度比其它列的长度长40pixel 减1使边框为1pixel
                let y = (cellHeight - 1) * CGFloat(j)
                button.frame = CGRectMake(x, y, cellWidth, cellHeight)
                button.backgroundColor = UIColor.whiteColor()
                button.layer.borderWidth = 0.5
                button.layer.borderColor = myGreen.CGColor
                button.venue = venuesList[i][j]
                if button.venue.isBooked {
                    button.setTitle("已预定", forState: UIControlState.Normal)
                    button.backgroundColor = UIColor(red: 211/255, green: 255/255, blue: 191/255, alpha: 1)
                }
                else {
                    button.setTitle(String(format: "%.2f", venuesList[i][j].price), forState: .Normal)
                }
                button.tintColor = myGreen
                button.addTarget(self, action: #selector(CenueManageView.bookButtonClick), forControlEvents: .TouchUpInside)
                
                scrollView.addSubview(button)
            }
        }

        self.addSubview(scrollView)
    }
    
    //时间选择按钮
    func timePickerButtonClick(sender: UIButton) {

        let dateTable = UITableView()
        dateTable.delegate = self
        dateTable.dataSource = self
        dateTable.tableFooterView = UIView(frame: CGRectZero)
        dateTable.separatorColor = UIColor.clearColor()
        dateTable.frame = CGRectMake(0, 0, 120, CGFloat(dateList.count) * dateTableViewCellHeight - 2)

        let pop = Popover()
//        pop.show(dateTable, point: CGPoint(x: 156, y: 113))
        pop.show(dateTable, fromView: sender)
        
        //loadVenueData("0411")
    }
    
    //选择场馆
    func bookButtonClick(sender: VenueUIButton) {
        if sender.venue.isBooked {
            let alert = UIAlertController(title: "提示", message: "撤销此订单？", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: { (UIAlertAction) in
                sender.venue.isBooked = false
                sender.backgroundColor = UIColor.whiteColor()
                sender.setTitle(String(format: "%.2f", sender.venue.price), forState: .Normal)
            })
            alert.view.tintColor = myGreen
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.fatherViewController.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            //sender.venue.isBooked = true
            if bookVenuesButtonList.count != 0 {
                let count = bookVenuesButtonList.count
                for index in 0..<bookVenuesButtonList.count {
                    if bookVenuesButtonList[index] == sender {
                        //sender.backgroundColor = UIColor.whiteColor()
                        sender.setTitleColor(myGreen, forState: .Normal)
                        bookVenuesButtonList.removeAtIndex(index)
                        break
                    }
                }
                if count == bookVenuesButtonList.count {
                    //sender.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1)
                    sender.setTitleColor(UIColor.orangeColor(), forState: .Normal)
                    bookVenuesButtonList.append(sender)
                }
            }
            else {
                //sender.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1)
                sender.setTitleColor(UIColor.orangeColor(), forState: .Normal)
                bookVenuesButtonList.append(sender)
            }
        }
        if bookVenuesButtonList.count != 0 {
            bookVenuesCountLabel.text = "\(bookVenuesButtonList.count)"
            var prices = 0.0
            for index in bookVenuesButtonList {
                prices = prices + index.venue.price
            }
            bookVenuesPrices.text = String(format: "￥%.2f", prices)
            UIView.animateWithDuration(0.3, animations: {
                self.bookSureView.frame.origin.y = self.frame.height - 44
            })
            self.bringSubviewToFront(self.bookSureView)
        }
        else {
            UIView.animateWithDuration(0.3, animations: {
                self.bookSureView.frame.origin.y = self.frame.height
            })
        }
    }
    
    //提交订单
    func submitOrderButtonClick() {
        let alert = UIAlertController(title: "提示", message: "订单提交成功！", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
        //alert.view.tintColor = myGreen
        okAction.setValue(myGreen, forKey: "_titleTextColor")
        alert.addAction(okAction)
        //alert.setValue(myGreen, forKey: "tintColor")
        self.fatherViewController.presentViewController(alert, animated: true, completion: nil)
        for index in self.bookVenuesButtonList {
            index.venue.isBooked = true
            index.setTitle("已预定", forState: .Normal)
            index.setTitleColor(self.myGreen, forState: .Normal)
            index.backgroundColor = UIColor(red: 211/255, green: 255/255, blue: 191/255, alpha: 1)
        }
        self.bookVenuesButtonList.removeAll()
        UIView.animateWithDuration(0.3, animations: {
            self.bookSureView.frame.origin.y = self.frame.height
        })
    }
    
    //代理tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dateList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return dateTableViewCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
//        
//        cell.textLabel?.text = dateList[indexPath.row]
//        
//        return cell
        
        let identifier="identtifier";
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier);
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.Default
        cell?.textLabel?.text = dateList[indexPath.row]
        cell?.textLabel?.textAlignment = .Center
        cell!.textLabel!.textColor = myGreen
//        let label = UILabel()
//        label.frame = (cell?.frame)!
//        label.text = dateList[indexPath.row]
//        label.tintColor = myGreen
//        label.textAlignment = .Center
//        cell?.addSubview(label)
        // cell?.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dateButton.setTitle(dateList[indexPath.row], forState: .Normal)
        popover.dismiss()
    }
    
    /*override func drawRect(rect: CGRect) {
        self.frame = CGRectMake(200, 0, 200, 200)
        self.backgroundColor = UIColor.redColor()
    }*/
}
