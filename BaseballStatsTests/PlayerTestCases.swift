//
//  PlayerTestCases.swift
//  BaseballStatsTests
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import XCTest
@testable import BaseballStats

class PlayerTestCases: XCTestCase {
    let dictionary: [String: Any] = ["PlayerID": 1,
                                     "LastName": "Player",
                                     "FirstName": "Johnathan",
                                     "UsesName": "John",
                                     "MiddleName": "Lawrence",
                                     "Bats": 1,
                                     "Throws": 1,
                                     "TeamID": 1,
                                     "BirthDate": "1990-01-01T00:00:00",
                                     "BirthCity": "New York",
                                     "BirthCountry": "USA",
                                     "BirthState": "NY",
                                     "Height": 74,
                                     "Weight": 220,
                                     "Position": 7,
                                     "Number": 5,
                                     "HeadShotURL": "www.headshot.com",
                                     "IsPitcher": false,
                                     "FirstInitial": "J",
                                     "LastInitial": "P",
                                     "FullName": "John Player",
                                     "FormalName": "Player, Johnathan Lawrence"]
    
    func testPlayerInit_withDictionary_shouldSetValues() {
        let player = Player(dictionary: dictionary)
        XCTAssertEqual(player.playerID, 1)
        XCTAssertEqual(player.lastName, "Player")
        XCTAssertEqual(player.firstName, "Johnathan")
        XCTAssertEqual(player.usesName, "John")
        XCTAssertEqual(player.middleName, "Lawrence")
        XCTAssertEqual(player.bats, 1)
        XCTAssertEqual(player.throwsWith, 1)
        XCTAssertEqual(player.teamID, 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        XCTAssertEqual(player.birthDate, dateFormatter.date(from: "1990-01-01T00:00:00"))
        XCTAssertEqual(player.birthCity, "New York")
        XCTAssertEqual(player.birthCountry, "USA")
        XCTAssertEqual(player.birthState, "NY")
        XCTAssertEqual(player.height, 74)
        XCTAssertEqual(player.weight, 220)
        XCTAssertEqual(player.position, 7)
        XCTAssertEqual(player.number, 5)
        XCTAssertEqual(player.headShotURL, "www.headshot.com")
        XCTAssertFalse(player.isPitcher)
        XCTAssertEqual(player.firstInitial, "J")
        XCTAssertEqual(player.lastInitial, "P")
        XCTAssertEqual(player.fullName, "John Player")
        XCTAssertEqual(player.formalName, "Player, Johnathan Lawrence")
    }
    
    func testPlayerInit_withEmptyDictionary_shouldSetValues() {
        let player = Player(dictionary: [:])
        XCTAssertEqual(player.playerID, 0)
        XCTAssertNil(player.lastName)
        XCTAssertNil(player.firstName)
        XCTAssertNil(player.usesName)
        XCTAssertNil(player.middleName)
        XCTAssertEqual(player.bats, 0)
        XCTAssertEqual(player.throwsWith, 0)
        XCTAssertEqual(player.teamID, 0)
        XCTAssertNil(player.birthDate)
        XCTAssertNil(player.birthCity)
        XCTAssertNil(player.birthCountry)
        XCTAssertNil(player.birthState)
        XCTAssertEqual(player.height, 0)
        XCTAssertEqual(player.weight, 0)
        XCTAssertEqual(player.position, 0)
        XCTAssertEqual(player.number, -1)
        XCTAssertNil(player.headShotURL)
        XCTAssertFalse(player.isPitcher)
        XCTAssertNil(player.firstInitial)
        XCTAssertNil(player.lastInitial)
        XCTAssertNil(player.fullName)
        XCTAssertNil(player.formalName)
    }
    
    func testPlayerInit_withIsPitcherTrue_shouldSetValues() {
        let player = Player(dictionary: ["IsPitcher" : true])
        XCTAssertTrue(player.isPitcher)
    }
    
    func testPlayerInit_withMalformedBirthDate_shouldSetValues() {
        let dictionary = ["BirthDate": "01/01/1990"]
        let player = Player(dictionary: dictionary)
        XCTAssertNil(player.birthDate)
    }
    
    func testDisplayName_withUsesNameAndLastName_shouldReturnString() {
        let player = Player(dictionary: dictionary)
        XCTAssertEqual(player.displayName, "John Player")
    }
    
    func testDisplayName_withoutUsesNameOrLastName_shouldReturnNil() {
        let player = Player(dictionary: [:])
        XCTAssertNil(player.displayName)
    }
    
    func testDisplayName_withoutUsesName_shouldReturnNil() {
        let player = Player(dictionary: [:])
        player.lastName = "Player"
        XCTAssertNil(player.displayName)
    }
    
    func testDisplayName_withoutLastName_shouldReturnNil() {
        let player = Player(dictionary: [:])
        player.usesName = "John"
        XCTAssertNil(player.displayName)
    }
    
    func testPositionName_withAllPositions_shouldReturnString() {
        let positions = ["Unknown", "Pitcher", "Catcher", "First Base", "Second Base", "Third Base", "Shortstop", "Left Field", "Center Field", "Right Field", "Designated Hitter", "Starting Pitcher", "Relief Pitcher", "Unknown"]
        for index in 0..<positions.count {
            let player = Player(dictionary: ["Position": index])
            XCTAssertEqual(player.positionName, positions[index], "Position is wrong for index: \(index)")
        }
    }
    
    func testTeamAndNumber_withTeamAndNumber_shouldReturnString() {
        let player = Player(dictionary: dictionary)
        let team = Team(dictionary: ["FullName": "New York Yankees"])
        player.team = team
        XCTAssertEqual(player.teamAndNumber, "#5 - New York Yankees")
    }
    
    func testTeamAndNumber_withNumberLessThan0_shouldReturnNil() {
        let player = Player(dictionary: [:])
        let team = Team(dictionary: ["FullName": "New York Yankees"])
        player.team = team
        XCTAssertNil(player.teamAndNumber)
    }
    
    func testTeamAndNumber_withoutTeam_shouldReturnNil() {
        let player = Player(dictionary: dictionary)
        XCTAssertNil(player.teamAndNumber)
    }
    
    func testTeamAndNumber_withTeamWithoutFullName_shouldReturnNil() {
        let player = Player(dictionary: dictionary)
        let team = Team(dictionary: [:])
        player.team = team
        XCTAssertNil(player.teamAndNumber)
    }
    
    func testBatsAndThrows_withHitter_shouldReturnString() {
        let bats = ["U", "R", "L", "S"]
        let throwsWith = ["U", "R", "L"]
        let player = Player(dictionary: [:])
        for indexB in 0..<bats.count {
            player.bats = indexB
            for indexT in 0..<throwsWith.count {
                player.throwsWith = indexT
                if indexB == 0 || indexT == 0 {
                    XCTAssertNil(player.batsAndThrows)
                } else {
                    XCTAssertEqual(player.batsAndThrows, "Bats: \(bats[indexB])  Throws: \(throwsWith[indexT])")
                }
            }
        }
    }
    
    func testBatsAndThrows_withPitcher_shouldReturnString() {
        let bats = ["U", "R", "L", "S"]
        let throwsWith = ["U", "R", "L"]
        let player = Player(dictionary: [:])
        player.isPitcher = true
        for indexB in 0..<bats.count {
            player.bats = indexB
            for indexT in 0..<throwsWith.count {
                player.throwsWith = indexT
                if indexB == 0 || indexT == 0 {
                    XCTAssertNil(player.batsAndThrows)
                } else {
                    XCTAssertEqual(player.batsAndThrows, "Throws: \(throwsWith[indexT])  Bats: \(bats[indexB])")
                }
            }
        }
    }
    
    func testDateOfBirth_withBirthDate_shouldReturnString() {
        let player = Player(dictionary: dictionary)
        XCTAssertEqual(player.dateOfBirth, "DOB: 01/01/1990")
    }
    
    func testDateOfBirth_withoutBirthDate_shouldReturnString() {
        let player = Player(dictionary: [:])
        XCTAssertEqual(player.dateOfBirth, "DOB: N/A")
    }
    
    func testHeightWeight_withHeightWeightSet_shouldReturnString() {
        let player = Player(dictionary: dictionary)
        XCTAssertEqual(player.heightWeight, "6-2, 220 lbs.")
    }
    
    func testHeightWeight_withHeight0_shouldReturnString() {
        let player = Player(dictionary: dictionary)
        player.height = 0
        XCTAssertEqual(player.heightWeight, "0-0, 220 lbs.")
    }
    
    func testHeightWeight_withHeightLessThan12_shouldReturnString() {
        let player = Player(dictionary: dictionary)
        player.height = 10
        XCTAssertEqual(player.heightWeight, "0-10, 220 lbs.")
    }
    
    func testHeightWeight_withWeight0_shouldReturnString() {
        let player = Player(dictionary: dictionary)
        player.weight = 0
        XCTAssertEqual(player.heightWeight, "6-2, 0 lbs.")
    }
    
    func testHeightWeight_withHeightAndWeight0_shouldReturnString() {
        let player = Player(dictionary: dictionary)
        player.height = 0
        player.weight = 0
        XCTAssertEqual(player.heightWeight, "0-0, 0 lbs.")
    }
}
