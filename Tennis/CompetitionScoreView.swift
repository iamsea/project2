//
//  CompetitionManageView.swift
//  Tennis
//
//  Created by seasong on 16/4/10.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class CompetitionScoreView: UIView {
    
    private var fatherViewController: UIViewController!

    var col = 0
    var theClickedButton = GameCellButton()
    
    var siteList = Array<Site>()
    
    var playerButtonArray = Array<UIButton>()
    var GameCellButtonArray = Array<Array<GameCellButton>>()
    private var playerList: Array<Player>!
    private var games: Array<Array<Game>>!
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        self.fatherViewController = fatherViewController
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        loadSiteData()
        loadGamesData()
        loadGameView()
        
        //接收弹出比赛信息编辑窗口后的回调信息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getCompetitionData(_:)), name: "identityFromGameEditBoxViewController", object: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //加载比赛表视图
    func loadGameView() {
        var temp = playerList.count / 2
        while temp != 0 {
            col += 1
            temp /= 2
        }
        var row = (Int)(pow(2.0, (Double)(col)))
        if row < playerList.count {
            col += 1
            row *= 2
        }
        
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor.groupTableViewBackgroundColor()
        scroll.frame = CGRectMake(20, 49, self.bounds.width - 40, self.bounds.height - 69)  //设置scrollview的大小
        scroll.contentSize = CGSizeMake(self.bounds.width - 40, (CGFloat)(row)*29+10)   //内容大小
        //scroll.contentOffset = CGPointMake(0, -10)
        
        //表的第一列，选手列表
        for index in 0..<row {
            let button = UIButton(type: UIButtonType.System)
            let x = CGFloat(0)
            let y = 29*(CGFloat)(index)
            let width = (scroll.contentSize.width -  40  + CGFloat(col))/(CGFloat)(col + 1) + 40 //col+1表示总列数
            let height = CGFloat(30)
            button.frame = CGRectMake(x, y, width, height)
            button.setTitle(playerList[index].name, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.backgroundColor = UIColor.whiteColor()
            //button.titleLabel?.font = UIFont.systemFontOfSize(15)
            button.layer.borderWidth = 0.5
            button.layer.borderColor = myGreen.CGColor
            button.addTarget(self, action: #selector(nameButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
            //button.showsTouchWhenHighlighted = true;
            
            scroll.addSubview(button)
        }
        
        //表的比赛信息
        row /= 2
        for i in 0..<col {
            var tempArray = Array<GameCellButton>()
            for j in 0..<row {
                let button = GameCellButton(type: UIButtonType.System)
                let x = ((scroll.contentSize.width - 40 + CGFloat(col)) / (CGFloat)(col + 1) - 1)*(CGFloat)(i + 1) + 40 //表第一列的长度比其它列的长度长40pixel 减1使边框为1pixel
                let y = 29 * (CGFloat)(pow(2.0, (Double)(i+1)))*(CGFloat)(j)
                let width = (scroll.contentSize.width - 40  + CGFloat(col))/(CGFloat)(col+1)
                let height = 30*(CGFloat)(pow(2.0, (Double)(i+1))) - (CGFloat)(pow(2.0, (Double)(i+1))) + 1
                button.frame = CGRectMake(x, y, width, height)
                button.tintColor = myGreen
                button.backgroundColor = UIColor.whiteColor()
                button.layer.borderWidth = 0.5
                button.layer.borderColor = myGreen.CGColor
                button.addTarget(self, action: #selector(GameCellButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
                //button.showsTouchWhenHighlighted = true;
                button.mark = "\(i)" + "\(j)"
                button.rowIndex = j
                button.colIndex = i
                
                if button.game.state == 0 && i == 0{
                    button.game.playerA = playerList[2*j]
                    button.game.playerB = playerList[2*j+1]
                    button.game.state = 1
                }
                else if button.game.state == 0 {
                    if GameCellButtonArray[i-1][2*j].game.state == 3 {
                        button.game.playerA = GameCellButtonArray[i-1][2*j].game.winner
                    }
                    if GameCellButtonArray[i-1][2*j+1].game.state == 3 {
                        button.game.playerB = GameCellButtonArray[i-1][2*j+1].game.winner
                    }
                    if button.game.playerA != nil && button.game.playerB != nil {
                        button.game.state = 1
                    }
                }
                if button.game.state == 0 {
                    button.setTitle("比赛未开始", forState: .Normal)
                    button.enabled = false
                }
                else if button.game.state == 1 {
                    button.setTitle("分配赛场", forState: .Normal)
                }
                else if button.game.state==2 {
                    button.setTitle("\(button.game.site.siteName)", forState: .Normal)
                }
                else if button.game.state == 3 {
                    button.setTitle("\(button.game.winner.name)", forState: .Normal)
                }
                
                scroll.addSubview(button)
                tempArray.append(button)
            }
            GameCellButtonArray.append(tempArray)
            row /= 2
        }
        
        self.addSubview(scroll)
        
        //表头
        for index in 0...col {
            let label = UILabel()
            label.backgroundColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(15)
            label.layer.borderWidth = 0.5
            label.layer.borderColor = myGreen.CGColor
            if index == 0 {
                let x = CGFloat(20)
                let y = CGFloat(20)
                let width = (self.frame.width - 80 + CGFloat(col))/(CGFloat)(col+1) + 40 //col+1表示总列数，减40是因为第一列比其它列宽40个像素
                let height = CGFloat(30)
                label.frame = CGRectMake(x, y, width, height)
                label.text = "比赛选手"
                
            }
            else {
                let x = ((self.frame.width - 80 + CGFloat(col)) / (CGFloat)(col+1) - 1) * CGFloat(index) + 60
                let y = CGFloat(20)
                let width = (self.frame.width - 80 + CGFloat(col))/(CGFloat)(col+1)
                let height = CGFloat(30)
                label.frame = CGRectMake(x, y, width, height)
                label.text = "第\(index)场"
                if index == col {
                    label.text = "冠军赛"
                }
                else if index == col - 1 && index != 1 {
                    label.text = "半决赛"
                }
                else if index == col - 2 && index != 1 && index != 2 {
                    label.text = "1/4决赛"
                }
            }
            self.addSubview(label)
        }
    }
    
    //加载场地数据
    func loadSiteData() {
        for index in 0...7 {
            let site = Site()
            site.siteName = "\(index)" + "号球场"
            site.siteID = index
            siteList.append(site)
        }
    }
    
    //加载比赛数据
    func loadGamesData() {
        //初始化比赛选手信息
        playerList = Array<Player>()
        for index in 0..<64 {
            let player = Player()
            player.name = "\(index)号比赛选手"
            playerList.append(player)
        }
        
    }
    
    //点击某场比赛
    func GameCellButtonClick(sender:GameCellButton) {
        var availableSiteList = Array<Site>()
        for index in siteList {
            if !index.isUsing || (sender.game.site != nil && index.siteID == sender.game.site.siteID) {
                availableSiteList.append(index)
            }
        }
        let editViewController = fatherViewController.storyboard?.instantiateViewControllerWithIdentifier("EditBox")
        editViewController?.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        editViewController?.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        let editView = editViewController?.childViewControllers[0] as! GameEditBoxViewController
        //let editView = editViewController as! GameEditBoxViewController //这样写好规范吗
        editView.game = sender.game
        editView.availableSiteList = availableSiteList
        fatherViewController.presentViewController(editViewController!, animated: true) {
            
        }
        theClickedButton = sender
    }
    
    func nameButtonClick(sender:GameCellButton) {
        
    }
    
    //接收弹出比赛信息后回调的响应函数
    func getCompetitionData(notification:NSNotification) {
        
        var game = Game()
        game = notification.object as! Game
        theClickedButton.game = game
        if game.state == 2 {
            theClickedButton.setTitle("\(game.site.siteName)", forState: .Normal)
        }
        else if game.state == 3 {
            theClickedButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            theClickedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            theClickedButton.setTitle("\(game.winner.name)\n    \(game.score1):\(game.score2)", forState: .Normal)
            for index in siteList {
                if game.site != nil && index.siteID == game.site.siteID {
                    index.isUsing = false
                }
            }
        }
        else {
            theClickedButton.setTitle("分配赛场", forState: .Normal)
        }
        if theClickedButton.rowIndex != col-1 {
            let nextCompetitionButton = GameCellButtonArray[theClickedButton.colIndex+1][theClickedButton.rowIndex/2]
            if theClickedButton.rowIndex % 2 == 0 {
                nextCompetitionButton.game.playerA = game.winner
            }
            else {
                nextCompetitionButton.game.playerB = game.winner
            }
            if nextCompetitionButton.game.playerA != nil && nextCompetitionButton.game.playerB != nil {
                nextCompetitionButton.game.state = 1
                nextCompetitionButton.setTitle("分配场地", forState: .Normal)
                nextCompetitionButton.enabled = true
            }
            else {
                nextCompetitionButton.game.state = 0
                nextCompetitionButton.setTitle("比赛未开始", forState: .Normal)
                nextCompetitionButton.enabled = false
            }
        }
        
    }
    //接收回调信息
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
