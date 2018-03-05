//
//  BattingStatTestCases.swift
//  BaseballStatsTests
//
//  Created by Rakibul Islam on 3/4/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import XCTest
@testable import BaseballStats

class BattingStatTestCases: XCTestCase {
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
                                     "SB": Int16(10),
                                     "CS": Int16(7),
                                     "RBI": Int16(82)]
    var coreDataController: CoreDataController!
    
    override func setUp() {
        super.setUp()
        coreDataController = CoreDataController.sharedInstance
        coreDataController.setupInMemoryManagedObjectContext()
    }
    
    func testBattingStatInit_withDictionary_shouldSetValues() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.setupBattingFrom(dictionary: dictionary)
        XCTAssertEqual(battingStat.playerID, 1)
        XCTAssertEqual(battingStat.yearID, 2001)
        XCTAssertEqual(battingStat.levelID, 1)
        XCTAssertEqual(battingStat.teamID, 1)
        XCTAssertEqual(battingStat.games, 150)
        XCTAssertEqual(battingStat.atBats, 500)
        XCTAssertEqual(battingStat.singles, 75)
        XCTAssertEqual(battingStat.doubles, 30)
        XCTAssertEqual(battingStat.triples, 3)
        XCTAssertEqual(battingStat.homeRuns, 22)
        XCTAssertEqual(battingStat.walksRegular, 50)
        XCTAssertEqual(battingStat.walksIntentional, 3)
        XCTAssertEqual(battingStat.hitByPitch, 2)
        XCTAssertEqual(battingStat.strikeouts, 100)
        XCTAssertEqual(battingStat.sacrificeHits, 10)
        XCTAssertEqual(battingStat.sacrificeFlies, 10)
        XCTAssertEqual(battingStat.plateAppearances, 575)
        XCTAssertEqual(battingStat.runs, 87)
        XCTAssertEqual(battingStat.stolenBases, 10)
        XCTAssertEqual(battingStat.caughtStealing, 7)
        XCTAssertEqual(battingStat.runsBattedIn, 82)
    }
    
    func testBattingStatInit_withEmptyDictionary_shouldSetValues() {
        let battingStat = coreDataController.createBattingStatEntity()
        XCTAssertEqual(battingStat.playerID, 0)
        XCTAssertEqual(battingStat.yearID, 0)
        XCTAssertEqual(battingStat.levelID, 0)
        XCTAssertEqual(battingStat.teamID, 0)
        XCTAssertEqual(battingStat.games, 0)
        XCTAssertEqual(battingStat.atBats, 0)
        XCTAssertEqual(battingStat.singles, 0)
        XCTAssertEqual(battingStat.doubles, 0)
        XCTAssertEqual(battingStat.triples, 0)
        XCTAssertEqual(battingStat.homeRuns, 0)
        XCTAssertEqual(battingStat.walksRegular, 0)
        XCTAssertEqual(battingStat.walksIntentional, 0)
        XCTAssertEqual(battingStat.hitByPitch, 0)
        XCTAssertEqual(battingStat.strikeouts, 0)
        XCTAssertEqual(battingStat.sacrificeHits, 0)
        XCTAssertEqual(battingStat.sacrificeFlies, 0)
        XCTAssertEqual(battingStat.plateAppearances, 0)
        XCTAssertEqual(battingStat.runs, 0)
        XCTAssertEqual(battingStat.stolenBases, 0)
        XCTAssertEqual(battingStat.caughtStealing, 0)
        XCTAssertEqual(battingStat.runsBattedIn, 0)
    }
    
    func testHits_withValues_shouldReturnTotal() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.setupBattingFrom(dictionary: dictionary)
        XCTAssertEqual(battingStat.hits, 130)
    }
    
    func testHits_withoutValues_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        XCTAssertEqual(battingStat.hits, 0)
    }
    
    func testWalks_withValues_shouldReturnTotal() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.setupBattingFrom(dictionary: dictionary)
        XCTAssertEqual(battingStat.walks, 53)
    }
    
    func testWalks_withoutValues_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        XCTAssertEqual(battingStat.walks, 0)
    }
    
    func testAverage_withValues_shouldReturnAverage() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.setupBattingFrom(dictionary: dictionary)
        XCTAssertEqual(battingStat.average, Float(130.0 / 500.0))
    }
    
    func testAverage_withoutValues_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        XCTAssertEqual(battingStat.average, 0)
    }
    
    func testAverage_withAtBatsZero_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.singles = 130
        XCTAssertEqual(battingStat.average, 0)
    }
    
    func testAverage_withHitsZero_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.atBats = 500
        XCTAssertEqual(battingStat.average, 0)
    }
    
    func testOnBasePercentage_withValues_shouldReturnOBP() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.setupBattingFrom(dictionary: dictionary)
        let num: Float = 75.0 + 30.0 + 3.0 + 22.0 + 50.0 + 3.0 + 2.0
        let dem: Float = 500.0 + 50.0 + 3.0 + 2.0 + 10.0
        XCTAssertEqual(battingStat.onBasePercentage, num / dem)
    }
    
    func testOnBasePercentage_withoutValues_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        XCTAssertEqual(battingStat.onBasePercentage, 0)
    }
    
    func testOnBasePercentage_withCalculatedPAZero_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.singles = 100
        XCTAssertEqual(battingStat.onBasePercentage, 0)
    }
    
    func testOnBasePercentage_withOnBaseZero_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.atBats = 500
        XCTAssertEqual(battingStat.onBasePercentage, 0)
    }
    
    func testSlugging_withValues_shouldReturnSlugging() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.setupBattingFrom(dictionary: dictionary)
        let weightedDoubles: Float = 2 * 30.0
        let weightedTriples: Float = 3 * 3.0
        let weightedHRs: Float = 4 * 22.0
        let num: Float = 75.0 + weightedDoubles + weightedTriples + weightedHRs
        XCTAssertEqual(battingStat.slugging, num / Float(battingStat.atBats))
    }
    
    func testSlugging_withoutValues_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        XCTAssertEqual(battingStat.slugging, 0)
    }

    func testSlugging_withAtBatsZero_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.singles = 100
        XCTAssertEqual(battingStat.slugging, 0)
    }
    
    func testSlugging_withHitsZero_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.atBats = 100
        XCTAssertEqual(battingStat.slugging, 0)
    }
    
    func testOPS_withValues_shouldReturnOPS() {
        let battingStat = coreDataController.createBattingStatEntity()
        battingStat.setupBattingFrom(dictionary: dictionary)
        let num: Float = 75.0 + 30.0 + 3.0 + 22.0 + 50.0 + 3.0 + 2.0
        let dem: Float = 500.0 + 50.0 + 3.0 + 2.0 + 10.0
        let obp = num / dem
        let weightedDoubles: Float = 2 * 30.0
        let weightedTriples: Float = 3 * 3.0
        let weightedHRs: Float = 4 * 22.0
        let num2: Float = 75.0 + weightedDoubles + weightedTriples + weightedHRs
        let slugging = num2 / Float(battingStat.atBats)
        XCTAssertEqual(battingStat.ops, obp + slugging)
    }
    
    func testOPS_withoutValues_shouldReturnZero() {
        let battingStat = coreDataController.createBattingStatEntity()
        XCTAssertEqual(battingStat.ops, 0)
    }
}
