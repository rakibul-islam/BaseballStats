//
//  PitchingStatMO+Extension.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/4/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import Foundation

extension PitchingStatMO {
    func setupPitchingFrom(dictionary: [String: Any]) {
        super.setupFrom(dictionary: dictionary)
        outs = dictionary["OUTS"] as? Int16 ?? 0
        earnedRuns = dictionary["ER"] as? Int16 ?? 0
        gamesStarted = dictionary["GS"] as? Int16 ?? 0
        gamesFinished = dictionary["GF"] as? Int16 ?? 0
        completeGames = dictionary["CG"] as? Int16 ?? 0
        shutouts = dictionary["SHO"] as? Int16 ?? 0
        wins = dictionary["W"] as? Int16 ?? 0
        losses = dictionary["L"] as? Int16 ?? 0
        saves = dictionary["SV"] as? Int16 ?? 0
    }
    
    //MARK: - Calculated values
    var inningsPitched: Float {
        get {
            let remainder = Float(outs).truncatingRemainder(dividingBy: 3.0)
            let result = Float(outs / 3) + remainder / 10.0
            return result
        }
    }
    
    var era: Float {
        get {
            guard outs > 0 else {
                return 0
            }
            return Float(earnedRuns * 27) / Float(outs)
        }
    }
}
