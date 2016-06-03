//
//  PriceSettingView.swift
//  Tennis
//
//  Created by seasong on 16/4/18.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class PriceSettingView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    enum tableViewType {
        case defaultPrice
        case showPrice
        case settingPrice
    }
    
    let cellWidth: CGFloat = 110
    let cellHeight: CGFloat = 40
    var priceTableView: UITableView!
    var priceDate =  Array<Array<Array<CGFloat>>>()
    var dateList =  Array<String>()
    var currentPressedButton: UIButton!
    
    private var currentTableViewType: tableViewType!
    private var fatherViewController: UIViewController!
    private var startTimeTextField: UITextField!
    private var endTimeTextField: UITextField!
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        self.fatherViewController = fatherViewController
        backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let label1 = UILabel(frame: CGRectMake(180, 0, 110, 44))
        label1.font = UIFont.systemFontOfSize(15)
        label1.text = "查看或调整定价:"
        self.addSubview(label1)
        
        let startTimeTextFieldBorderView = UIView(frame: CGRectMake(300, 8, 100, 28))
        startTimeTextFieldBorderView.backgroundColor = UIColor.whiteColor()
        startTimeTextFieldBorderView.layer.borderWidth = 0.5
        startTimeTextFieldBorderView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
        startTimeTextFieldBorderView.layer.cornerRadius = 6
        startTimeTextFieldBorderView.clipsToBounds = true
        startTimeTextField = UITextField(frame: startTimeTextFieldBorderView.bounds)
        startTimeTextField.borderStyle = .None
        startTimeTextField.placeholder = "起始时间"
        startTimeTextField.textAlignment = .Center
        startTimeTextField.font = UIFont.systemFontOfSize(14)
        startTimeTextField.delegate = self
        startTimeTextField.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .EditingChanged)
        startTimeTextFieldBorderView.addSubview(startTimeTextField)
        self.addSubview(startTimeTextFieldBorderView)
        
        let label2 = UILabel(frame: CGRectMake(400, 8, 20, 28))
        label2.textAlignment = .Center
        label2.font = UIFont.systemFontOfSize(20, weight: UIFontWeightThin)
        label2.textColor = UIColor.lightGrayColor()
        label2.text = "~"
        self.addSubview(label2)
        
        let endTimeTextFieldBorderView = UIView(frame: CGRectMake(420, 8, 100, 28))
        endTimeTextFieldBorderView.backgroundColor = UIColor.whiteColor()
        endTimeTextFieldBorderView.layer.borderWidth = 0.5
        endTimeTextFieldBorderView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
        endTimeTextFieldBorderView.layer.cornerRadius = 6
        endTimeTextFieldBorderView.clipsToBounds = true
        endTimeTextField = UITextField(frame: endTimeTextFieldBorderView.bounds)
        endTimeTextField.borderStyle = .None
        endTimeTextField.placeholder = "结束时间"
        endTimeTextField.textAlignment = .Center
        endTimeTextField.font = UIFont.systemFontOfSize(14)
        endTimeTextField.delegate = self
        endTimeTextField.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .EditingChanged)
        endTimeTextFieldBorderView.addSubview(endTimeTextField)
        self.addSubview(endTimeTextFieldBorderView)
        
