//
//  BattingStats.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class BattingStats {
    var playerID: Int!
    var yearID: Int!
    var levelID: Int!
    var teamID: Int!
    var games: Int!
    var atBats: Int!
    var singles: Int!
    var doubles: Int!
    var triples: Int!
    var homeRuns: Int!
    var walksRegular: Int!
    var walksIntentional: Int!
    var hitByPitch: Int!
    var strikeouts: Int!
    var sacrificeHits: Int!
    var sacrificeFlies: Int!
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
        atBats = dictionary["AB"] as? Int
        singles = dictionary["B1"] as? Int
        doubles = dictionary["B2"] as? Int
        triples = dictionary["B3"] as? Int
        homeRuns = dictionary["HR"] as? Int
        walksRegular = dictionary["UBB"] as? Int
        walksIntentional = dictionary["IBB"] as? Int
        hitByPitch = dictionary["HBP"] as? Int
        strikeouts = dictionary["SO"] as? Int
        sacrificeHits = dictionary["SH"] as? Int
        sacrificeFlies = dictionary["SF"] as? Int
        stolenBases = dictionary["SB"] as? Int
        caughtStealing = dictionary["CS"] as? Int
        plateAppearances = dictionary["PA"] as? Int
        runs = dictionary["R"] as? Int
        runsBattedIn = dictionary["RBI"] as? Int
    }
}
