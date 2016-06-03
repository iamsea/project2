//
//  AddCompetitionViewController.swift
//  Tennis
//
//  Created by seasong on 16/5/6.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class AddCompetitionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet var textField: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.hideBottomHairline()
        
        doneBarButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelBarButtonClick(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneBarButttonClick(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //UITextFieldDeleagate
    func textFieldDidEndEditing(textField: UITextField) {
        var allTextFieldHadSetAValue = true
        for index in self.textField {
            if index.text == "" {
                allTextFieldHadSetAValue = false
            }
        }
        self.doneBarButton.enabled = allTextFieldHadSetAValue
    }
    
}
