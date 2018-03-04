//
//  PlayerMO+Extension.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/4/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import Foundation

extension PlayerMO {
    func setupFrom(dictionary: [String: Any]) {
        playerID = dictionary["PlayerID"] as? Int16 ?? 0
        lastName = dictionary["LastName"] as? String
        firstName = dictionary["FirstName"] as? String
        usesName = dictionary["UsesName"] as? String
        middleName = dictionary["MiddleName"] as? String
        bats = dictionary["Bats"] as? Int16 ?? 0
        throwsWith = dictionary["Throws"] as? Int16 ?? 0
        teamID = dictionary["TeamID"] as? Int16 ?? 0
        if let date = dictionary["BirthDate"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            birthDate = dateFormatter.date(from: date)
        }
        birthCity = dictionary["BirthCity"] as? String
        birthCountry = dictionary["BirthCountry"] as? String
        birthState = dictionary["BirthState"] as? String
        height = dictionary["Height"] as? Int16 ?? 0
        weight = dictionary["Weight"] as? Int16 ?? 0
        position = dictionary["Position"] as? Int16 ?? 0
        number = dictionary["Number"] as? Int16 ?? -1
        headShotURL = dictionary["HeadShotURL"] as? String
        isPitcher = dictionary["IsPitcher"] as? Bool ?? false
        firstInitial = dictionary["FirstInitial"] as? String
        lastInitial = dictionary["LastInitial"] as? String
        fullName = dictionary["FullName"] as? String
        formalName = dictionary["FormalName"] as? String
    }
    
    //MARK: - ViewModel methods
    var displayName: String? {
        get {
            guard let displayFirst = usesName, let displayLast = lastName else {
                return nil
            }
            return displayFirst + " " + displayLast
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
    var teamAndNumber: String? {
        get {
            guard number >= 0, let teamName = team?.fullName else {
                return nil
            }
            return "#\(number) - \(teamName)"
        }
    }
    var batsAndThrows: String? {
        get {
            guard bats > 0, throwsWith > 0 else {
                return nil
            }
            let batting = bats == 1 ? "R" : bats == 2 ? "L" : "S"
            let throwing = throwsWith == 1 ? "R" : "L"
            return isPitcher ? "Throws: \(throwing)  Bats: \(batting)" : "Bats: \(batting)  Throws: \(throwing)"
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
            return "\(feet)-\(inches), \(weight) lbs."
        }
    }
}
