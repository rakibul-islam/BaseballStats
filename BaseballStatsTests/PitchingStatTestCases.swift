//
//  PitchingStatTestCases.swift
//  BaseballStatsTests
//
//  Created by Rakibul Islam on 3/4/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import XCTest
@testable import BaseballStats

class PitchingStatTestCases: XCTestCase {
    let dictionary: [String: Any] = ["PlayerID": Int32(1),
                                     "YearID": Int16(2001),
                                     "LevelID": Int16(1),
                                     "TeamID": Int16(1),
                                     "G": Int16(150),
                                     "AB": Int16(500),
                                     "B1": Int16(75),
                                     "B2": Int16(30),
                                     "B3": Int16(3),
                                     "HR": Int16(22),
                                     "UBB": Int16(50),
                                     "IBB": Int16(3),
                                     "HBP": Int16(2),
                                     "SO": Int16(100),
                                     "SH": Int16(10),
                                     "SF": Int16(10),
                                     "PA": Int16(575),
                                     "R": Int16(87),
                                     "OUTS": Int16(601),
                                     "ER": Int16(85),
                                     "GS": Int16(33),
                                     "GF": Int16(1),
                                     "CG": Int16(2),
                                     "SHO": Int16(1),
                                     "W": Int16(16),
                                     "L": Int16(11),
                                     "SV": Int16(1)]
    var coreDataController: CoreDataController!
    
    override func setUp() {
        super.setUp()
        coreDataController = CoreDataController.sharedInstance
        coreDataController.setupInMemoryManagedObjectContext()
    }
    
