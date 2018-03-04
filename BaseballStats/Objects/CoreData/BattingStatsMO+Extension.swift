//
//  BattingStatsMO+Extension.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/4/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import Foundation

extension BattingStatMO {
    func setupBattingFrom(dictionary: [String: Any]) {
        super.setupFrom(dictionary: dictionary)
        stolenBases = dictionary["SB"] as? Int16 ?? 0
        caughtStealing = dictionary["CS"] as? Int16 ?? 0
        runsBattedIn = dictionary["RBI"] as? Int16 ?? 0
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
}
