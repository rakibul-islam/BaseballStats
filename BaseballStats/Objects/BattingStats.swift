//
//  BattingStats.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class BattingStats: PlayerStat {
    //MARK: - ViewModel methods
    
    var averageString: String? {
        get {
            guard let battingObject = managedObject as? BattingStatMO else {
                return nil
            }
            return NumberFormatters.battingNumberFormatter.string(from: NSNumber(value: battingObject.getAverage()))
        }
    }
    
    var obpString: String? {
        get {
            guard let battingObject = managedObject as? BattingStatMO else {
                return nil
            }
            return NumberFormatters.battingNumberFormatter.string(from: NSNumber(value: battingObject.getOnBasePercentage()))
        }
    }
    
    var sluggingString: String? {
        get {
            guard let battingObject = managedObject as? BattingStatMO else {
                return nil
            }
            return NumberFormatters.battingNumberFormatter.string(from: NSNumber(value: battingObject.getSlugging()))
        }
    }
    
    var opsString: String? {
        get {
            guard let battingObject = managedObject as? BattingStatMO else {
                return nil
            }
            return NumberFormatters.battingNumberFormatter.string(from: NSNumber(value: battingObject.getOPS()))
        }
    }
    
    override var displayValues: [String?] {
        get {
            guard let battingObject = managedObject as? BattingStatMO else {
                return super.displayValues
            }
            return ["\(battingObject.games)",
                "\(battingObject.atBats)",
                "\(battingObject.getHits())",
                "\(battingObject.strikeouts)",
                "\(battingObject.getWalks())",
                "\(battingObject.homeRuns)",
                averageString,
                obpString,
                sluggingString,
                opsString]
        }
    }
}
