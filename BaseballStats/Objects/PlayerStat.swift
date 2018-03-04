//
//  PlayerStat.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/2/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class PlayerStat {
    var playerID: Int!
    var yearID: Int
    var levelID: Int!
    var teamID: Int?
    var team: Team?
    var games: Int
    var atBats: Int
    var singles: Int
    var doubles: Int
    var triples: Int
    var homeRuns: Int
    var walksRegular: Int
    var walksIntentional: Int
    var hitByPitch: Int
    var strikeouts: Int
    var sacrificeHits: Int!
    var sacrificeFlies: Int
    var plateAppearances: Int!
    var runs: Int!
    
    init(dictionary: [String: Any]) {
        playerID = dictionary["PlayerID"] as? Int
        yearID = dictionary["YearID"] as? Int ?? 0
        levelID = dictionary["LevelID"] as? Int
        teamID = dictionary["TeamID"] as? Int
        team = TeamRetrievalUtility.sharedInstance.getTeamForId(teamID: teamID)
        games = dictionary["G"] as? Int ?? 0
        atBats = dictionary["AB"] as? Int ?? 0
        singles = dictionary["B1"] as? Int ?? 0
        doubles = dictionary["B2"] as? Int ?? 0
        triples = dictionary["B3"] as? Int ?? 0
        homeRuns = dictionary["HR"] as? Int ?? 0
        walksRegular = dictionary["UBB"] as? Int ?? 0
        walksIntentional = dictionary["IBB"] as? Int ?? 0
        hitByPitch = dictionary["HBP"] as? Int ?? 0
        strikeouts = dictionary["SO"] as? Int ?? 0
        sacrificeHits = dictionary["SH"] as? Int
        sacrificeFlies = dictionary["SF"] as? Int ?? 0
        plateAppearances = dictionary["PA"] as? Int
        runs = dictionary["R"] as? Int
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
    
    //MARK: - ViewModel methods
    var displayValues: [String?] {
        get {
            return [String](repeating: "", count: 10)
        }
    }
}
