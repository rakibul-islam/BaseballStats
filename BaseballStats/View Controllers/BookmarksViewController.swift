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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
}
