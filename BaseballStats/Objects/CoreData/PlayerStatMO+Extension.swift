//
//  PlayerStatMO+Extension.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/4/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import Foundation

extension PlayerStatMO {
    func setupFrom(dictionary: [String: Any]) {
        playerID = dictionary["PlayerID"] as? Int32 ?? 0
        yearID = dictionary["YearID"] as? Int16 ?? 0
        levelID = dictionary["LevelID"] as? Int16 ?? 0
        teamID = dictionary["TeamID"] as? Int16 ?? 0
        games = dictionary["G"] as? Int16 ?? 0
        atBats = dictionary["AB"] as? Int16 ?? 0
        singles = dictionary["B1"] as? Int16 ?? 0
        doubles = dictionary["B2"] as? Int16 ?? 0
        triples = dictionary["B3"] as? Int16 ?? 0
        homeRuns = dictionary["HR"] as? Int16 ?? 0
        walksRegular = dictionary["UBB"] as? Int16 ?? 0
        walksIntentional = dictionary["IBB"] as? Int16 ?? 0
        hitByPitch = dictionary["HBP"] as? Int16 ?? 0
        strikeouts = dictionary["SO"] as? Int16 ?? 0
        sacrificeHits = dictionary["SH"] as? Int16 ?? 0
        sacrificeFlies = dictionary["SF"] as? Int16 ?? 0
        plateAppearances = dictionary["PA"] as? Int16 ?? 0
        runs = dictionary["R"] as? Int16 ?? 0
    }
    
    func getHits() -> Int16 {
        return singles + doubles + triples + homeRuns
    }
    
    func getWalks() -> Int16 {
        return walksRegular + walksIntentional
    }
}
