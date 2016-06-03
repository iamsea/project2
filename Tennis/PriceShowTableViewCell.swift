//
//  PriceShowTableViewCell.swift
//  Tennis
//
//  Created by seasong on 16/5/14.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class PriceShowTableViewCell: UITableViewCell {

    let cellWidth: CGFloat = 110
    let cellHeight: CGFloat = 40
    var scrollView: UIScrollView!
//    var venuesList: Array<Array<Venue>>!
    var date = String()
    var dayTimeCount = 15
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        loadPriceData()
    }
    
    //加载价格数据表
    func loadPriceData() {
        
        //场地列表
        var siteList = Array<Site>()
        for index in 0...5 {
            let site = Site()
            site.siteName = "室内\(index)号硬地"
            site.siteID = index
            siteList.append(site)
        }
        //某天的场馆打位数据
//        venuesList = Array<Array<Venue>>()
//        for i in 0..<siteList.count {
//            var array = Array<Venue>()
//            for j in 0...14 {
//                let venue = Venue()
//                venue.venueID = Int("\(i)\(j)")!
//                venue.siteId = i
//                array.append(venue)
//            }
//            venuesList.append(array)
//        }
        
        //ScrollView
        scrollView = UIScrollView(frame: CGRectMake(0, 0, (self.superview?.frame.width)!, self.bounds.height))  //设置scrollview的大小
        scrollView.contentSize = CGSizeMake((cellWidth - 1) * CGFloat(siteList.count + 1) + 1, CGFloat(dayTimeCount) * cellHeight)   //内容大小
        scrollView.showsHorizontalScrollIndicator = false

        //表头
        for index in 0...siteList.count {
            let x = (cellWidth - 1) * CGFloat(index)
            let y: CGFloat = 0
            if index == 0 {
                let button = UIButton(type: .System)
                button.frame = CGRectMake(x, y, cellWidth, cellHeight)
                //                button.setTitle("今天", forState: .Normal)
                //                button.tintColor = myGreen
                button.layer.borderWidth = 0.5
                button.layer.borderColor = myGreen.CGColor
                button.backgroundColor = UIColor.whiteColor()
                //                dateButton.addTarget(self, action: #selector(CenueManageView.timePickerButtonClick), forControlEvents: .TouchUpInside)
                scrollView.addSubview(button)
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
                scrollView.addSubview(label)
            }
        }
        
        //第一列
        for index in 0..<dayTimeCount {
            let button = UIButton(type: UIButtonType.System)
            let x = CGFloat(0)
            let y = (cellHeight - 1) * (CGFloat)(index + 1)
            button.frame = CGRectMake(x, y, cellWidth, cellHeight)
            button.backgroundColor = UIColor.whiteColor()
            button.layer.borderWidth = 0.5
            button.layer.borderColor = myGreen.CGColor
            button.setTitle(String(format: "%02d", index + 7) + ":00", forState: UIControlState.Normal)
            button.tintColor = UIColor.blackColor()
            
            scrollView.addSubview(button)
        }
        
//        for i in 0..<priceList.count {
//            for j in 0..<priceList[0].count {
//                let label = UILabel()
//                let x = (cellWidth - 1) * CGFloat(i + 1) //表第一列的长度比其它列的长度长40pixel 减1使边框为1pixel
//                let y = (cellHeight - 1) * CGFloat(j + 1)
//                label.frame = CGRectMake(x, y, cellWidth, cellHeight)
//                label.backgroundColor = UIColor.whiteColor()
//                label.layer.borderWidth = 0.5
//                label.layer.borderColor = myGreen.CGColor
//                label.text = String(format: "%.2f", priceList[i][j])
//                label.font = UIFont.systemFontOfSize(15)
//                label.textAlignment = .Center
//                scrollView.addSubview(label)
//            }
//        }
        for index in self.subviews {
            index.removeFromSuperview()
        }
//        self.addSubview(scrollView)
    }
    

}
