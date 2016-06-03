//
//  PlayerView.swift
//  Tennis
//
//  Created by seasong on 16/4/22.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class PlayerCellView: UIView {
    
    private var player: Player!
    private var nameLabel: UILabel!
    private var imageView: UIImageView!
    private var seedPlayerSwitch: UISwitch!
    init(origin: CGPoint, player: Player) {
        super.init(frame: CGRectMake(origin.x, origin.y, 210, 130))
        self.player = player
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = myGreen.CGColor
        
        loadPlayerView()
        //消息响应服务
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(messageResponse), name: "PlayerInformationBoxNotification", object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //加载选手视图
    func loadPlayerView() {
        nameLabel = UILabel(frame: CGRectMake(0, 0, frame.width, 28))
        nameLabel.text = player.name
        nameLabel.font = UIFont.systemFontOfSize(15)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.backgroundColor = myGreen
        nameLabel.textAlignment = .Center
        self.addSubview(nameLabel)
        
        imageView = UIImageView(frame: CGRectMake(8, 36, 86, 86))
        imageView.image = UIImage(named: "logo2")
        imageView.userInteractionEnabled = true
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(imageTouched))
        imageView.addGestureRecognizer(tapGest)
        self.addSubview(imageView)
        
        let seedLabel = UILabel(frame: CGRectMake(121, 51, 60, 18))
        seedLabel.text = "种子选手"
        seedLabel.font = UIFont.systemFontOfSize(15)
        self.addSubview(seedLabel)
        
        seedPlayerSwitch = UISwitch(frame: CGRectMake(126, 80, 51, 31))
        seedPlayerSwitch.on = player.isSeedPlayer
        seedPlayerSwitch.addTarget(self, action: #selector(switchStateChange), forControlEvents: .TouchUpInside)
        self.addSubview(seedPlayerSwitch)
    }
    
    //imageView响应函数
    func imageTouched(sender: UITapGestureRecognizer) {
        //弹出选手信息框
        let playerInformationBox = superViewController.storyboard?.instantiateViewControllerWithIdentifier("playerInformation")
        playerInformationBox?.modalPresentationStyle = .FormSheet
        playerInformationBox?.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        let viewController = playerInformationBox?.childViewControllers[0] as! PlayerInformationBoxTableViewController
        viewController.player = self.player
        
        superViewController.presentViewController(playerInformationBox!, animated: true, completion: nil)
    }
    
    //消息响应函数
    func messageResponse() {
        //更新数据，连接数据库后需要再改
        self.seedPlayerSwitch.on = self.player.isSeedPlayer
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //开关按钮响应函数
    func switchStateChange(sender: UISwitch) {
        if sender.on == true {
            player.isSeedPlayer = true
        }
        else {
            player.isSeedPlayer = false
        }
    }
}
