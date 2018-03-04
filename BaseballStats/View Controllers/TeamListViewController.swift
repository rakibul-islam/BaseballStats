//
//  SecondViewController.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class TeamListViewController: UITableViewController {
    var teams = [TeamMO]()
    var selectedTeam: TeamMO?
    @IBOutlet weak var redoBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getListOfTeams()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let teamVC = segue.destination as? TeamViewController {
            teamVC.team = selectedTeam
        }
    }

    @IBAction func redoBarButtonItemClicked(_ sender: Any) {
        getListOfTeams()
    }
    
    func getListOfTeams() {
        CommonAlerts.sharedInstance.showLoadingAlertOn(viewController: self)
        TeamRetrievalUtility.sharedInstance.getTeams(completionBlock: { (teams) in
            CommonAlerts.sharedInstance.dismissLoadingAlert(completionBlock: {
                self.teams = teams
                self.navigationItem.rightBarButtonItem = nil
                self.tableView.reloadData()
            })
        }, failureBlock: { (error) in
            CommonAlerts.showErrorAlertOn(viewController: self, messageString: nil, error: error)
        })
    }
    
    //MARK: - Table view datasource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "teamCell") else { return UITableViewCell() }
        let team = teams[indexPath.row]
        tableViewCell.textLabel?.text = team.fullName
        tableViewCell.detailTextLabel?.text = team.league
        return tableViewCell
    }
    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = teams[indexPath.row]
        selectedTeam = team
        if let roster = team.roster, roster.count > 0 {
            self.performSegue(withIdentifier: "showTeamRoster", sender: nil)
        } else {
            CommonAlerts.sharedInstance.showLoadingAlertOn(viewController: self)
            TeamRetrievalUtility.sharedInstance.getRosterFor(team: team, completionBlock: { () in
                DispatchQueue.main.async {
                    CommonAlerts.sharedInstance.dismissLoadingAlert(completionBlock: {
                        self.performSegue(withIdentifier: "showTeamRoster", sender: nil)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

