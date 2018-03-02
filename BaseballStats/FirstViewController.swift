//
//  FirstViewController.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var players = [Player]()
    
    lazy var playerRetrievalUtility = PlayerRetrievalUtility()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - UISearchBar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            playerRetrievalUtility.getPlayersWith(searchParameter: searchText, completionBlock: { (players) in
                self.players = players
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
