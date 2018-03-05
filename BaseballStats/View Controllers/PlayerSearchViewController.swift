//
//  FirstViewController.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class PlayerSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var players = [PlayerMO]()
    var selectedPlayer: PlayerMO?
    
    lazy var playerRetrievalUtility: PlayerRetrievalUtilityProtocol = PlayerRetrievalUtility()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statsVC = segue.destination as? PlayerStatsViewController {
            statsVC.player = selectedPlayer
        }
    }
    
    //MARK: - UISearchBar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text, searchText.count > 3 {
            CommonAlerts.sharedInstance.showLoadingAlertOn(viewController: self)
            playerRetrievalUtility.getPlayersWith(searchParameter: searchText, completionBlock: { (players) in
                self.players = players
                DispatchQueue.main.async {
                    CommonAlerts.sharedInstance.dismissLoadingAlert(completionBlock: {
                        if players.count == 0 {
                            CommonAlerts.showErrorAlertOn(viewController: self, messageString: "No players found!", error: nil)
                        }
                        self.tableView.reloadData()
                    })
                }
            }, failureBlock: { (error) in
                DispatchQueue.main.async {
                    CommonAlerts.sharedInstance.dismissLoadingAlert(completionBlock: {
                        CommonAlerts.showErrorAlertOn(viewController: self, messageString: nil, error: error)
                    })
                }
            })
        } else {
            CommonAlerts.showErrorAlertOn(viewController: self, messageString: "Please enter a search term of at least 4 characters.", error: nil)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: - UITableView datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let playerCell = tableView.dequeueReusableCell(withIdentifier: "playerCell") else {
            return UITableViewCell()
        }
        let player = players[indexPath.row]
        playerCell.textLabel?.text = player.displayName
        playerCell.detailTextLabel?.text = player.positionName
        return playerCell
    }
    
    //MARK: - UITableView delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlayer = players[indexPath.row]
        if let battingStats = selectedPlayer?.battingStats, battingStats.count > 0 {
            performSegue(withIdentifier: "showPlayerInfo", sender: nil)
        } else if let pitchingStats = selectedPlayer?.pitchingStats, pitchingStats.count > 0 {
            performSegue(withIdentifier: "showPlayerInfo", sender: nil)
        } else {
            getStatsForSelectedPlayer()
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
