//
//  CompetitionView.swift
//  Tennis
//
//  Created by seasong on 16/4/21.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

var checkedCompetition: Competition!

class CompetitionView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var competitionInformationView: CompetitionInformationView!
    private var competitionRecord: CompetitionScoreView!
    private var playerManageView: PlayerManageView!
    private var competitionResultView: CompetitionResultView!
    
    private var fatherViewController: UIViewController!
    private var markBarView: UIView!
    private var lastOptionButton: UIButton!
    
    private var pop: Popover!
    private var competitionNameList = Array<String>()
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        self.fatherViewController = fatherViewController
        backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        loadCompetitionDate()
        
        let workAreaRect = CGRect(x: 0, y: 100.5, width: frame.width, height: frame.height - 100)
        //标题栏
        let titleBarView = UIView(frame: CGRectMake(0, 0, frame.width, 55))
        titleBarView.backgroundColor = myGreen
        let showAllCompititionButton = UIButton()
        showAllCompititionButton.frame = CGRectMake(8, 22, 30, 30)
        showAllCompititionButton.setImage(UIImage(named: "show_normal"), forState: .Normal)
        showAllCompititionButton.addTarget(self, action: #selector(showAllCompetitionButtonClick), forControlEvents: .TouchUpInside)
        let addCompititionButton = UIButton()
        addCompititionButton.frame = CGRectMake(frame.width - 30 - 8, 22, 30, 30)
        addCompititionButton.setImage(UIImage(named: "add_normal"), forState: .Normal)
        addCompititionButton.addTarget(self, action: #selector(addCompetitionButtonClick), forControlEvents: .TouchUpInside)
        let competitionNameLabel = UILabel(frame: CGRectMake(38, 26, frame.width - 76, 22))
        competitionNameLabel.text = checkedCompetition.name
        competitionNameLabel.textColor = UIColor.whiteColor()
        competitionNameLabel.textAlignment = .Center
        titleBarView.addSubview(showAllCompititionButton)
        titleBarView.addSubview(addCompititionButton)
        titleBarView.addSubview(competitionNameLabel)
        
        //选项栏
        let optionBarView = UIView(frame: CGRectMake(0, 55, frame.width, 45))
        optionBarView.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)
        for index in 0...3 {
            let button = UIButton(type: .System)
            button.frame = CGRectMake(bounds.width / 4 * CGFloat(index), 0, bounds.width / 4, 44)
            button.tag = index
            switch index {
            case 0:
                button.setTitle("基本信息", forState: .Normal)
                button.tintColor = myGreen
                lastOptionButton = button
            case 1:
                button.setTitle("比赛选手", forState: .Normal)
                button.tintColor = UIColor.darkGrayColor()
            case 2:
                button.setTitle("比赛记录", forState: .Normal)
                button.tintColor = UIColor.darkGrayColor()
            default:
                button.setTitle("比赛结果", forState: .Normal)
                button.tintColor = UIColor.darkGrayColor()
            }
            button.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
            button.addTarget(self, action: #selector(VenueView.optionButtonClick(_:)), forControlEvents: .TouchUpInside)
            optionBarView.addSubview(button)
        }
        
        //选项栏底部分割线
        let bottomLine = UIView(frame: CGRectMake(0, 45, frame.width, 0.5))
        bottomLine.backgroundColor = UIColor.lightGrayColor()
        bottomLine.alpha = 0.2
        optionBarView.addSubview(bottomLine)
        
        //标志选中状态
        markBarView = UIView(frame: CGRectMake((bounds.width / 4 - bounds.width / 6) / 2, 44, bounds.width / 6, 1))
        markBarView.backgroundColor = myGreen
        optionBarView.addSubview(markBarView)
        
        //初始化各赛事界面
        competitionInformationView = CompetitionInformationView(frame: workAreaRect, fatherViewController: self.fatherViewController)
        competitionRecord = CompetitionScoreView(frame: workAreaRect, fatherViewController: self.fatherViewController)
        playerManageView = PlayerManageView(frame: workAreaRect, fatherViewController: self.fatherViewController)
        competitionResultView = CompetitionResultView(frame: workAreaRect, fatherViewController: self.fatherViewController)
        
        self.addSubview(titleBarView)
        self.addSubview(optionBarView)
        self.addSubview(competitionRecord)
        self.addSubview(playerManageView)
        self.addSubview(competitionResultView)
        self.addSubview(competitionInformationView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //加载赛事数据
    func loadCompetitionDate() {
        checkedCompetition = Competition()
        checkedCompetition.name = "2016东莞理工学院网球公开赛"
        checkedCompetition.address = "广东省东莞市东莞理工学院松山湖校区"
        checkedCompetition.time = "2016年06月06日"
        checkedCompetition.beginSigningUpTime = "2016年04月04日"
        checkedCompetition.endSigningUpTime = "2016年05月05日"
        
        competitionNameList.append("2016东莞理工网球公开赛")
        for index in 0...3 {
            competitionNameList.append("赛事名称\(index)")
        }
    }
    
    //选项卡按钮点击
    func optionButtonClick(sender: UIButton) {
        UIView.animateWithDuration(0.3, animations: {
            self.markBarView.frame = CGRectMake(self.bounds.width / 4 * CGFloat(sender.tag) + (self.bounds.width / 4 - self.bounds.width / 6) / 2, 44, self.bounds.width / 6, 1)
            self.lastOptionButton.tintColor = UIColor.darkGrayColor()
            sender.tintColor = myGreen
        })
        switch sender.tag {
        case 0:
            bringSubviewToFront(competitionInformationView)
        case 1:
            bringSubviewToFront(playerManageView)
        case 2:
            bringSubviewToFront(competitionRecord)
        default:
            bringSubviewToFront(competitionResultView)
        }
        
        lastOptionButton = sender
    }
    
    //点击赛事列表按钮
    func showAllCompetitionButtonClick(sender: UIButton) {
        let competitionTable = UITableView(frame: CGRectMake(0, 0, 270, 310))
        competitionTable.tableFooterView = UIView(frame: CGRectZero)
        competitionTable.separatorColor = UIColor.clearColor()
        competitionTable.delegate = self
        competitionTable.dataSource = self
        pop = Popover()
//        pop.alignmentRectForFrame(CGRectMake(100, 55, 500, 500))
//        pop.show(competitionTable, point: CGPointMake(104, 52))
//        pop.show(competitionTable, fromView: self)
//        pop.show(competitionTable, point: CGPointMake(14, 48), inView: self)
        pop.sideEdge = 5
        pop.show(competitionTable, fromView: sender, inView: self)
    }

    //点击添加赛事按钮
    func addCompetitionButtonClick() {
        let addCompetitionTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("addCompetitionViewController")
        addCompetitionTableViewController.modalPresentationStyle = .FormSheet
        superViewController.presentViewController(addCompetitionTableViewController, animated: true, completion: nil)
    }
    
    //tableView代理函数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitionNameList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier="identtifier";
        var cell=tableView.dequeueReusableCellWithIdentifier(identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier);
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.Default
        cell?.textLabel?.text = competitionNameList[indexPath.row]
        cell?.textLabel?.textAlignment = .Center
//        cell!.textLabel!.textColor = myGreen
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pop.dismiss()
    }
    
}
