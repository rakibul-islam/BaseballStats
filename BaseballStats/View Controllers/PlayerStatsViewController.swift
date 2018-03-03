//
//  PlayerStatsViewController.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/2/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class PlayerStatsViewController: UIViewController {
    @IBOutlet weak var headshotImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var teamNumberLabel: UILabel!
    
    var player: Player?
    
    lazy var playerRetrievalUtility = PlayerRetrievalUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLabel.text = player?.displayName
        positionLabel.text = player?.positionName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = player?.battingStats {
            displayStats()
        } else {
            getStatsForPlayer()
        }
    }
    
    func displayStats() {
        //TODO: display stats
    }
    
    func getStatsForPlayer() {
        if let playerID = player?.playerID {
            playerRetrievalUtility.getStats(for: playerID, completionBlock: { (battingStats) in
                self.player?.battingStats = battingStats
                DispatchQueue.main.async {
                    self.displayStats()
                }
            })
        }
    }

}
