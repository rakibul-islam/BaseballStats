//
//  BattingStats.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class BattingStats: PlayerStat {
    var numberFormatter = NumberFormatter()
    
    var stolenBases: Int
    var caughtStealing: Int
    var runsBattedIn: Int
    
    override init(dictionary: [String: Any]) {
        stolenBases = dictionary["SB"] as? Int ?? 0
        caughtStealing = dictionary["CS"] as? Int ?? 0
        runsBattedIn = dictionary["RBI"] as? Int ?? 0
        super.init(dictionary: dictionary)
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 3
        numberFormatter.minimumFractionDigits = 3
        numberFormatter.minimumIntegerDigits = 0
        numberFormatter.maximumIntegerDigits = 1
    }
    
    //MARK: - Calculated values
    
    var average: Float {
        get {
            guard atBats > 0 else {
                return 0
            }
            return Float(hits) / Float(atBats)
        }
    }
    
    var onBasePercentage: Float {
        get {
            let calculatedPA = atBats + walks + hitByPitch + sacrificeFlies
            guard calculatedPA > 0 else {
                return 0
            }
            return Float(hits + walks + hitByPitch) / Float(calculatedPA)
        }
    }
    
    var slugging: Float {
        get {
            guard atBats > 0 else {
                return 0
            }
            let weightedHits = singles + (2 * doubles) + (3 * triples) + (4 * homeRuns)
            return Float(weightedHits) / Float(atBats)
        }
    }
    
    var ops: Float {
        get {
            return onBasePercentage + slugging
        }
    }
    
    //MARK: - ViewModel methods
    
    var averageString: String {
        get {
            return numberFormatter.string(from: NSNumber(value: average)) ?? ""
        }
    }
    
    var obpString: String {
        get {
            return numberFormatter.string(from: NSNumber(value: onBasePercentage)) ?? ""
        }
    }
    
    var sluggingString: String {
        get {
            return numberFormatter.string(from: NSNumber(value: slugging)) ?? ""
        }
    }
    
    var opsString: String {
        get {
            return numberFormatter.string(from: NSNumber(value: ops)) ?? ""
        }
    }
}
