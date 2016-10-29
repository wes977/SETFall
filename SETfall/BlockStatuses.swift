//
//  BlockStatus.swift
//  SETfall
//
//  Created by Student on 2016-10-24.
//  Copyright © 2016 WesNet. All rights reserved.
//

import Foundation

class BlockStatus {
    var isRunning = false
    var timeGapForNextRun = UInt32(0)
    var currentInterval = UInt32(0)
    init (isRunning:Bool,ntimeGapNextRun:UInt32,ncurrentInterval:UInt32)
    {
        self.isRunning = isRunning
        self.timeGapForNextRun = ntimeGapNextRun
        self.currentInterval = ncurrentInterval
    }
    
    func shouldRunBlock() -> Bool {
        return self.currentInterval > self.timeGapForNextRun
    }
}
