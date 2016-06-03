//
//  Player.swift
//  Tennis
//
//  Created by seasong on 16/4/5.
//  Copyright © 2016年 seasong. All rights reserved.
//

import Foundation

class Game {
    var playerA: Player!
    var playerB: Player!
    var score1: Int!
    var score2: Int!
    var site: Site!
    var state = 0 //state=0表示比赛未能开始，1表示比赛(选手到位)可以开始，2表示已选赛场，3表示已录入比分
    var winner: Player!
}
