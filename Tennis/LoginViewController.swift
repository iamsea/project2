//
//  LoginViewController.swift
//  Tennis
//
//  Created by seasong on 16/5/9.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var timer: NSTimer!
    private var remainingSeconds = 0
    private var registerRotationImageView: UIImageView!
    private var findPasswordRotationImageView: UIImageView!
    
    @IBOutlet weak var loginLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var userLogoImageView: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var loginRotationImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var registerTextFieldBorderViews: [UIView]!
    @IBOutlet var resgisterTipsImageViews: [UIImageView]!
    @IBOutlet weak var registerGetVerifyCodeButton: UIButton!
    @IBOutlet weak var registerBackButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var findPasswordLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var findPasswordView: UIView!
    @IBOutlet var findPasswordTextFieldBorderViews: [UIView]!
    @IBOutlet weak var findPhoneNumberTextField: UITextField!
    @IBOutlet weak var securityCodeTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordVerifyTextField: UITextField!
    @IBOutlet weak var findPasswordPhoneTipsImageView: UIImageView!
    @IBOutlet weak var findPasswordVerifyCodeTipsImageView: UIImageView!
    @IBOutlet weak var findPasswordNewTipsImageView: UIImageView!
    @IBOutlet weak var findPasswordNewVerifyTipsImageView: UIImageView!
    @IBOutlet weak var findPasswordGetVerifyCodeButton: UIButton!
    @IBOutlet weak var findPasswordBackButton: UIButton!
    @IBOutlet weak var findPasswordPostButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shadeView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        shadeView.frame = self.view.frame
        backImageView.addSubview(shadeView)
        
        borderView.layer.cornerRadius = 20
        borderView.layer.borderWidth = 0.5
        borderView.layer.borderColor = UIColor.whiteColor().CGColor
        userNameTextField.addTarget(self, action: #selector(textfieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
//        passwordTextField.setValue(UIColor.whiteColor(), forKey: "_placeholderLabel.textColor")
        passwordTextField.addTarget(self, action: #selector(textfieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        
        for index in registerTextFieldBorderViews {
            index.layer.borderWidth = 0.5
            index.layer.borderColor = UIColor.whiteColor().CGColor
            index.layer.cornerRadius = 10
        }
        for index in findPasswordTextFieldBorderViews {
            index.layer.borderWidth = 0.5
            index.layer.borderColor = UIColor.whiteColor().CGColor
            index.layer.cornerRadius = 10
        }
        postButton.layer.borderWidth = 1
        postButton.layer.borderColor = UIColor.whiteColor().CGColor
        postButton.layer.cornerRadius = 30
        for index in textFields {
            index.addTarget(self, action: #selector(textfieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        }
        
        findPasswordPostButton.layer.borderWidth = 1
        findPasswordPostButton.layer.borderColor = UIColor.whiteColor().CGColor
        findPasswordPostButton.layer.cornerRadius = 30
        findPhoneNumberTextField.addTarget(self, action: #selector(textfieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        securityCodeTextField.addTarget(self, action: #selector(textfieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        newPasswordTextField.addTarget(self, action: #selector(textfieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        newPasswordVerifyTextField.addTarget(self, action: #selector(textfieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //点击登录
    @IBAction func LoginButtonClick(sender: UIButton) {
        self.view.endEditing(true)
        var errorFlag = false
        if userNameTextField.text?.characters.count != 11 || Int(userNameTextField.text!) == nil {
            shake(userNameTextField)
            errorFlag = true
        }
        if passwordTextField.text == "" {
            shake(passwordTextField)
            errorFlag = true
        }
        
////        服务器接入
//        if errorFlag == false {
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//            self.rotationActivityStart(self.loginRotationImageView)
//            let login = NetworkTool.Login(phoenNumber: userNameTextField.text!, password: passwordTextField.text!)
//            login.getResult({ (r, error) in
//                if let dict = r {
//                    let loginResult = LoginResult(fromDictionary: dict)
////                    print("******&*&*&*&*&*\()")
//                    if loginResult.state == 1  {
//                        NSOperationQueue.mainQueue().addOperationWithBlock({
//                            
//                            //存储信息
//                            let loginList = loginResult.list
//                            let isLogin = true
//                            let userId = loginList.shopId
//                            NSUserDefaults.standardUserDefaults().setObject(isLogin, forKey: "isLogin")
//                            NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userId")
//                            //信息同步
//                            NSUserDefaults.standardUserDefaults().synchronize()
//                            
//                            self.performSelector(#selector(LoginViewController.goHomeViewController), withObject: nil, afterDelay: 1)
//                        })
//                    }
//                    else if loginResult.state == 0 {
//                        NSOperationQueue.mainQueue().addOperationWithBlock({ 
//                            print(loginResult.msg)
//                            self.shake(self.borderView)
//                            self.rotationActivityStop(self.loginRotationImageView)
//                            errorFlag = true
//                        })
//                    }
//                }
//                else {
//                    let alertVC = UIAlertController(title: "提示", message: error!, preferredStyle: .Alert)
//                    let action = UIAlertAction(title: "确认", style: .Default, handler: nil)
//                    action.setValue(myGreen, forKey: "_titleTextColor")
//                    alertVC.addAction(action)
//                    self.presentViewController(alertVC, animated: true, completion: nil)
//                    NSOperationQueue.mainQueue().addOperationWithBlock({
//                        self.rotationActivityStop(self.loginRotationImageView)
//                    })
//                }
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//            })
//        }
        if errorFlag == false {
            self.performSelector(#selector(LoginViewController.goHomeViewController), withObject: nil, afterDelay: 0)
        }
    }
    
    func goHomeViewController() {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("homeViewController")
        UIApplication.sharedApplication().keyWindow?.rootViewController = homeViewController
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //textField输入响应函数
    func textfieldDidChange(sender: UITextField) {
        switch sender {
//        case passwordTextField, userNameTextField:
//            if userNameTextField.text?.characters.count == 11 && passwordTextField.text != "" {
//                loginButton.enabled = true
//                UIView.animateWithDuration(1, animations: {
//                    self.loginButton.alpha = 1
//                })
//            }
//            else {
//                loginButton.enabled = false
//                if self.loginButton.alpha == 1 {
//                    UIView.animateWithDuration(0.5, animations: {
//                        self.loginButton.alpha = 0
//                    })
//                }
//            }
        case textFields[0]:
            if sender.text!.characters.count == 11 && Int(sender.text!) != nil {
                registerGetVerifyCodeButton.alpha = 1
                registerGetVerifyCodeButton.enabled = true
                if resgisterTipsImageViews[0].image == UIImage(named: "errorTips") {
                    UIView.animateWithDuration(0.3, animations: {
                        self.resgisterTipsImageViews[0].transform = CGAffineTransformMakeScale(0.3, 0.3)
                        }, completion: { (true)in
                            self.resgisterTipsImageViews[0].image = nil
                    })
                }
            }
            else {
                registerGetVerifyCodeButton.enabled = false
                registerGetVerifyCodeButton.alpha = 0.5
                UIView.animateWithDuration(0.3, animations: {
                    self.resgisterTipsImageViews[0].transform = CGAffineTransformMakeScale(0.3, 0.3)
                    }, completion: { (true)in
                        self.resgisterTipsImageViews[0].image = nil
                })
            }
        case textFields[1]:
            if sender.text?.characters.count == 4 {
                //验证验证码是否正确
                VerificationCodeSumbit(sender)
            }
            else {
                UIView.animateWithDuration(0.3, animations: {
                    self.resgisterTipsImageViews[1].transform = CGAffineTransformMakeScale(0.3, 0.3)
                    }, completion: { (true)in
                        self.resgisterTipsImageViews[1].image = nil
                })
            }
        case textFields[2]:
            UIView.animateWithDuration(0.3, animations: {
                self.resgisterTipsImageViews[2].transform = CGAffineTransformMakeScale(0.3, 0.3)
                }, completion: { (true)in
                    self.resgisterTipsImageViews[2].image = nil
            })
        case textFields[4]:
//            if sender.text?.characters.count >= 6 && resgisterTipsImageViews[4].image == UIImage(named: "errorTips") {
            if resgisterTipsImageViews[4].image != nil {
                UIView.animateWithDuration(0.3, animations: {
                    self.resgisterTipsImageViews[4].transform = CGAffineTransformMakeScale(0.3, 0.3)
                    }, completion: { (true)in
                        self.resgisterTipsImageViews[4].image = nil
                })
            }
        case textFields[5]:
            if sender.text == textFields[4].text {
                resgisterTipsImageViews[5].image = UIImage(named: "check_pressed")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                resgisterTipsImageViews[5].transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.resgisterTipsImageViews[5].transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
            else {
                UIView.animateWithDuration(0.3, animations: {
                    self.resgisterTipsImageViews[5].transform = CGAffineTransformMakeScale(0.3, 0.3)
                    }, completion: { (true)in
                        self.resgisterTipsImageViews[5].image = nil
                })
            }
        case findPhoneNumberTextField:
            if sender.text!.characters.count == 11 && Int(sender.text!) != nil {
                findPasswordGetVerifyCodeButton.alpha = 1
                findPasswordGetVerifyCodeButton.enabled = true
                if findPasswordPhoneTipsImageView.image == UIImage(named: "errorTips") {
                    UIView.animateWithDuration(0.3, animations: {
                        self.findPasswordPhoneTipsImageView.transform = CGAffineTransformMakeScale(0.3, 0.3)
                        }, completion: { (true)in
                            self.findPasswordPhoneTipsImageView.image = nil
                    })
                }
            }
            else {
                findPasswordGetVerifyCodeButton.enabled = false
                findPasswordGetVerifyCodeButton.alpha = 0.5
            }
        case securityCodeTextField:
            if sender.text?.characters.count == 4 {
                //验证验证码是否正确
                VerificationCodeSumbit(sender)
            }
            else {
                UIView.animateWithDuration(0.3, animations: {
                    self.findPasswordVerifyCodeTipsImageView.transform = CGAffineTransformMakeScale(0.3, 0.3)
                    }, completion: { (true)in
                        self.findPasswordVerifyCodeTipsImageView.image = nil
                })
            }
        case newPasswordTextField:
            if findPasswordNewTipsImageView.image != nil {
                UIView.animateWithDuration(0.3, animations: {
                    self.findPasswordNewTipsImageView.transform = CGAffineTransformMakeScale(0.3, 0.3)
                    }, completion: { (true)in
                        self.resgisterTipsImageViews[0].image = nil
                })
            }
        case newPasswordVerifyTextField:
            if sender.text == newPasswordTextField.text {
                findPasswordNewVerifyTipsImageView.image = UIImage(named: "check_pressed")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                findPasswordNewVerifyTipsImageView.transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.findPasswordNewVerifyTipsImageView.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
            else {
                UIView.animateWithDuration(0.3, animations: {
                    self.findPasswordNewVerifyTipsImageView.transform = CGAffineTransformMakeScale(0.3, 0.3)
                    }, completion: { (true)in
                        self.findPasswordNewVerifyTipsImageView.image = nil
                })
            }
        default:
            break
        }

        if findPasswordPhoneTipsImageView.image == UIImage(named: "check_pressed") && findPasswordNewVerifyTipsImageView.image == UIImage(named: "check_pressed") && findPasswordNewTipsImageView == UIImage(named: "check_pressed") && findPasswordVerifyCodeTipsImageView.image == UIImage(named: "check_pressed"){
            self.findPasswordPostButton.enabled = true
            UIView.animateWithDuration(0.3, animations: {
                self.findPasswordPostButton.alpha = 1
            })
        }
        else {
            self.findPasswordPostButton.enabled = false
            UIView.animateWithDuration(0.3, animations: {
                self.findPasswordPostButton.alpha = 0
            })
        }
    }
    
    //textField代理
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {

        switch textField {
        case textFields[0]:
            if textField.text?.characters.count != 11 && textField.text != "" {
                resgisterTipsImageViews[0].image = UIImage(named: "errorTips")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                resgisterTipsImageViews[0].transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.resgisterTipsImageViews[0].transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        case textFields[1]:
            if resgisterTipsImageViews[1].image != UIImage(named: "check_pressed") && textField.text != "" {
                resgisterTipsImageViews[1].image = UIImage(named: "errorTips")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                resgisterTipsImageViews[1].transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.resgisterTipsImageViews[1].transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        case textFields[2]:
            //检测用户名是否可用
            let userNameIsEnabled = true
            if userNameIsEnabled && textField.text != "" {
                resgisterTipsImageViews[2].image = UIImage(named: "check_pressed")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                resgisterTipsImageViews[2].transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.resgisterTipsImageViews[2].transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        case textFields[4]:
            if textField.text?.characters.count >= 6 {
                resgisterTipsImageViews[4].image = UIImage(named: "check_pressed")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                resgisterTipsImageViews[4].transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.resgisterTipsImageViews[4].transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
            else if textField.text == "" {
                
            }
            else {
                let alert = UIAlertController(title: "提示", message:"密码长度须为6位以上", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                okAction.setValue(myGreen, forKey: "_titleTextColor")
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                resgisterTipsImageViews[4].image = UIImage(named: "errorTips")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                resgisterTipsImageViews[4].transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.resgisterTipsImageViews[4].transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        case textFields[5]:
            if textField.text != "" && textField.text != textFields[4].text {
                resgisterTipsImageViews[5].image = UIImage(named: "errorTips")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                resgisterTipsImageViews[5].transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.resgisterTipsImageViews[5].transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        case findPhoneNumberTextField:
            if textField.text?.characters.count != 11 && textField.text != "" {
                findPasswordPhoneTipsImageView.image = UIImage(named: "errorTips")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                findPasswordPhoneTipsImageView.transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.findPasswordPhoneTipsImageView.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        case securityCodeTextField:
            VerificationCodeSumbit(textField)
        case newPasswordTextField:
            if textField.text?.characters.count >= 6 {
                findPasswordNewTipsImageView.image = UIImage(named: "check_pressed")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                findPasswordNewTipsImageView.transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.findPasswordNewTipsImageView.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
            else if textField.text == "" {
                
            }
            else {
                let alert = UIAlertController(title: "提示", message:"密码长度须为6位以上", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                okAction.setValue(myGreen, forKey: "_titleTextColor")
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                findPasswordNewTipsImageView.image = UIImage(named: "errorTips")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                findPasswordNewTipsImageView.transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.findPasswordNewTipsImageView.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        case newPasswordVerifyTextField:
            if textField.text != newPasswordTextField.text && textField.text != "" {
                findPasswordNewVerifyTipsImageView.image = UIImage(named: "errorTips")
                let transform = CGAffineTransformMakeScale(0.4, 0.4)
                findPasswordNewVerifyTipsImageView.transform = transform
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                    self.findPasswordNewVerifyTipsImageView.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        default:
            break
        }
        return true
    }
    
    //点击忘记密码按钮
    @IBAction func forgetPasswordButtonClick(sender: UIButton) {
        UIView.animateWithDuration(0.4, animations: { 
            self.loginView.frame.origin.x = UIScreen.mainScreen().bounds.width
            self.findPasswordView.frame.origin.x = 0
            }) { (true) in
                self.loginLeadingConstrains.constant = 1024
                self.findPasswordLeadingConstrains.constant = 0
                UIView.animateWithDuration(0.5) {
                    self.findPasswordBackButton.alpha = 1
                }
        }
    }
    
    //点击注册按钮
    @IBAction func registButtonClick(sender: UIButton) {
        UIView.animateWithDuration(0.4, animations: { 
            self.loginView.frame.origin.x = -UIScreen.mainScreen().bounds.width
            self.registerView.frame.origin.x = 0
            }) { (true) in
                self.loginLeadingConstrains.constant = -UIScreen.mainScreen().bounds.width
                self.registerLeadingConstrains.constant = 0
                UIView.animateWithDuration(0.3, animations: {
                    UIView.animateWithDuration(0.5) {
                        self.registerBackButton.alpha = 1
                    }
                })
        }
    }
    
    //点击获取验证码
    @IBAction func getVerifyCodeButtonClick(sender: UIButton) {
        var phoneNumber = ""
        if sender == registerGetVerifyCodeButton {
            phoneNumber = textFields[0].text!
        }
        else {
            phoneNumber = findPhoneNumberTextField.text!
        }
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: phoneNumber, zone: "86", customIdentifier: nil) { (error : NSError!) -> Void in
            
            if (error == nil)
            {
                print("请求成功,请等待短信～")
                switch sender {
                case self.registerGetVerifyCodeButton:
                    self.resgisterTipsImageViews[0].image = UIImage(named: "check_pressed")
                    let transform = CGAffineTransformMakeScale(0.4, 0.4)
                    self.resgisterTipsImageViews[0].transform = transform
                    UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                        self.resgisterTipsImageViews[0].transform = CGAffineTransformIdentity
                        }, completion: nil)
                    
                    self.registerGetVerifyCodeButton.enabled = false
                    self.registerGetVerifyCodeButton.setTitle("60s", forState: .Normal)
                    self.remainingSeconds = 60
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                case self.findPasswordGetVerifyCodeButton:
                    self.findPasswordPhoneTipsImageView.image = UIImage(named: "check_pressed")
                    let transform = CGAffineTransformMakeScale(0.4, 0.4)
                    self.findPasswordPhoneTipsImageView.transform = transform
                    UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                        self.findPasswordPhoneTipsImageView.transform = CGAffineTransformIdentity
                        }, completion: nil)
                    
                    self.findPasswordGetVerifyCodeButton.enabled = false
                    self.findPasswordGetVerifyCodeButton.setTitle("60s", forState: .Normal)
                    self.remainingSeconds = 60
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateTime2), userInfo: nil, repeats: true)
                default:
                    break
                }
            }
            else
            {
                // 错误码可以参考‘SMS_SDK.framework / SMSSDKResultHanderDef.h’
                print("请求失败", error)
                //手机号码格式错误
                if error.code == 457 {
                    switch sender {
                    case self.registerGetVerifyCodeButton:
                        self.resgisterTipsImageViews[0].image = UIImage(named: "errorTips")
                        let transform = CGAffineTransformMakeScale(0.4, 0.4)
                        self.resgisterTipsImageViews[0].transform = transform
                        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                            self.resgisterTipsImageViews[0].transform = CGAffineTransformIdentity
                            }, completion: nil)
                    case self.findPasswordGetVerifyCodeButton:
                        self.findPasswordPhoneTipsImageView.image = UIImage(named: "errorTips")
                        let transform = CGAffineTransformMakeScale(0.4, 0.4)
                        self.findPasswordPhoneTipsImageView.transform = transform
                        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                            self.findPasswordPhoneTipsImageView.transform = CGAffineTransformIdentity
                            }, completion: nil)
                    default:
                        break
                    }
                }
            }
        }
    }

    //点击提交注册信息按钮
    @IBAction func postButtonClick(sender: UIButton) {
        self.view.endEditing(true)
        var temp = 0
        for index in 0..<textFields.count {
            if textFields[index].text == "" || resgisterTipsImageViews[index].image == UIImage(named: "errorTips") {
                shake(textFields[index])
                temp += 1
            }
        }
        if temp == 0 && registerRotationImageView == nil {
            sender.layer.borderWidth = 0
            registerRotationImageView = UIImageView(frame: sender.frame)
            registerRotationImageView.image = UIImage(named: "rotation")
            let anim = CABasicAnimation(keyPath: "transform.rotation.z")
            registerRotationImageView.layer.anchorPoint = CGPointMake(0.5, 0.5)
            anim.toValue = 2 * M_PI
            anim.repeatCount = HUGE
            anim.duration = 1
            registerRotationImageView.layer.addAnimation(anim, forKey: "rotationAnim")
            registerView.addSubview(registerRotationImageView)
            performSelector(#selector(registerPostMessage), withObject: nil, afterDelay: 4)
        }
        else if registerRotationImageView != nil {
            sender.layer.borderWidth = 1
            registerRotationImageView.removeFromSuperview()
        }
    }
    
    //注册提交后提示
    func registerPostMessage() {
        registerRotationImageView.removeFromSuperview()
        postButton.layer.borderWidth = 1
        let alert = UIAlertController(title: "提示", message: "信息已提交审核，审核结果将通过短信通知您！", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确认", style: .Default) { (UIAlertAction) in
            self.registerBackButtonClick(UIButton())
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //点击重置密码信息提交按钮
    @IBAction func findPasswordPostButtonClick(sender: UIButton) {
        if findPasswordRotationImageView == nil {
            findPasswordRotationImageView = UIImageView(frame: sender.frame)
            findPasswordRotationImageView.image = UIImage(named: "rotation")
            let anim = CABasicAnimation(keyPath: "transform.rotation.z")
            findPasswordRotationImageView.layer.anchorPoint = CGPointMake(0.5, 0.5)
            anim.toValue = 2 * M_PI
            anim.repeatCount = HUGE
            anim.duration = 1
            findPasswordRotationImageView.layer.addAnimation(anim, forKey: "rotationAnim")
            self.view.addSubview(findPasswordRotationImageView)
        }
    }
    
    //注册界面返回登录界面按钮
    @IBAction func registerBackButtonClick(sender: UIButton) {
        remainingSeconds = 0
        self.registerBackButton.alpha = 0
        UIView.animateWithDuration(0.4, animations: { 
            self.loginView.frame.origin.x = 0
            self.registerView.frame.origin.x = UIScreen.mainScreen().bounds.width
            }) { (true) in
                self.loginLeadingConstrains.constant = 0
                self.registerLeadingConstrains.constant = UIScreen.mainScreen().bounds.width
                for index in 0..<self.textFields.count {
                    self.textFields[index].text = ""
                    self.resgisterTipsImageViews[index].image = nil
                    self.registerGetVerifyCodeButton.enabled = false
                    self.registerGetVerifyCodeButton.alpha = 0.5
                }
        }
    }
    
    //点击密码找回界面返回登录界面按钮
    @IBAction func findPasswordBackButtonClick(sender: AnyObject) {
        remainingSeconds = 0
        findPasswordBackButton.alpha = 0
        UIView.animateWithDuration(0.4, animations: { 
            self.loginView.frame.origin.x = 0
            self.findPasswordView.frame.origin.x = -UIScreen.mainScreen().bounds.width
            }) { (true) in
                self.loginLeadingConstrains.constant = 0
                self.findPasswordLeadingConstrains.constant = -UIScreen.mainScreen().bounds.width
        }
    }
    
    //验证码提交验证
    func VerificationCodeSumbit(sender: UITextField) {
        switch sender {
        case textFields[1]:
            SMSSDK.commitVerificationCode(sender.text, phoneNumber: textFields[0].text, zone: "86") { (error : NSError!) -> Void in
                if(error == nil){
                    print("验证成功")
                    self.resgisterTipsImageViews[1].image = UIImage(named: "check_pressed")
                    let transform = CGAffineTransformMakeScale(0.4, 0.4)
                    self.resgisterTipsImageViews[1].transform = transform
                    UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                        self.resgisterTipsImageViews[1].transform = CGAffineTransformIdentity
                        }, completion: nil)
                    self.remainingSeconds = 0
                }else{
                    print("验证失败", error)
                    self.resgisterTipsImageViews[1].image = UIImage(named: "errorTips")
                    let transform = CGAffineTransformMakeScale(0.4, 0.4)
                    self.resgisterTipsImageViews[1].transform = transform
                    UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                        self.resgisterTipsImageViews[1].transform = CGAffineTransformIdentity
                        }, completion: nil)
                }
            }
        case securityCodeTextField:
            SMSSDK.commitVerificationCode(sender.text, phoneNumber: findPhoneNumberTextField.text, zone: "86") { (error : NSError!) -> Void in
                if(error == nil){
                    print("验证成功")
                    self.findPasswordVerifyCodeTipsImageView.image = UIImage(named: "check_pressed")
                    let transform = CGAffineTransformMakeScale(0.4, 0.4)
                    self.findPasswordVerifyCodeTipsImageView.transform = transform
                    UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                        self.findPasswordVerifyCodeTipsImageView.transform = CGAffineTransformIdentity
                        }, completion: nil)
                    self.remainingSeconds = 0
                }else{
                    print("验证失败", error)
                    self.findPasswordVerifyCodeTipsImageView.image = UIImage(named: "errorTips")
                    let transform = CGAffineTransformMakeScale(0.4, 0.4)
                    self.findPasswordVerifyCodeTipsImageView.transform = transform
                    UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 13, options: [], animations: {
                        self.findPasswordVerifyCodeTipsImageView.transform = CGAffineTransformIdentity
                        }, completion: nil)
                }
            }
        default:
            break
        }

    }
    
    //更新验证剩余时间 
    func updateTime() {
        if remainingSeconds > 1 {
            remainingSeconds -= 1
            registerGetVerifyCodeButton.setTitle("\(remainingSeconds)s", forState: .Normal)
        }
        else {
            self.timer.fireDate = NSDate.distantFuture()
            registerGetVerifyCodeButton.setTitle("获取", forState: .Normal)
            registerGetVerifyCodeButton.enabled = true
        }

    }
    
    func updateTime2() {
        if remainingSeconds > 1 {
            remainingSeconds -= 1
            findPasswordGetVerifyCodeButton.setTitle("\(remainingSeconds)s", forState: .Normal)
        }
        else {
            self.timer.fireDate = NSDate.distantFuture()
            findPasswordGetVerifyCodeButton.setTitle("获取", forState: .Normal)
            findPasswordGetVerifyCodeButton.enabled = true
        }
    }
    
    //输入框抖动
    func shake(sender: UIView) {
        var shakeDistance: CGFloat!
        if sender.isKindOfClass(UITextField) {
            shakeDistance = 25
        }
        else {
            shakeDistance = 50
        }
        UIView.animateWithDuration(0.1, animations: {
            sender.frame.origin.x += shakeDistance
        }) { (true) in
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 25, options: [], animations: {
                sender.frame.origin.x -= shakeDistance
                }, completion: nil)
        }
    }
    
    func rotationActivityStart(sender: UIImageView) {
        sender.image = UIImage(named: "rotation_activity")
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        sender.layer.anchorPoint = CGPointMake(0.5, 0.5)
        anim.toValue = 2 * M_PI
        anim.repeatCount = HUGE
        anim.duration = 1
        sender.layer.addAnimation(anim, forKey: "rotationAnim")
    }
    func rotationActivityStop(sender: UIImageView) {
        if sender.image != UIImage(named: "rotation_stop") {
            sender.image = UIImage(named: "rotation_stop")
            sender.layer.removeAnimationForKey("rotationAnim")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
