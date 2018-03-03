//
//  PitchingStats.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/2/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class PitchingStats: PlayerStat {
    var numberFormatter = NumberFormatter()
    
    var outs: Int
    var earnedRuns: Int
    var gamesStarted: Int
    var gamesFinished: Int
    var completeGames: Int
    var shutouts: Int
    var wins: Int
    var losses: Int
    var saves: Int
    
    override init(dictionary: [String: Any]) {
        outs = dictionary["OUTS"] as? Int ?? 0
        earnedRuns = dictionary["ER"] as? Int ?? 0
        gamesStarted = dictionary["GS"] as? Int ?? 0
        gamesFinished = dictionary["GF"] as? Int ?? 0
        completeGames = dictionary["CG"] as? Int ?? 0
        shutouts = dictionary["SHO"] as? Int ?? 0
        wins = dictionary["W"] as? Int ?? 0
        losses = dictionary["L"] as? Int ?? 0
        saves = dictionary["SV"] as? Int ?? 0
        super.init(dictionary: dictionary)
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.maximumIntegerDigits = 1
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
            return Float(earnedRuns * 27) / Float(outs)
        }
    }
    
    var eraString: String {
        get {
            return numberFormatter.string(from: NSNumber(value: era)) ?? ""
        }
    }
}
