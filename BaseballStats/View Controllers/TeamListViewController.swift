//
//  SecondViewController.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class TeamListViewController: UITableViewController {
    var teams = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getListOfTeams()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getListOfTeams() {
        let loadingController = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
        loadingController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            URLSession.shared.invalidateAndCancel()
        }))
        present(loadingController, animated: true, completion: nil)
        TeamRetrievalUtility.sharedInstance.getTeams { (teams) in
            loadingController.dismiss(animated: true, completion: {
                self.teams = teams
                self.tableView.reloadData()
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
        let loadingController = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
        loadingController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            URLSession.shared.invalidateAndCancel()
        }))
        present(loadingController, animated: true, completion: nil)
        let team = teams[indexPath.row]
        TeamRetrievalUtility.sharedInstance.getRosterFor(team: team, completionBlock: { (players) in
            DispatchQueue.main.async {
                loadingController.dismiss(animated: true, completion: {
                    team.roster = players
                })
            }
        }, failureBlock: { (error) in
            DispatchQueue.main.async {
                loadingController.dismiss(animated: true, completion: {
                    self.showErrorAlert(error: error)
                })
            }
        })
    }
}

