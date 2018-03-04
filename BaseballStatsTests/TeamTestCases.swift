//
//  TeamTestCases.swift
//  BaseballStatsTests
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import XCTest
@testable import BaseballStats

class TeamTestCases: XCTestCase {
    let dictionary: [String : Any] = ["TeamID": Int16(1),
                                      "City": "New York",
                                      "Name": "Yankees",
                                      "Abbr": "NYA",
                                      "LeagueID": Int16(1),
                                      "FullName": "New York Yankees"]
    var coreDataController: CoreDataController!
    
    override func setUp() {
        super.setUp()
        coreDataController = CoreDataController.sharedInstance
        coreDataController.setupInMemoryManagedObjectContext()
    }
    
    func testTeamInit_withDictionary_shouldSetValues() {
        let team = coreDataController.createTeamEntity()
        team.setupTeamFrom(dictionary: dictionary)
        XCTAssertEqual(team.teamID, 1)
        XCTAssertEqual(team.city, "New York")
        XCTAssertEqual(team.name, "Yankees")
        XCTAssertEqual(team.abbreviation, "NYA")
        XCTAssertEqual(team.leagueID, 1)
        XCTAssertEqual(team.fullName, "New York Yankees")
    }
    
    func testTeamInit_withEmptyDictionary_shouldSetValues() {
        let team = coreDataController.createTeamEntity()
        XCTAssertEqual(team.teamID, 0)
        XCTAssertNil(team.city)
        XCTAssertNil(team.name)
        XCTAssertNil(team.abbreviation)
        XCTAssertEqual(team.leagueID, 0)
        XCTAssertNil(team.fullName)
    }
    
    func testLeague_withLeagueID0_shouldReturnUnknown() {
        let team = coreDataController.createTeamEntity() //team.leagueID is defaulted to 0
        XCTAssertEqual(team.league, "Unknown")
    }
    
    func testLeage_withLeagueID1_shouldReturnAmericanLeague() {
        let team = coreDataController.createTeamEntity()
        team.leagueID = 1
        XCTAssertEqual(team.league, "American League")
    }
    
    func testLeage_withLeagueID2_shouldReturnNationalLeague() {
        let team = coreDataController.createTeamEntity()
        team.leagueID = 2
        XCTAssertEqual(team.league, "National League")
    }
}
