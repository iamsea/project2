//
//  CompetitionInformationView.swift
//  Tennis
//
//  Created by seasong on 16/4/21.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class CompetitionInformationView: UIView {
    
    private var fatherViewController: UIViewController!
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        self.fatherViewController = fatherViewController
        backgroundColor = UIColor.groupTableViewBackgroundColor()

        let workAreaView = UIView(frame: CGRectMake(20, 20, frame.width - 40, frame.height - 40))
        workAreaView.backgroundColor = UIColor.whiteColor()
        
        let nameStaticLabel = UILabel(frame: CGRectMake(250, 70, 90, 40))
        nameStaticLabel.text = "赛事名称："
        nameStaticLabel.textColor = UIColor.lightGrayColor()
        let nameLabel = UILabel(frame: CGRectMake(340, 70, frame.width - 360, 40))
        nameLabel.text = checkedCompetition.name
        let timeStaticLabel = UILabel(frame: CGRectMake(250, 130, 90, 40))
        timeStaticLabel.text = "赛事时间："
        timeStaticLabel.textColor = UIColor.lightGrayColor()
        let timeLabel = UILabel(frame: CGRectMake(340, 130, frame.width - 360, 40))
        timeLabel.text = checkedCompetition.time
        let addressStaticLabel = UILabel(frame: CGRectMake(250, 190, 90, 40))
        addressStaticLabel.text = "赛事地点："
        addressStaticLabel.textColor = UIColor.lightGrayColor()
        let addressLabel = UILabel(frame: CGRectMake(340, 190, frame.width - 360, 40))
        addressLabel.text = checkedCompetition.address
        let signingUpTimeStaticLabel = UILabel(frame: CGRectMake(250, 250, 90, 40))
        signingUpTimeStaticLabel.text = "报名时间："
        signingUpTimeStaticLabel.textColor = UIColor.lightGrayColor()
        let signingUpTimeLabel = UILabel(frame: CGRectMake(340, 250, frame.width - 360, 40))
        signingUpTimeLabel.text = checkedCompetition.beginSigningUpTime + " - " + checkedCompetition.endSigningUpTime
        
        let editButton = UIButton(type: .System)
        editButton.frame = CGRectMake(340, 310, 150, 26)
        editButton.setTitle("编辑", forState: .Normal)
        editButton.tintColor = myGreen
        editButton.layer.borderWidth = 0.5
        editButton.layer.borderColor = myGreen.CGColor
        editButton.layer.cornerRadius = 13
        editButton.addTarget(self, action: #selector(CompetitionInformationView.editButtonClick), forControlEvents: .TouchUpInside)
        
        let playerCountStaticLabel = UILabel(frame: CGRectMake(250, 400, 120, 40))
        playerCountStaticLabel.text = "当前报名人数："
        playerCountStaticLabel.textColor = UIColor.lightGrayColor()
        let playerCountLabel = UILabel(frame: CGRectMake(370, 400, 100, 40))
        playerCountLabel.text = "\(checkedCompetition.playerCount)人"
        let competitionStateStaticLabel = UILabel(frame: CGRectMake(250, 460, 90, 40))
        competitionStateStaticLabel.text = "比赛状态："
        competitionStateStaticLabel.textColor = UIColor.lightGrayColor()
        let segment = UISegmentedControl(frame: CGRectMake(340, 467, 150, 26))
        segment.insertSegmentWithTitle("关闭", atIndex: 0, animated: true)
        segment.insertSegmentWithTitle("开启", atIndex: 1, animated: true)
        segment.addTarget(self, action: #selector(segmentStateChange), forControlEvents: .ValueChanged)
        segment.tintColor = myGreen
        segment.selectedSegmentIndex = 0
        
        workAreaView.addSubview(nameStaticLabel)
        workAreaView.addSubview(nameLabel)
        workAreaView.addSubview(timeStaticLabel)
        workAreaView.addSubview(timeLabel)
        workAreaView.addSubview(addressStaticLabel)
        workAreaView.addSubview(addressLabel)
        workAreaView.addSubview(signingUpTimeStaticLabel)
        workAreaView.addSubview(signingUpTimeLabel)
        workAreaView.addSubview(editButton)
        workAreaView.addSubview(playerCountStaticLabel)
        workAreaView.addSubview(playerCountLabel)
        workAreaView.addSubview(competitionStateStaticLabel)
        workAreaView.addSubview(segment)
        
        
        self.addSubview(workAreaView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func editButtonClick() {
        let informationEditBoxViewController = fatherViewController.storyboard?.instantiateViewControllerWithIdentifier("competitionEditViewController")
        informationEditBoxViewController?.modalPresentationStyle = .FormSheet
        //let GameEditBoxViewController = informationEditBoxViewController?.childViewControllers[0] as! InformationEditBoxViewController
        //editBoxViewController.competition = self.checkedCompetition
        fatherViewController.presentViewController(informationEditBoxViewController!, animated: true, completion: nil)
    }
    
    func segmentStateChange(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 && sender.numberOfSegments == 2 {
            sender.frame = CGRectMake(340, 467, 225, 26)
            sender.insertSegmentWithTitle("结束", atIndex: 2, animated: true)
        }
        else if sender.selectedSegmentIndex == 0 && sender.numberOfSegments == 3 {
            sender.frame = CGRectMake(340, 467, 150, 26)
            sender.removeSegmentAtIndex(2, animated: true)
        }
    }

}
