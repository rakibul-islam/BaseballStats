//
//  TeamMO+Extension.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/4/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import Foundation

extension TeamMO {
    func setupTeamFrom(dictionary: [String: Any]) {
        teamID = dictionary["TeamID"] as? Int16 ?? 0
        city = dictionary["City"] as? String
        name = dictionary["Name"] as? String
        abbreviation = dictionary["Abbr"] as? String
        leagueID = dictionary["LeagueID"] as? Int16 ?? 0
        fullName = dictionary["FullName"] as? String
    }
    
    //MARK: - ViewModel methods
    var league: String {
        get {
            guard leagueID > 0 else {
                return "Unknown"
            }
            return leagueID == 1 ? "American League" : "National League"
        }
    }
}
