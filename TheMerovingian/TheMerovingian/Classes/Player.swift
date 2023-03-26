//
//  Player.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit

class Player: NSObject {
    var playerId: Int?
    var gamerTag: String?
    var level: String?
    var experience: Int?
    var gold: Int?
    
    func initWithData(theId id: Int, theTag tag: String, theLevel lvl: String, theExp exp: Int, theGold g: Int) {
        playerId = id
        gamerTag = tag
        level = lvl
        experience = exp
        gold = g
    }
}
