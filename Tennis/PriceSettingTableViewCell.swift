//
//  PriceSettingTableViewCell.swift
//  Tennis
//
//  Created by seasong on 16/5/14.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class PriceSettingTableViewCell: UITableViewCell {

    let cellWidth: CGFloat = 110
    let cellHeight: CGFloat = 40
    var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        loadPriceData()
    }
    
    //加载价格数据表
    func loadPriceData() {
        
        //场地列表
        var siteList = Array<Site>()
        for index in 0...7 {
            let site = Site()
            site.siteName = "室内\(index)号硬地"
            site.siteID = index
            siteList.append(site)
        }
        //某天的场馆打位数据
        var venuesList = Array<Array<Venue>>()
        for i in 0...siteList.count {
            var array = Array<Venue>()
            for j in 0...14 {
                let venue = Venue()
                venue.venueID = Int("\(i)\(j)")!
                venue.siteId = i
                array.append(venue)
            }
            venuesList.append(array)
        }
        
        //ScrollView
        scrollView = UIScrollView(frame: CGRectMake(0, 0, (self.superview?.frame.width)!, CGFloat(venuesList[0].count + 1) * cellHeight))  //设置scrollview的大小
        scrollView.contentSize = CGSizeMake((cellWidth - 1) * CGFloat(siteList.count + 2) + 1, CGFloat(venuesList[0].count + 1) * cellHeight)   //内容大小
        scrollView.showsHorizontalScrollIndicator = false
        
        //表头
        for index in 0...siteList.count + 1 {
            let x = (cellWidth - 1) * CGFloat(index)
            let y: CGFloat = 0
            if index == 0 || index == 1 {
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
                label.text = siteList[index - 2].siteName
                label.font = UIFont.systemFontOfSize(14)
                label.textAlignment = .Center
                scrollView.addSubview(label)
            }
        }
        
        //第一列
        for index in 0..<venuesList[0].count {
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
        
        for i in 0..<venuesList.count {
            for j in 0..<venuesList[0].count {
                let textField = UITextField()
                let x = (cellWidth - 1) * CGFloat(i + 1) //表第一列的长度比其它列的长度长40pixel 减1使边框为1pixel
                let y = (cellHeight - 1) * CGFloat(j + 1)
                textField.frame = CGRectMake(x, y, cellWidth, cellHeight)
                textField.backgroundColor = UIColor.whiteColor()
                textField.layer.borderWidth = 0.5
                textField.layer.borderColor = myGreen.CGColor
                if i == 0 {
                    textField.placeholder = "当行价格"
                }
                else {
                    textField.placeholder = "价格"
                }
                textField.textAlignment = .Center
                textField.font = UIFont.systemFontOfSize(15)
//              button.setTitle(String(format: "%.2f", venuesList[i][j].price), forState: .Normal)
                textField.tintColor = UIColor.orangeColor()
                
                scrollView.addSubview(textField)
            }
        }
        for index in self.subviews {
            index.removeFromSuperview()
        }
        self.addSubview(scrollView)
    }
    


}
