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
    
    var players = [Player]()
    var selectedPlayer: Player?
    
    lazy var playerRetrievalUtility = PlayerRetrievalUtility()

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
        if let searchText = searchBar.text {
            resignFirstResponder()
            let loadingController = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
            loadingController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                URLSession.shared.invalidateAndCancel()
            }))
            present(loadingController, animated: true, completion: nil)
            playerRetrievalUtility.getPlayersWith(searchParameter: searchText, completionBlock: { (players) in
                self.players = players
                DispatchQueue.main.async {
                    loadingController.dismiss(animated: true, completion: {
                        if players.count == 0 {
                            self.showErrorAlert(error: nil)
                        }
                        self.tableView.reloadData()
                    })
                }
            }, failureBlock: { (error) in
                DispatchQueue.main.async {
                    loadingController.dismiss(animated: true, completion: {
                        self.showErrorAlert(error: nil)
                    })
                }
            })
        }
    }
    
    func showErrorAlert(error: Error?) {
        var message = "No players found!"
        if let theError = error {
            message = theError.localizedDescription
        }
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UITableView datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playerCell = tableView.dequeueReusableCell(withIdentifier: "playerCell")
        let player = players[indexPath.row]
        playerCell?.textLabel?.text = player.displayName
        playerCell?.detailTextLabel?.text = player.positionName
        return playerCell!
    }
    
    //MARK: - UITableView delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlayer = players[indexPath.row]
        if let _ = selectedPlayer?.battingStats {
            performSegue(withIdentifier: "showPlayerInfo", sender: nil)
        } else if let _ = selectedPlayer?.pitchingStats {
            performSegue(withIdentifier: "showPlayerInfo", sender: nil)
        } else {
            getStatsForSelectedPlayer()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Other methods
    func getStatsForSelectedPlayer() {
        let loadingController = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
        loadingController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            URLSession.shared.invalidateAndCancel()
        }))
        present(loadingController, animated: true, completion: nil)
        if let playerID = selectedPlayer?.playerID {
            playerRetrievalUtility.getStats(for: playerID, completionBlock: { battingStats,pitchingStats  in
                self.selectedPlayer?.battingStats = battingStats
                self.selectedPlayer?.pitchingStats = pitchingStats
                DispatchQueue.main.async {
                    loadingController.dismiss(animated: true, completion: {
                        self.performSegue(withIdentifier: "showPlayerInfo", sender: nil)
                    })
                }
            }, failureBlock: { (error) in
                DispatchQueue.main.async {
                    loadingController.dismiss(animated: true, completion: {
                        self.showErrorAlert(error: nil)
                    })
                }
            })
        }
    }
}
