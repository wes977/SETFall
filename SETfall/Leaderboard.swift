//
//  Leaderboard.swift
//  SETfall
//
//  Created by Student on 2016-10-26.
//  Copyright © 2016 WesNet. All rights reserved.
//

import Foundation

class Leaderboard {

    
    // This is so that in the same instance of the game is remebered
    static let sharedInstance = Leaderboard()
    
    var leaderBoard = [69 : "Wes Thompson",4 : "Doreen Thompson",68: "Bill Nye", 72: "Jake from state farm" ,65 : "Murray Thompson",60: "Bill Jefferson", 42: "Tim" ]
    
    
    func addScore(_ nScore: Int,  nName: String)
    {
      leaderBoard[nScore] = nName
    }

    func getLeaderboardOrder() -> Array<Int>{
        let sortedKeys = Array(leaderBoard.keys).sorted(by: >)
        return sortedKeys
    }
    
    func getLeaderboard() -> Dictionary<Int,String>{
        return leaderBoard
    }
}
