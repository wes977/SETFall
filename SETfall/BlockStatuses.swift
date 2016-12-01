//
//  BlockStatus.swift
//  SETfall
//
//  Created by Student on 2016-10-24.
//  Copyright © 2016 WesNet. All rights reserved.
//

import Foundation
// for enemy controls and all that this at one point was better but then realised I dont really needed it to much 
class BlockStatus {
    enum EnemeyType:UInt32{
        case fireEnemy = 1
        case block = 2
        case villianEnemy = 3
        case barrelEnemy = 4
    }
    
    var isRunning = false
    var timeGapForNextRun = UInt32(0)
    var currentInterval = UInt32(0)
    var enemy = UInt32(0)
    
    init (isRunning:Bool,ntimeGapNextRun:UInt32,ncurrentInterval:UInt32,enemyType:UInt32)
    {
        self.isRunning = isRunning
        self.timeGapForNextRun = ntimeGapNextRun
        self.currentInterval = ncurrentInterval
        self.enemy = enemyType
    }
    // are we ready to run
    func shouldRunBlock() -> Bool {
        return true
        //return self.currentInterval > self.timeGapForNextRun
    }
}
