//
//  BattingStats.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class BattingStats {
    var numberFormatter = NumberFormatter()
    
    var playerID: Int!
    var yearID: Int!
    var levelID: Int!
    var teamID: Int!
    var games: Int!
    var atBats: Int
    var singles: Int
    var doubles: Int
    var triples: Int
    var homeRuns: Int
    var walksRegular: Int
    var walksIntentional: Int
    var hitByPitch: Int
    var strikeouts: Int!
    var sacrificeHits: Int!
    var sacrificeFlies: Int
    var stolenBases: Int!
    var caughtStealing: Int!
    var plateAppearances: Int!
    var runs: Int!
    var runsBattedIn: Int!
    
    init(dictionary: [String: Any]) {
        playerID = dictionary["PlayerID"] as? Int
        yearID = dictionary["YearID"] as? Int
        levelID = dictionary["LevelID"] as? Int
        teamID = dictionary["TeamID"] as? Int
        games = dictionary["G"] as? Int
        atBats = dictionary["AB"] as? Int ?? 0
        singles = dictionary["B1"] as? Int ?? 0
        doubles = dictionary["B2"] as? Int ?? 0
        triples = dictionary["B3"] as? Int ?? 0
        homeRuns = dictionary["HR"] as? Int ?? 0
        walksRegular = dictionary["UBB"] as? Int ?? 0
        walksIntentional = dictionary["IBB"] as? Int ?? 0
        hitByPitch = dictionary["HBP"] as? Int ?? 0
        strikeouts = dictionary["SO"] as? Int
        sacrificeHits = dictionary["SH"] as? Int
        sacrificeFlies = dictionary["SF"] as? Int ?? 0
        stolenBases = dictionary["SB"] as? Int
        caughtStealing = dictionary["CS"] as? Int
        plateAppearances = dictionary["PA"] as? Int
        runs = dictionary["R"] as? Int
        runsBattedIn = dictionary["RBI"] as? Int
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 3
        numberFormatter.minimumFractionDigits = 3
    }
    
    //MARK: - Calculated values
    
    var hits: Int {
        get {
            return singles + doubles + triples + homeRuns
        }
    }
    
    var walks: Int {
        get {
            return walksRegular + walksIntentional
        }
    }
    
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
