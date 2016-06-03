//
//  CompetitionResultView.swift
//  Tennis
//
//  Created by seasong on 16/4/21.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class CompetitionResultView: UIView {
    
    private var fatherViewController: UIViewController!
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        self.fatherViewController = fatherViewController
        backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let scorllView = UIScrollView()
        scorllView.frame = CGRectMake(20, 20, frame.width - 40, frame.height - 40)
        scorllView.backgroundColor = UIColor.whiteColor()
        
        let championImageView = UIImageView(frame: CGRectMake(328, 53, 30, 30))
        championImageView.image = UIImage(named: "champion_normal")
        scorllView.addSubview(championImageView)
        
        let championStaticLabel = UILabel(frame: CGRectMake(360, 50, 60, 40))
        championStaticLabel.text = "冠军："
        championStaticLabel.textColor = UIColor(red: 255/255, green: 21/255, blue: 75/255, alpha: 1)
        scorllView.addSubview(championStaticLabel)
        
        let championNameButton = UIButton(type: .System)
        championNameButton.frame = CGRectMake(430, 50, frame.width - 360, 40)
        championNameButton.setTitle("0号比赛选手", forState: .Normal)
        championNameButton.tintColor = myGreen
        championNameButton.contentHorizontalAlignment = .Left
        championNameButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        scorllView.addSubview(championNameButton)
        
        let secondImageView = UIImageView(frame: CGRectMake(328, 103, 30, 30))
        secondImageView.image = UIImage(named: "second_normal")
        scorllView.addSubview(secondImageView)
        
        let secondPlaceStaticLabel = UILabel(frame: CGRectMake(360, 100, 60, 40))
        secondPlaceStaticLabel.text = "亚军："
        secondPlaceStaticLabel.textColor = UIColor(red: 0, green: 141/255, blue: 222/255, alpha: 1)
        scorllView.addSubview(secondPlaceStaticLabel)
        
        let secondPlaceNameButton = UIButton(type: .System)
        secondPlaceNameButton.frame = CGRectMake(430, 100, frame.width - 360, 40)
        secondPlaceNameButton.setTitle("1号比赛选手", forState: .Normal)
        secondPlaceNameButton.tintColor = myGreen
        secondPlaceNameButton.contentHorizontalAlignment = .Left
        secondPlaceNameButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        scorllView.addSubview(secondPlaceNameButton)
        
        let shirdImageView = UIImageView(frame: CGRectMake(328, 153, 30, 30))
        shirdImageView.image = UIImage(named: "third_normal")
        scorllView.addSubview(shirdImageView)
        
        let shirdPlaceStaticLabel = UILabel(frame: CGRectMake(360, 150, 60, 40))
        shirdPlaceStaticLabel.text = "季军："
        shirdPlaceStaticLabel.textColor = UIColor(red: 0, green: 158/255, blue: 112/255, alpha: 1)
        scorllView.addSubview(shirdPlaceStaticLabel)
        
        let shirdPlaceNameButton1 = UIButton(type: .System)
        shirdPlaceNameButton1.frame = CGRectMake(430, 150, 250, 40)
        shirdPlaceNameButton1.setTitle("2号比赛选手", forState: .Normal)
        shirdPlaceNameButton1.titleLabel?.font = UIFont.systemFontOfSize(17)
        shirdPlaceNameButton1.tintColor = myGreen
        shirdPlaceNameButton1.contentHorizontalAlignment = .Left
        scorllView.addSubview(shirdPlaceNameButton1)
        
        let shirdPlaceNameButton2 = UIButton(type: .System)
        shirdPlaceNameButton2.frame = CGRectMake(430, 180, 250, 40)
        shirdPlaceNameButton2.setTitle("3号比赛选手", forState: .Normal)
        shirdPlaceNameButton2.titleLabel?.font = UIFont.systemFontOfSize(17)
        shirdPlaceNameButton2.tintColor = myGreen
        shirdPlaceNameButton2.contentHorizontalAlignment = .Left
        scorllView.addSubview(shirdPlaceNameButton2)
        
        
        let seedPlayerStaticLabel = UILabel(frame: CGRectMake(200, 250, 90, 40))
        seedPlayerStaticLabel.text = "种子选手："
        seedPlayerStaticLabel.textColor = UIColor.lightGrayColor()
        scorllView.addSubview(seedPlayerStaticLabel)
        
        for index in 0..<8 {
            let seedNameButton = UIButton(type: .System)
            seedNameButton.frame = CGRectMake(320 + 200 * CGFloat(index % 2), 250 + 30 * CGFloat(index / 2), 200, 40)
            seedNameButton.setTitle("\(index)号比赛选手", forState: .Normal)
            seedNameButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            seedNameButton.tintColor = myGreen
            seedNameButton.contentHorizontalAlignment = .Left
            scorllView.addSubview(seedNameButton)
        }
        
        let outOfGameAtBeforePlayerStaticLabel = UILabel(frame: CGRectMake(200, 300 + 30 * CGFloat(7 / 2), 90, 40))
        outOfGameAtBeforePlayerStaticLabel.text = "赛前退出："
        outOfGameAtBeforePlayerStaticLabel.textColor = UIColor.lightGrayColor()
        scorllView.addSubview(outOfGameAtBeforePlayerStaticLabel)

        for index in 0..<3 {
            let seedNameButton = UIButton(type: .System)
            seedNameButton.frame = CGRectMake(320 + 200 * CGFloat(index % 2), 300 + 30 * CGFloat(7 / 2) + 30 * CGFloat(index / 2), 200, 40)
            seedNameButton.setTitle("\(index)号比赛选手", forState: .Normal)
            seedNameButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            seedNameButton.tintColor = myGreen
            seedNameButton.contentHorizontalAlignment = .Left
            scorllView.addSubview(seedNameButton)
        }
        
        let outOfGameAtMiddlePlayerStaticLabel = UILabel(frame: CGRectMake(200, 350 + 30 * CGFloat(7 / 2 + 3 / 2), 90, 40))
        outOfGameAtMiddlePlayerStaticLabel.text = "中场退出："
        outOfGameAtMiddlePlayerStaticLabel.textColor = UIColor.lightGrayColor()
        scorllView.addSubview(outOfGameAtMiddlePlayerStaticLabel)
        
        for index in 0..<2 {
            let seedNameButton = UIButton(type: .System)
            seedNameButton.frame = CGRectMake(320 + 200 * CGFloat(index % 2), 350 + 30 * CGFloat(7 / 2 + 3 / 2) + 30 * CGFloat(index / 2), 200, 40)
            seedNameButton.setTitle("\(index)号比赛选手", forState: .Normal)
            seedNameButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            seedNameButton.tintColor = myGreen
            seedNameButton.contentHorizontalAlignment = .Left
            scorllView.addSubview(seedNameButton)
        }
        
        scorllView.contentSize = CGSizeMake(frame.width - 40, 400 + 30 * CGFloat(7 / 2 + 2 / 2 + 1 / 2) )
        self.addSubview(scorllView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