//        let defaultMessage = UILabel()
//        defaultMessage.frame.size = CGSizeMake(300, 30)
//        defaultMessage.center = self.center
//        defaultMessage.frame.origin.y -= 50
//        defaultMessage.text = "输入时间区间以对其进行相关操作"
//        defaultMessage.textColor = UIColor(white: 0.75, alpha: 1)
//        self.addSubview(defaultMessage)

        for index in 0...5 {

            let button = UIButton(type: UIButtonType.System)
            switch index {
            case 0:
                button.setTitle("默认每周定价", forState: .Normal)
                button.frame = CGRectMake(20, 8, 130, 28)
                currentPressedButton = button
            case 1:
                button.setTitle("查看", forState: .Normal)
                button.frame = CGRectMake(540, 8, 70, 28)
            case 2:
                button.setTitle("编辑", forState: .Normal)
                button.frame = CGRectMake(630, 8, 70, 28)
            case 3:
                button.setTitle("取消", forState: .Normal)
                button.frame = CGRectMake(763, 8, 70, 28)
            case 4:
                button.setTitle("保存", forState: .Normal)
                button.frame = CGRectMake(853, 8, 70, 28)
                button.enabled = false
            default:
                break
            }
            button.tag = index
            button.backgroundColor = UIColor.whiteColor()
            button.layer.cornerRadius = 14
            button.tintColor = myGreen
            button.addTarget(self, action: #selector(buttonClick), forControlEvents: .TouchUpInside)
            self.addSubview(button)
        }
        currentPressedButton.backgroundColor = myGreen
        currentPressedButton.tintColor = UIColor.whiteColor()
        currentTableViewType = tableViewType.defaultPrice
        showPriceTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        
        //场地列表
        var siteList = Array<Site>()
        for index in 0...5 {
            let site = Site()
            site.siteName = "室内\(index)号硬地"
            site.siteID = index
            siteList.append(site)
        }
        
        for z in 0..<3 {
            var priceListForDay = Array<Array<CGFloat>>()
            
            for i in 0..<siteList.count {
                var array = Array<CGFloat>()
                for j in 0...14 {
                    let price = CGFloat(z * 100 + i * 10 + j)
                    
                    array.append(price)
                }
                priceListForDay.append(array)
            }
            
            priceDate.append(priceListForDay)
        }
    }
    
    //tabelView刷新
    func tabelViewRefresh(sender: UIRefreshControl) {
        sender.attributedTitle = NSAttributedString(string: "正在更新...")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            sleep(1)//休眠1秒
            sender.endRefreshing()
            sender.attributedTitle = NSAttributedString(string: "下拉以刷新")
        }
    }
    
    //点击按钮
    func buttonClick(sender: UIButton) {
        
        switch sender.tag {
        //默认定价
        case 0:
            currentTableViewType = tableViewType.defaultPrice
            priceTableView.reloadData()
        //查看,编辑
        case 1, 2:
            loadData()
            var errorIsExist = false
            if startTimeTextField.text == "" {
                shake(startTimeTextField, clean: false)
                errorIsExist = true
            }
            if endTimeTextField.text == "" {
                shake(endTimeTextField, clean: false)
                errorIsExist = true
            }
            if !errorIsExist {
                let startTimeInt = getIntFromString(startTimeTextField.text!)
                let endTimeInt = getIntFromString(endTimeTextField.text!)
                if startTimeInt > endTimeInt {
                    shake(startTimeTextField, clean: false)
                    shake(endTimeTextField, clean: false)
                    errorIsExist = true
                }
            }
            if !errorIsExist {
                dateList = getDateList(startTimeTextField.text!, endTimeString: endTimeTextField.text!)
                if sender.tag == 1 {
                    currentTableViewType = tableViewType.showPrice
                }
                else {
                    currentTableViewType = tableViewType.settingPrice
                }
                priceTableView.reloadData()
            }
        //取消
        case 3:
            currentTableViewType = tableViewType.defaultPrice
        //保存
        case 4:
            currentTableViewType = tableViewType.defaultPrice
        default:
            break
        }
        
        currentPressedButton.tintColor = myGreen
        sender.tintColor = UIColor.whiteColor()
        UIView.animateWithDuration(0.2, animations: { 
            self.currentPressedButton.backgroundColor = UIColor.whiteColor()
            sender.backgroundColor = myGreen
            }) { (true) in
                self.currentPressedButton = sender
        }
    }
    
    func showPriceTable() {
        priceTableView = UITableView()
        priceTableView.delegate = self
        priceTableView.dataSource = self
        priceTableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        if priceTableView.respondsToSelector(Selector("setSeparatorInset:")){
            priceTableView.separatorInset = UIEdgeInsetsZero
        }
        priceTableView.frame = CGRectMake(20, 44, self.frame.width - 40, self.frame.height - 64)
        //        priceTableView.registerClass(PriceShowTableViewCell.self, forCellReuseIdentifier: "PCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = myGreen
        refreshControl.attributedTitle = NSAttributedString(string: "下拉以刷新")
        refreshControl.addTarget(self, action: #selector(tabelViewRefresh), forControlEvents: UIControlEvents.ValueChanged)
        priceTableView.addSubview(refreshControl)
        
        self.addSubview(priceTableView)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEditing(true)
    }
    
    
    
    //日期转换
    func getDateList(startTimeString: String, endTimeString: String) -> Array<String> {
        var timeArray = Array<String>()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startTime = dateFormatter.dateFromString(startTimeString)
        let endTime = dateFormatter.dateFromString(endTimeString)
        var nextDayTime = startTime
        while nextDayTime != endTime?.dateByAddingTimeInterval(60 * 60 * 24) {
            timeArray.append(dateFormatter.stringFromDate(nextDayTime!))
            nextDayTime = nextDayTime?.dateByAddingTimeInterval(60 * 60 * 24)
        }
        return timeArray
    }
    func getIntFromString(timeString: String) -> Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(timeString)
        dateFormatter.dateFormat = "yyyyMMdd"
        let temp = dateFormatter.stringFromDate(date!)
        return Int(temp)!
    }
    func getStringFromInt(timeInt: Int, addNumber: Int) -> String {
        var tempString = String(timeInt)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.dateFromString(tempString)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        tempString = dateFormatter.stringFromDate(date!)
        return tempString
    }
    
    
    
    //输入框抖动
    func shake(sender: UITextField, clean: Bool) {
        UIView.animateWithDuration(0.1, animations: {
            sender.frame.origin.x -= 15
        }) { (true) in
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 25, options: [], animations: {
                sender.frame.origin.x += 15
                }, completion: { (true) in
                    if clean {
                        sender.text = ""
                    }
            })
        }
    }
    
    
    
    //textField代理
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == startTimeTextField || textField == endTimeTextField {
            let pop = Popover()
            let datePickView = NSBundle.mainBundle().loadNibNamed("DatePickView", owner: nil, options: nil).first as! DatePickView
            
            datePickView.frame.origin = CGPointMake(0, 0)
            datePickView.popver = pop
            datePickView.textField = textField
            pop.show(datePickView, fromView: textField)
            return false
        }
        return true
    }
    
    func textFieldValueChanged(textField: UITextField) {

    }
    
    
    //tableView代理
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

