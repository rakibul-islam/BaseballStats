//
//  Player.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class Player {
    var playerID: Int!
    var lastName: String!
    var firstName: String!
    var usesName: String!
    var middleName: String?
    var bats: Int!
    var throwsWith: Int!
    var teamID: Int!
    var birthDate: Date!
    var birthCity: String!
    var birthCountry: String!
    var birthState: String!
    var height: Int!
    var weight: Int!
    var position: Int!
    var number: Int?
    var headShotURL: String?
    var isPitcher: Bool!
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
        birthDate = dictionary["BirthDate"] as? Date //TODO: fix
        birthCity = dictionary["BirthCity"] as? String
        birthCountry = dictionary["BirthCountry"] as? String
        birthState = dictionary["BirthState"] as? String
        height = dictionary["Height"] as? Int ?? 0
        weight = dictionary["Weight"] as? Int ?? 0
        position = dictionary["Position"] as? Int ?? 0
        number = dictionary["Number"] as? Int
        headShotURL = dictionary["HeadShotURL"] as? String
        isPitcher = dictionary["IsPitcher"] as? Bool ?? false
        firstInitial = dictionary["FirstInitial"] as? String
        lastInitial = dictionary["LastInitial"] as? String
        fullName = dictionary["FullName"] as? String
        formalName = dictionary["FormalName"] as? String
    }
}