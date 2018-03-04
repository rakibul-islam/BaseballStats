//
//  BookmarksViewController.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/4/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class BookmarksViewController: UITableViewController {
    var players = [PlayerMO]()
    var selectedPlayer: PlayerMO?
    lazy var playerRetrievalUtility = PlayerRetrievalUtility()
    lazy var coreDataController = CoreDataController.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statsVC = segue.destination as? PlayerStatsViewController {
            statsVC.player = selectedPlayer
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        players = coreDataController.getBookmarkedPlayers()
        tableView.reloadData()
    }
    
    //MARK: - Table view datasource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "playerCell") else {
            return UITableViewCell()
        }
        let player = players[indexPath.row]
        tableViewCell.textLabel?.text = player.displayName
        tableViewCell.detailTextLabel?.text = player.positionName
        return tableViewCell
    }
    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlayer = players[indexPath.row]
        if let battingStats = selectedPlayer?.battingStats, battingStats.count > 0 {
            performSegue(withIdentifier: "showPlayerInfo", sender: nil)
        } else if let pitchingStats = selectedPlayer?.pitchingStats, pitchingStats.count > 0 {
            performSegue(withIdentifier: "showPlayerInfo", sender: nil)
        } else {
            getStatsForSelectedPlayer() //Should never get here, but just in case...
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Other methods
    func getStatsForSelectedPlayer() {
        CommonAlerts.sharedInstance.showLoadingAlertOn(viewController: self)
        playerRetrievalUtility.getStats(for: selectedPlayer, completionBlock: {
            DispatchQueue.main.async {
                CommonAlerts.sharedInstance.dismissLoadingAlert(completionBlock: {
                    self.performSegue(withIdentifier: "showPlayerInfo", sender: nil)
                })
            }
        }, failureBlock: { (error) in
            DispatchQueue.main.async {
                CommonAlerts.sharedInstance.dismissLoadingAlert(completionBlock: {
                    CommonAlerts.showErrorAlertOn(viewController: self, messageString: nil, error: error)
                })
            }
        })
    }
}
