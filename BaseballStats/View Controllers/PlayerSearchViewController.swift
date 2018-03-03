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
    var selectedIndexPath: IndexPath?
    
    lazy var playerRetrievalUtility = PlayerRetrievalUtility()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statsVC = segue.destination as? PlayerStatsViewController {
            if let selectedCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: selectedCell) {
                statsVC.player = players[indexPath.row]
            }
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
                    loadingController.dismiss(animated: true, completion: nil)
                    self.tableView.reloadData()
                }
            }, failureBlock: { (error) in
                DispatchQueue.main.async {
                    loadingController.dismiss(animated: true, completion: nil)
                }
            })
        }
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
}
