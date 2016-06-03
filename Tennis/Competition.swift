//
//  Competition.swift
//  Tennis
//
//  Created by seasong on 16/4/21.
//  Copyright © 2016年 seasong. All rights reserved.
//

import Foundation

class Competition {
    var name: String!
    var ID: String!
    var time: String!
    var address: String!
    var beginSigningUpTime: String!
    var endSigningUpTime: String!
    var state: Bool = false
    var playerCount = 0
    var champion: Player!
    var secondPlace: Player!
    var thirdPlace: Player!
    var seedPlayerList = Array<Player>()
    var outOfGameAtBeforePlayerList = Array<Player>()
    var outOfGameInMiddlePlayerlist = Array<Player>()
}