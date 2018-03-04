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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = team?.abbreviation
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UITableView datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team!.roster?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let player = team?.roster?[indexPath.row], let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "playerCell") else { return UITableViewCell() }
        tableViewCell.textLabel?.text = player.displayName
        tableViewCell.detailTextLabel?.text = player.positionName
        return tableViewCell
    }
}
