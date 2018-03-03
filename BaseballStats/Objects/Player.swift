//
//  Player.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class Player {
    var battingStats: [BattingStats]?
    var pitchingStats: [PitchingStats]?
    var playerID: Int?
    var lastName: String!
    var firstName: String!
    var usesName: String!
    var middleName: String?
    var bats: Int!
    var throwsWith: Int!
    var teamID: Int?
    var birthDate: Date?
    var birthCity: String!
    var birthCountry: String!
    var birthState: String!
    var height: Int!
    var weight: Int?
    var position: Int!
    var number: Int?
    var headShotURL: String?
    var isPitcher: Bool
    var firstInitial: String!
    var lastInitial: String!
    var fullName: String!
    var formalName: String!
    
    init(dictionary: [String: Any]) {
        playerID = dictionary["PlayerID"] as? Int
        lastName = dictionary["LastName"] as? String
        firstName = dictionary["FirstName"] as? String
        usesName = dictionary["UsesName"] as? String
        middleName = dictionary["MiddleName"] as? String
        bats = dictionary["Bats"] as? Int
        throwsWith = dictionary["Throws"] as? Int
        teamID = dictionary["TeamID"] as? Int
        if let date = dictionary["BirthDate"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            birthDate = dateFormatter.date(from: date)
        }
        birthCity = dictionary["BirthCity"] as? String
        birthCountry = dictionary["BirthCountry"] as? String
        birthState = dictionary["BirthState"] as? String
        height = dictionary["Height"] as? Int ?? 0
        weight = dictionary["Weight"] as? Int
        position = dictionary["Position"] as? Int ?? 0
        number = dictionary["Number"] as? Int
        headShotURL = dictionary["HeadShotURL"] as? String
        isPitcher = dictionary["IsPitcher"] as? Bool ?? false
        firstInitial = dictionary["FirstInitial"] as? String
        lastInitial = dictionary["LastInitial"] as? String
        fullName = dictionary["FullName"] as? String
        formalName = dictionary["FormalName"] as? String
    }
    
    //MARK: - ViewModel methods
    var displayName: String {
        get {
            return usesName + " " + lastName
        }
    }
    var positionName: String {
        get {
            switch position {
            case 1:
                return "Pitcher"
            case 2:
                return "Catcher"
            case 3:
                return "First Base"
            case 4:
                return "Second Base"
            case 5:
                return "Third Base"
            case 6:
                return "Shortstop"
            case 7:
                return "Left Field"
            case 8:
                return "Center Field"
            case 9:
                return "Right Field"
            case 10:
                return "Designated Hitter"
            case 11:
                return "Starting Pitcher"
            case 12:
                return "Relief Pitcher"
            default:
                return "Unknown"
            }
        }
    }
    var teamAndNumber: String {
        get {
            let num = number ?? 0
            let team = teamID ?? 0 //TODO: get team name from teamID
            return "#\(num) - \(team)"
        }
    }
    var batsAndThrows: String {
        get {
            let batting = bats == 1 ? "R" : bats == 2 ? "L" : "S"
            let throwing = throwsWith == 1 ? "R" : "L"
            return "Bats: \(batting)  Throws: \(throwing)"
        }
    }
    var dateOfBirth: String {
        get {
            var dateString = "N/A"
            if let date = birthDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                dateString = dateFormatter.string(from: date)
            }
            return "DOB: \(dateString)"
        }
    }
    var heightWeight: String {
        get {
            let feet = height / 12
            let inches = height % 12
            return "\(feet)-\(inches), \(weight ?? 0) lbs."
        }
    }
}
