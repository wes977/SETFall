//
//  Villian.swift
//  SETfall
//
//  Created by Student on 2016-10-27.
//  Copyright © 2016 WesNet. All rights reserved.
//


// Not really used anymore but setting up for future endevorse
import Foundation
class Villian {
    
    var isRunning = false
    var timeGapForNextRun = UInt32(0)
    var currentInterval = UInt32(0)
    var minX = UInt32(0)
    var maxX = UInt32(0)
    var speed = UInt32(0)
    var villianX = UInt32(0)
    var movingLeft = false
    
    
    init (iMinX:UInt32,iMaxX:UInt32,iSpeed:UInt32)
    {
        self.minX = iMinX
        self.maxX = iMaxX
        self.speed = iSpeed
    }
    
    
    func villianMove (iMinX:UInt32,iMaxX:UInt32){
        self.minX = iMinX
        self.maxX = iMaxX
        
        if movingLeft
        {
            villianX -= self.speed
        }
        else
        {
            villianX += self.speed
        }
        
        if villianX < minX{
            movingLeft = false
        }
        else if villianX > maxX{
            movingLeft = true
        }
    }
    
    func shouldRunBlock() -> Bool {
        return self.currentInterval > self.timeGapForNextRun
    }
}
