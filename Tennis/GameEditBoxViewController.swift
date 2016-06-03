//
//  GameEditBoxViewController.swift
//  Tennis
//
//  Created by seasong on 16/4/4.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class GameEditBoxViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    private let buttonHeight: CGFloat = 38  //三个图片按钮的高度，如何storyboard中的button的height改变，这里也要手动修改
    private let durationTime: NSTimeInterval = 0.5
    private let scaleMultiple: CGFloat = 1.5
    
    @IBOutlet weak var siteLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var scoreLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var remarkLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var scoreButtonTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var scoreButtonLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var siteButtonTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var siteButtonLeadingconstrain: NSLayoutConstraint!
    @IBOutlet weak var remarkButtonTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var remarkButtonLeadingConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var siteView: UIView!
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet weak var remarkViewNameLabel1: UILabel!
    @IBOutlet weak var remarkViewNameLabel2: UILabel!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var remarkButton: UIButton!
    private var leftButtonCenter: CGPoint!
    private var centerButtonCenter: CGPoint!
    private var rightButtonCenter: CGPoint!
    
    @IBOutlet weak var scoreTextField1: UITextField!
    @IBOutlet weak var scoreTextField2: UITextField!

    @IBOutlet weak var releaseSiteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    var game = Game()
    var availableSiteList = Array<Site>()
    var images = Array<UIImage>()
    var maxImageCount = 5
    var currentImageConut = 0
    var messageIdentity = "gameEditBoxViewMessageServer"
    var tempSelectedCollectionViewCellItem: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏navigationBar下面的黑线
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.hideBottomHairline()
        
        self.navigationController?.navigationBar.backItem?.title = ""
        leftButtonCenter = scoreButton.center
        centerButtonCenter = siteButton.center
        rightButtonCenter = remarkButton.center
        
        self.navigationItem.title = "\(game.playerA.name) : \(game.playerB.name)"
        releaseSiteButton.layer.borderWidth = 0.5
        releaseSiteButton.layer.cornerRadius = 15
        releaseSiteButton.layer.borderColor = myGreen.CGColor
        
        if game.state == 1 {
            siteButton.transform = CGAffineTransformMakeScale(scaleMultiple, scaleMultiple)
            releaseSiteButton.enabled = false
            releaseSiteButton.layer.borderWidth = 0
        }
        else if game.state == 3 {
            releaseSiteButton.enabled = false
            releaseSiteButton.layer.borderWidth = 0
            scoreTextField1.text = String(game.score1)
            scoreTextField2.text = String(game.score2)
        }
        
        if game.state == 2 || game.state == 3 {
            scoreButton.transform = CGAffineTransformMakeScale(scaleMultiple, scaleMultiple)
            scoreButton.center = centerButtonCenter
            siteButton.center = rightButtonCenter
            remarkButton.center = leftButtonCenter
            scoreView.frame.origin.x = 0
            siteView.frame.origin.x = 500
            remarkView.frame.origin.x = -500
            updateConstraints()
        }
        
        remarkViewNameLabel1.text = game.playerA.name
        remarkViewNameLabel2.text = game.playerB.name
        loadScoreViewData()
        
            //接收子场景的消息步骤一 注册一个observer来响应子控制器的消息
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getMessage), name: messageIdentity, object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //加载比分界面的数据
    func loadScoreViewData() {
//        let image: UIImage = UIImage(named: "logo2")!
//        images.append(image)
    }
    
    //tableView代理，初始化场地列表
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableSiteList.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 33
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier="identtifier";
        var cell=tableView.dequeueReusableCellWithIdentifier(identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier);
        }
        if availableSiteList[indexPath.row].isUsing || (game.state == 3 && game.site != nil && availableSiteList[indexPath.row].siteID == game.site.siteID) {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell?.tintColor = myGreen
        }
        else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.textLabel?.text = availableSiteList[indexPath.row].siteName
       // cell?.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        //tableView.deselectRowAtIndexPath(indexPath, animated: true) //获取点击的行索引
        if game.state != 3 {
            for index in availableSiteList {
                index.isUsing = false
            }
            availableSiteList[indexPath.row].isUsing = true
//            game.site = availableSiteList[indexPath.row]
//            game.state = 2
            releaseSiteButton.enabled = true
            releaseSiteButton.layer.borderWidth = 0.5
            tableView.reloadData()
        }
    }
    
    //按下场地释放按钮
    @IBAction func releaseSite(sender: UIButton) {
        //competition.site.siteID = -1
        game.state = 1
        for index in availableSiteList {
            if index.isUsing {
                index.isUsing = false
            }
        }
        tableView.reloadData()
        sender.enabled = false
        sender.layer.borderWidth = 0
    }
    
    //MARK: - toucherBegan
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - textFielsShouldReturn
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == scoreTextField1 {
            scoreTextField2.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
        }
        return true
    }
    //输入框开始输入前的工作
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField==scoreTextField1 && textField.text == "--" {
            scoreTextField1.text = ""
        }
        if textField==scoreTextField2 && textField.text == "--" {
            scoreTextField2.text = ""
        }
    }
    //输入框完成输入后的工作
    func textFieldDidEndEditing(textField: UITextField) {
        doneBarButton.enabled = false
        if (textField.text=="") {
            textField.text = "--"
        }
        if (scoreTextField1.text != "--" && scoreTextField2.text != "--" ){
            doneBarButton.enabled = true
        }
        if (scoreTextField1.text == "--" && scoreTextField2.text == "--" ){
            doneBarButton.enabled = true
        }
    }
    
    //textView代理事件
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == "输入本场比赛备注：" {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        return true
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "输入本场比赛备注："
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //colletionView代理
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count >= 5 {
            return images.count
        }
        return images.count + 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCollectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        if images.count == 0 {
            cell.imageView.image = UIImage(named: "camera_scoreView")
        }
        else if images.count == indexPath.item {
            cell.imageView.image = UIImage(named: "compose_normal")
        }
        else {
           cell.imageView.image = images[indexPath.item]
            cell.hadImage = true
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == images.count {
            self.performSegueWithIdentifier("showPhotoLibrary", sender: self)
        }
        else {
            tempSelectedCollectionViewCellItem = indexPath.item
            let photoDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("photoDetailViewController") as! PhotoDetailViewController
            photoDetailViewController.image = images[indexPath.item]
            photoDetailViewController.serverMessageIdentity = messageIdentity
            self.presentViewController(photoDetailViewController, animated: true, completion: nil)
        }
    }
    
    //按下确认按钮
    @IBAction func doneBarButtonClick(sender: AnyObject) {
        for index in availableSiteList {
            if index.isUsing {
                game.site = index
                game.state = 2
            }
        }
        if scoreTextField1.text == "--" && scoreTextField2.text == "--" && game.state == 3 {
            game.score1 = nil
            game.score2 = nil
            game.winner = nil
            game.state = 1
        }
        if (scoreTextField1.text != "--" && scoreTextField2.text != "--" ){
            game.score1 = (Int)(scoreTextField1.text!)!
            game.score2 = (Int)(scoreTextField2.text!)!
            game.winner = game.score1 >= game.score2 ? game.playerA : game.playerB
            game.state = 3
        }
        self.dismissViewControllerAnimated(true) {
            
        }
        callBack()
    }
    
    //按下取消按钮
    @IBAction func cancelBarButton(sender: UIBarButtonItem) {
        for index in availableSiteList {
            if index.isUsing {
                if game.site == nil || game.site.siteID != index.siteID {
                    index.isUsing = false
                }
            }
        }
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    

    
    //点击比分按钮
    @IBAction func scoreButtonClick(sender: UIButton) {
        switch sender.center {
        case leftButtonCenter:
            UIView.animateWithDuration(self.durationTime / 2, animations: {
                self.remarkButton.alpha = 0
                self.scoreButton.alpha = 0.5
                self.siteButton.alpha = 0.5
                }, completion: { (true) in
                    self.remarkButton.center = self.leftButtonCenter
                    self.remarkView.frame.origin.x = -self.view.frame.width
                    UIView.animateWithDuration(self.durationTime / 2, animations: {
                        self.remarkButton.alpha = 1
                        self.scoreButton.alpha = 1
                        self.siteButton.alpha = 1
                    })
            })
            UIView.animateWithDuration(durationTime, animations: {
                sender.transform = CGAffineTransformMakeScale(self.scaleMultiple, self.scaleMultiple)
                sender.center = self.centerButtonCenter
                self.scoreView.frame.origin.x = 0
                self.siteButton.center = self.rightButtonCenter
                self.siteButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.siteView.frame.origin.x = self.view.frame.width
                })
        case rightButtonCenter:
            UIView.animateWithDuration(self.durationTime / 2, animations: {
                self.siteButton.alpha = 0
                self.scoreButton.alpha = 0.5
                self.remarkButton.alpha = 0.5
                }, completion: { (true) in
                    self.siteButton.center = self.rightButtonCenter
                    self.siteView.frame.origin.x = self.view.frame.width
                    UIView.animateWithDuration(self.durationTime / 2, animations: {
                        self.siteButton.alpha = 1
                        self.scoreButton.alpha = 1
                        self.remarkButton.alpha = 1
                    })
            })
            UIView.animateWithDuration(durationTime, animations: {
                sender.center = self.centerButtonCenter
                sender.transform = CGAffineTransformMakeScale(self.scaleMultiple, self.scaleMultiple)
                self.scoreView.frame.origin.x = 0
                self.remarkButton.center = self.leftButtonCenter
                self.remarkButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.remarkView.frame.origin.x = -self.view.frame.width
                })
        default:
            break
        }
        performSelector(#selector(GameEditBoxViewController.updateConstraints), withObject: nil, afterDelay: durationTime)
    }
 
    
    //点击场地按钮
    @IBAction func siteButtonClick(sender: UIButton) {
        UIView.animateWithDuration(durationTime) {
            self.siteView.frame.origin.x = 0
        }
        switch sender.center {
        case leftButtonCenter:
            UIView.animateWithDuration(self.durationTime / 2, animations: {
                self.scoreButton.alpha = 0
                self.siteButton.alpha = 0.5
                self.remarkButton.alpha = 0.5
                }, completion: { (true) in
                    self.scoreButton.center = self.leftButtonCenter
                    self.scoreView.frame.origin.x = -self.view.frame.width
                    UIView.animateWithDuration(self.durationTime / 2, animations: {
                        self.scoreButton.alpha = 1
                        self.siteButton.alpha = 1
                        self.remarkButton.alpha = 1
                    })
            })
            UIView.animateWithDuration(durationTime, animations: {
                sender.transform = CGAffineTransformMakeScale(self.scaleMultiple, self.scaleMultiple)
                sender.center = self.centerButtonCenter
                self.remarkButton.center = self.rightButtonCenter
                self.remarkButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.remarkView.frame.origin.x = self.view.frame.width
            })
        case rightButtonCenter:
            UIView.animateWithDuration(self.durationTime / 2, animations: {
                self.remarkButton.alpha = 0
                self.scoreButton.alpha = 0.5
                self.siteButton.alpha = 0.5
                }, completion: { (true) in
                    self.remarkButton.center = self.rightButtonCenter
                    self.remarkView.frame.origin.x = self.view.frame.width
                    UIView.animateWithDuration(self.durationTime / 2, animations: {
                        self.remarkButton.alpha = 1
                        self.scoreButton.alpha = 1
                        self.siteButton.alpha = 1
                    })
            })
            UIView.animateWithDuration(durationTime, animations: {
                sender.center = self.centerButtonCenter
                sender.transform = CGAffineTransformMakeScale(self.scaleMultiple, self.scaleMultiple)
                self.scoreButton.center = self.leftButtonCenter
                self.scoreButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.scoreView.frame.origin.x = -self.view.frame.width
            })
        default:
            break
        }
        //更新约束
        performSelector(#selector(GameEditBoxViewController.updateConstraints), withObject: nil, afterDelay: durationTime)
    }
    
    
    
    
    
    //点击备注按钮
    @IBAction func remarkButtonClick(sender: UIButton) {
        UIView.animateWithDuration(durationTime) {
            self.remarkView.frame.origin.x = 0
        }

        switch sender.center {
        case leftButtonCenter:
            UIView.animateWithDuration(self.durationTime / 2, animations: {
                self.siteButton.alpha = 0
                self.scoreButton.alpha = 0.5
                self.remarkButton.alpha = 0.5
                }, completion: { (true) in
                    self.siteButton.center = self.leftButtonCenter
                    self.siteView.frame.origin.x = -self.view.frame.width
                    UIView.animateWithDuration(self.durationTime / 2, animations: {
                        self.siteButton.alpha = 1
                        self.scoreButton.alpha = 1
                        self.remarkButton.alpha = 1
                    })
            })
            UIView.animateWithDuration(durationTime, animations: {
                sender.transform = CGAffineTransformMakeScale(self.scaleMultiple, self.scaleMultiple)
                sender.center = self.centerButtonCenter
                self.scoreButton.center = self.rightButtonCenter
                self.scoreButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.scoreView.frame.origin.x = self.view.frame.width
            })
        case rightButtonCenter:
            UIView.animateWithDuration(self.durationTime / 2, animations: {
                self.scoreButton.alpha = 0
                self.siteButton.alpha = 0.5
                self.remarkButton.alpha = 0.5
                }, completion: { (true) in
                    self.scoreButton.center = self.rightButtonCenter
                    self.scoreView.frame.origin.x = self.view.frame.width
                    UIView.animateWithDuration(self.durationTime / 2, animations: {
                        self.scoreButton.alpha = 1
                        self.siteButton.alpha = 1
                        self.remarkButton.alpha = 1
                    })
            })
            UIView.animateWithDuration(durationTime, animations: {
                sender.center = self.centerButtonCenter
                sender.transform = CGAffineTransformMakeScale(self.scaleMultiple, self.scaleMultiple)
                self.siteButton.center = self.leftButtonCenter
                self.siteButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.siteView.frame.origin.x = -self.view.frame.width
            })
        default:
            break
        }
        performSelector(#selector(GameEditBoxViewController.updateConstraints), withObject: nil, afterDelay: durationTime)
    }
    
    
    //更新布局约束
    func updateConstraints() {
        scoreButtonLeadingContraint.constant = scoreButton.center.x - buttonHeight / 2
        scoreButtonTopConstrain.constant = scoreButton.center.y - buttonHeight / 2
        siteButtonLeadingconstrain.constant = siteButton.center.x - buttonHeight / 2
        siteButtonTopConstrain.constant = siteButton.center.y - buttonHeight / 2
        remarkButtonLeadingConstrain.constant = remarkButton.center.x - buttonHeight / 2
        remarkButtonTopConstrain.constant = remarkButton.center.y - buttonHeight / 2
        self.scoreLeadingConstrain.constant = scoreView.frame.origin.x
        self.siteLeadingConstrain.constant = siteView.frame.origin.x
        self.remarkLeadingConstrain.constant = remarkView.frame.origin.x
    }
    
    //回调，传递消息给消息响应类
    func callBack() {
        let notification = NSNotificationCenter.defaultCenter()
        notification.postNotificationName("identityFromGameEditBoxViewController", object: self.game)
    }
 
//    
//    //接收子场景的消息步骤二 消息响应函数
//    func getMessage(notification:NSNotification) {
//        images.append(notification.object as! UIImage)
//        collectionView.reloadData()
//    }
//    
//    //接收子场景的消息步骤三 移除observer
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
//    
    
    
    

    //接收子场景的消息步骤二 消息响应函数
    func getMessage(notification:NSNotification) {
        //查看图片细节时删除图片触发
        if notification.object == nil {
            images.removeAtIndex(tempSelectedCollectionViewCellItem)
            collectionView.reloadData()
            
        }
        //进入图片数据库时获取图片后返回触发
        else {
            let getImages = notification.object as! Array<UIImage>
            for index in getImages {
                images.append(index)
            }
            collectionView.reloadData()
        }
    }
    //接收子场景的消息步骤三 移除observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    //推出图片库视图前准备
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let distin = segue.destinationViewController as! PhotoLibraryViewController
        distin.serverMessageIdentity = messageIdentity
        distin.pickImageCount = maxImageCount - images.count
    }
}