//        switch currentTableViewType {
//        case tableViewType.defaultPrice:
//            return 7
//        case tableViewType.showPrice:
//            return dateList.count
//        case tableViewType.settingPrice:
//            return 1
//        default:
//            break
//        }
        if currentTableViewType == tableViewType.defaultPrice {
            return 7
        }
        if currentTableViewType == tableViewType.showPrice {
            return dateList.count
        }
        if currentTableViewType == tableViewType.settingPrice {
            return 1
        }
        return 0
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if currentTableViewType == tableViewType.defaultPrice {
            switch section {
            case 0:
                return "星期一"
            case 1:
                return "星期二"
            case 2:
                return "星期三"
            case 3:
                return "星期四"
            case 4:
                return "星期五"
            case 5:
                return "星期六"
            case 6:
                return "星期日"
            default:
                break
            }
        }
        if currentTableViewType == tableViewType.showPrice {
            return dateList[section]
        }
        if currentTableViewType == tableViewType.settingPrice {
            return startTimeTextField.text! + " ~ " + endTimeTextField.text!
        }
//        if priceDate.count == 1 {
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let startTime = dateFormatter.dateFromString(startTimeTextField.text!)
//            let endTime = dateFormatter.dateFromString(endTimeTextField.text!)
//            let unitFlags = NSCalendarUnit([.Day, .Month, .Year])
//            let startComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: startTime!)
//            let endComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: endTime!)
//            let yearDis = endComponents.year - startComponents.year
//            let monthDis = endComponents.month - startComponents.year
//            let dayDis = endComponents.day - startComponents.day
//            if yearDis > 0 || monthDis > 0 || dayDis > 1 {
//                return startTimeTextField.text! + " ~ " + endTimeTextField.text!
//            }
//        }
        return nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if currentTableViewType == tableViewType.settingPrice {
            priceTableView.registerClass(PriceSettingTableViewCell.self, forCellReuseIdentifier: "PCell0")
            let cell = tableView.dequeueReusableCellWithIdentifier("PCell0", forIndexPath: indexPath)
            return cell
        }
        if currentTableViewType == tableViewType.showPrice {
            let cell = PriceShowTableViewCell(style: .Default, reuseIdentifier: nil)
            cell.date = dateList[indexPath.section]
            return cell
        }
        if currentTableViewType == tableViewType.defaultPrice {
            
        }
        let cell = UITableViewCell()
        cell.selectionStyle = .None
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 39 * 16 + 1
    }
    
}