    func testPitchingStatInit_withDictionary_shouldSetValues() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        pitchingStat.setupPitchingFrom(dictionary: dictionary)
        XCTAssertEqual(pitchingStat.playerID, 1)
        XCTAssertEqual(pitchingStat.yearID, 2001)
        XCTAssertEqual(pitchingStat.levelID, 1)
        XCTAssertEqual(pitchingStat.teamID, 1)
        XCTAssertEqual(pitchingStat.games, 150)
        XCTAssertEqual(pitchingStat.atBats, 500)
        XCTAssertEqual(pitchingStat.singles, 75)
        XCTAssertEqual(pitchingStat.doubles, 30)
        XCTAssertEqual(pitchingStat.triples, 3)
        XCTAssertEqual(pitchingStat.homeRuns, 22)
        XCTAssertEqual(pitchingStat.walksRegular, 50)
        XCTAssertEqual(pitchingStat.walksIntentional, 3)
        XCTAssertEqual(pitchingStat.hitByPitch, 2)
        XCTAssertEqual(pitchingStat.strikeouts, 100)
        XCTAssertEqual(pitchingStat.sacrificeHits, 10)
        XCTAssertEqual(pitchingStat.sacrificeFlies, 10)
        XCTAssertEqual(pitchingStat.plateAppearances, 575)
        XCTAssertEqual(pitchingStat.runs, 87)
        XCTAssertEqual(pitchingStat.outs, 601)
        XCTAssertEqual(pitchingStat.earnedRuns, 85)
        XCTAssertEqual(pitchingStat.gamesStarted, 33)
        XCTAssertEqual(pitchingStat.gamesFinished, 1)
        XCTAssertEqual(pitchingStat.completeGames, 2)
        XCTAssertEqual(pitchingStat.shutouts, 1)
        XCTAssertEqual(pitchingStat.wins, 16)
        XCTAssertEqual(pitchingStat.losses, 11)
        XCTAssertEqual(pitchingStat.saves, 1)
    }
    
    func testPitchingStatInit_withEmptyDictionary_shouldSetValues() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        XCTAssertEqual(pitchingStat.playerID, 0)
        XCTAssertEqual(pitchingStat.yearID, 0)
        XCTAssertEqual(pitchingStat.levelID, 0)
        XCTAssertEqual(pitchingStat.teamID, 0)
        XCTAssertEqual(pitchingStat.games, 0)
        XCTAssertEqual(pitchingStat.atBats, 0)
        XCTAssertEqual(pitchingStat.singles, 0)
        XCTAssertEqual(pitchingStat.doubles, 0)
        XCTAssertEqual(pitchingStat.triples, 0)
        XCTAssertEqual(pitchingStat.homeRuns, 0)
        XCTAssertEqual(pitchingStat.walksRegular, 0)
        XCTAssertEqual(pitchingStat.walksIntentional, 0)
        XCTAssertEqual(pitchingStat.hitByPitch, 0)
        XCTAssertEqual(pitchingStat.strikeouts, 0)
        XCTAssertEqual(pitchingStat.sacrificeHits, 0)
        XCTAssertEqual(pitchingStat.sacrificeFlies, 0)
        XCTAssertEqual(pitchingStat.plateAppearances, 0)
        XCTAssertEqual(pitchingStat.runs, 0)
        XCTAssertEqual(pitchingStat.outs, 0)
        XCTAssertEqual(pitchingStat.earnedRuns, 0)
        XCTAssertEqual(pitchingStat.gamesStarted, 0)
        XCTAssertEqual(pitchingStat.gamesFinished, 0)
        XCTAssertEqual(pitchingStat.completeGames, 0)
        XCTAssertEqual(pitchingStat.shutouts, 0)
        XCTAssertEqual(pitchingStat.wins, 0)
        XCTAssertEqual(pitchingStat.losses, 0)
        XCTAssertEqual(pitchingStat.saves, 0)
    }
    
    func testHits_withValues_shouldReturnTotal() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        pitchingStat.setupPitchingFrom(dictionary: dictionary)
        XCTAssertEqual(pitchingStat.hits, 130)
    }
    
    func testHits_withoutValues_shouldReturnZero() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        XCTAssertEqual(pitchingStat.hits, 0)
    }
    
    func testWalks_withValues_shouldReturnTotal() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        pitchingStat.setupPitchingFrom(dictionary: dictionary)
        XCTAssertEqual(pitchingStat.walks, 53)
    }
    
    func testWalks_withoutValues_shouldReturnZero() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        XCTAssertEqual(pitchingStat.walks, 0)
    }
    
    func testInningsPitched_withValues_shouldReturnInningsPitched() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        pitchingStat.setupPitchingFrom(dictionary: dictionary)
        XCTAssertEqual(pitchingStat.inningsPitched, 200.1)
    }
    
    func testInningsPitched_withoutValues_shouldReturnZero() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        XCTAssertEqual(pitchingStat.inningsPitched, 0)
    }
    
    func testInningsPitched_withOutsMultipleOfThree_shouldReturnInningsPitched() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        pitchingStat.outs = 600
        XCTAssertEqual(pitchingStat.inningsPitched, 200)
    }
    
    func testInningsPitched_withOutsNotMultipleOfThree_shouldReturnInningsPitched() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        pitchingStat.outs = 602
        XCTAssertEqual(pitchingStat.inningsPitched, 200.2)
    }
    
    func testERA_withValues_shouldReturnERA() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        pitchingStat.setupPitchingFrom(dictionary: dictionary)
        XCTAssertEqual(pitchingStat.era, 85.0 * 27.0 / 601.0)
    }
    
    func testERA_withoutValues_shouldReturnZero() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        XCTAssertEqual(pitchingStat.era, 0)
    }
    
    func testERA_withOutsZero_shouldReturnZero() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        pitchingStat.earnedRuns = 85
        XCTAssertEqual(pitchingStat.era, 0)
    }
    
    func testERA_withEarnedRunsZero_shouldReturnZero() {
        let pitchingStat = coreDataController.createPitchingStatEntity()
        pitchingStat.outs = 601
        XCTAssertEqual(pitchingStat.era, 0)
    }
}
