//
//  Team.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class Team {
    var teamID: Int
    var city: String?
    var name: String?
    var abbreviation: String?
    var leagueID: Int
    var fullName: String?
    
    init(dictionary: [String: Any]) {
        teamID = dictionary["TeamID"] as? Int ?? 0
        city = dictionary["City"] as? String
        name = dictionary["Name"] as? String
        abbreviation = dictionary["Abbr"] as? String
        leagueID = dictionary["LeagueID"] as? Int ?? 0
        fullName = dictionary["FullName"] as? String
    }
}
