//
//  PlayerSearchViewControllerTestCases.swift
//  BaseballStatsTests
//
//  Created by Rakibul Islam on 3/4/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import XCTest
@testable import BaseballStats

class PlayerSearchViewControllerTestCases: XCTestCase {
    var playerSearchVC: PlayerSearchViewController!
    var mockPlayerUtility = MockPlayerRetrievalUtility()
    var tableView = UITableView()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        playerSearchVC = storyboard.instantiateViewController(withIdentifier: "PlayerSearchViewController") as! PlayerSearchViewController
        playerSearchVC.loadView()
        playerSearchVC.playerRetrievalUtility = mockPlayerUtility
        playerSearchVC.tableView = tableView
    }
    
    func testSearchButtonClicked_withSearchString_shouldReturnResults() {
        let searchBar = UISearchBar()
        searchBar.text = "ABCDE"
        searchBar.becomeFirstResponder()
        mockPlayerUtility.serviceSuccessful = true
        mockPlayerUtility.foundResults = true
        
        playerSearchVC.searchBarSearchButtonClicked(searchBar)
        
        XCTAssertFalse(searchBar.isFirstResponder)
        XCTAssertEqual(playerSearchVC.players.count, 2)
    }
    
    func testSearchButtonClicked_withSearchString_serviceReturnedNoResults_shouldReturnResults() {
        let searchBar = UISearchBar()
        searchBar.text = "ABCDE"
        mockPlayerUtility.serviceSuccessful = true
        
        playerSearchVC.searchBarSearchButtonClicked(searchBar)
        
        XCTAssertEqual(playerSearchVC.players.count, 0)
    }
    
    func testSearchButtonClicked_withSearchString_serviceFailed_shouldReturnResults() {
        let searchBar = UISearchBar()
        searchBar.text = "ABCDE"
        
        playerSearchVC.searchBarSearchButtonClicked(searchBar)
        
        XCTAssertEqual(playerSearchVC.players.count, 0)
    }
    
    func testSearchButtonClicked_withSearchStringTooShort_shouldNotSearch() {
        let searchBar = UISearchBar()
        searchBar.text = "ABC"
        mockPlayerUtility.serviceSuccessful = true
        mockPlayerUtility.foundResults = true
        
        playerSearchVC.searchBarSearchButtonClicked(searchBar)
        
        XCTAssertEqual(playerSearchVC.players.count, 0)
    }
    
    func testNumberOfRows_withPlayersArray_shouldReturnCount() {
        playerSearchVC.players = mockPlayerUtility.getPlayers()
        XCTAssertEqual(playerSearchVC.tableView(tableView, numberOfRowsInSection: 0), 2)
    }
    
    func testNumberOfRows_withEmptyPlayersArray_shouldReturnZero() {
        XCTAssertEqual(playerSearchVC.tableView(tableView, numberOfRowsInSection: 0), 0)
    }
    
    class MockPlayerRetrievalUtility: PlayerRetrievalUtilityProtocol {
        var serviceSuccessful = false
        var foundResults = false
        
        func getPlayersWith(searchParameter: String, completionBlock: @escaping ([PlayerMO]) -> Void, failureBlock: @escaping (Error) -> Void) {
            if serviceSuccessful {
                if foundResults {
                    completionBlock(getPlayers())
                } else {
                    completionBlock([])
                }
            } else {
                let error = NSError(domain: "Error", code: 0, userInfo: nil)
                failureBlock(error)
            }
        }
        
        func getStats(for player: PlayerMO?, completionBlock: @escaping () -> Void, failureBlock: @escaping (Error) -> Void) {
            if serviceSuccessful {
                
            } else {
                let error = NSError(domain: "Error", code: 0, userInfo: nil)
                failureBlock(error)
            }
        }
        
        func loadImageFrom(urlString: String?, completionHandler: @escaping (UIImage?) -> Void) {
            if serviceSuccessful {
                completionHandler(UIImage(named: "first"))
            } else {
                completionHandler(nil)
            }
        }
        
        func getPlayers() -> [PlayerMO] {
            let coreDataController = CoreDataController.sharedInstance
            coreDataController.setupInMemoryManagedObjectContext()
            let player = coreDataController.createPlayerEntity()
            player.usesName = "John"
            player.lastName = "Player"
            player.position = 3
            let player2 = coreDataController.createPlayerEntity()
            player2.usesName = "Bob"
            player2.lastName = "Player"
            player2.position = 7
            return [player, player2]
        }
    }
}
