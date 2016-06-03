//
//  PlayerManageView.swift
//  Tennis
//
//  Created by seasong on 16/4/21.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class PlayerManageView: UIView {
    
    private var fatherViewController: UIViewController!
    private var playerList: Array<Player>!
    
    init(frame: CGRect, fatherViewController: UIViewController) {
        super.init(frame: frame)
        self.fatherViewController = fatherViewController
        backgroundColor = UIColor.groupTableViewBackgroundColor()

        loadPlayerList()
        loadPlayerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //加载比赛选手数据
    func loadPlayerList() {
        playerList = Array<Player>()
        for index in 0...63 {
            let player = Player()
            player.name = "\(index)号比赛选手"
            player.sex = "男"
            player.age = 20
            playerList.append(player)
        }
    }
    
    //加载比赛选手界面
    func loadPlayerView() {
        let scorllView = UIScrollView()
        scorllView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        scorllView.frame = CGRectMake(20, 20, frame.width - 35, frame.height - 40)
        scorllView.contentSize = CGSizeMake(frame.width - 35, CGFloat(playerList.count / 4 + min(playerList.count % 4, 1)) * 150 - 20)
        
        for index in 0..<playerList.count {
            let x: CGFloat = 230 * CGFloat(index % 4)
            let y: CGFloat = CGFloat(index / 4) * 150
            let playerView = PlayerCellView(origin: CGPointMake(x , y), player: playerList[index])
            scorllView.addSubview(playerView)
        }
        self.addSubview(scorllView)
    }
}
