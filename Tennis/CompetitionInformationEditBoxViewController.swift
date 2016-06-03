//
//  InformationEditBoxViewController.swift
//  Tennis
//
//  Created by seasong on 16/4/21.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class CompetitionInformationEditBoxViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var textField: [UITextField]!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var competitionNameTextField: UITextField!
    @IBOutlet weak var competitionTimeTextField: UITextField!
    @IBOutlet weak var competitionAddressTextField: UITextField!
    @IBOutlet weak var signUpBeginTimeTextField: UITextField!
    @IBOutlet weak var signUpEndTimeTextField: UITextField!
    
    //var competition = Competition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏navigationBar下面的黑线
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.hideBottomHairline()
        
        self.navigationItem.title = checkedCompetition.name
        competitionNameTextField.text = checkedCompetition.name
        competitionTimeTextField.text = checkedCompetition.time
        competitionAddressTextField.text = checkedCompetition.address
        signUpBeginTimeTextField.text = checkedCompetition.beginSigningUpTime
        signUpEndTimeTextField.text = checkedCompetition.endSigningUpTime
        doneBarButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelBarButtonClick(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneBarButtonClick(sender: UIBarButtonItem) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //TextField代理事件
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let point: CGPoint!
        point = superViewController.view.center
        switch textField {
        case competitionTimeTextField:
            point.y -= 41
        case signUpBeginTimeTextField:
            point.y += 93
        case signUpEndTimeTextField:
            point.y += 160
        default:
            return true
        }
        let pop = Popover()
        let datePickView = NSBundle.mainBundle().loadNibNamed("DatePickView", owner: nil, options: nil).first as! DatePickView
        datePickView.frame.origin = CGPointMake(0, 0)
        datePickView.popver = pop
        datePickView.textField = textField
        pop.show(datePickView, point: point)
        return false //键盘不弹出
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        //还得检测该textField的值有没有改变
        var allTextFieldHadSetAValue = true
        for index in self.textField {
            if index.text == "" {
                allTextFieldHadSetAValue = false
            }
        }
        doneBarButton.enabled = allTextFieldHadSetAValue
    }

}
