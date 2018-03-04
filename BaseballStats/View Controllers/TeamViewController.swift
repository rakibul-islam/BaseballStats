//
//  TeamViewController.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var team: Team?
    var selectedPlayer: Player?
    lazy var playerRetrievalUtility = PlayerRetrievalUtility()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = team?.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statsVC = segue.destination as? PlayerStatsViewController {
            statsVC.player = selectedPlayer
            let backButtonItem = UIBarButtonItem()
            backButtonItem.title = "Roster"
            navigationItem.backBarButtonItem = backButtonItem
        }
    }
    
    //MARK: - UITableView datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team?.roster?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let player = team?.roster?[indexPath.row], let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "playerCell") else { return UITableViewCell() }
        tableViewCell.textLabel?.text = player.displayName
        tableViewCell.detailTextLabel?.text = player.positionName
        return tableViewCell
    }
    
    //MARK: - UITableView delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlayer = team?.roster?[indexPath.row]
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
        CommonAlerts.sharedInstance.showLoadingAlertOn(viewController: self)
        if let playerID = selectedPlayer?.playerID {
            playerRetrievalUtility.getStats(for: playerID, completionBlock: { battingStats,pitchingStats  in
                self.selectedPlayer?.battingStats = battingStats
                self.selectedPlayer?.pitchingStats = pitchingStats
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
}
