//
//  datePickView.swift
//  Tennis
//
//  Created by seasong on 16/4/26.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class DatePickView: UIView {

    var popver: Popover!
    var textField: UITextField!
//    var startTime: NSDate!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func drawRect(rect: CGRect) {
        datePicker.minimumDate = NSDate()
    }
    
    @IBAction func doneButtonClick(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        textField.text = dateFormatter.stringFromDate(datePicker.date)
        popver.dismiss()
    }
    
    @IBAction func cancelButtonClick(sender: UIButton) {
        popver.dismiss()
    }
}
