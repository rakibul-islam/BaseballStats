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
    @IBOutlet weak var batsAndThrowsLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var heightWeightLabel: UILabel!
    
    @IBOutlet weak var yearSegmentedControl: UISegmentedControl!
    @IBOutlet var headerLabels: [UILabel]!
    @IBOutlet var statsLabels: [UILabel]!
    
    var player: Player?
    
    let batterHeaderTexts = ["G","AB","H","K","BB","HR","AVG","OBP","SLG","OPS"]
    
    lazy var playerRetrievalUtility = PlayerRetrievalUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Player Info"
        nameLabel.text = player?.displayName
        positionLabel.text = player?.positionName
        teamNumberLabel.text = player?.teamAndNumber
        batsAndThrowsLabel.text = player?.batsAndThrows
        dateOfBirthLabel.text = player?.dateOfBirth
        heightWeightLabel.text = player?.heightWeight
        playerRetrievalUtility.loadImageFrom(urlString: player?.headShotURL) { (image) in
            DispatchQueue.main.async {
                self.headshotImageView.image = image
            }
        }
        if let isPitcher = player?.isPitcher {
            let headerTexts = isPitcher ? batterHeaderTexts : batterHeaderTexts
            for index in 0..<headerLabels.count {
                headerLabels[index].text = headerTexts[index]
            }
        }
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
        if let battingStatsArray = player?.battingStats, battingStatsArray.count > 0 {
            let numberOfSegments = min(battingStatsArray.count, 3)
            yearSegmentedControl.removeAllSegments()
            for index in 0..<numberOfSegments {
                let battingStats = battingStatsArray[index]
                yearSegmentedControl.insertSegment(withTitle: "\(battingStats.yearID)", at: index, animated: false)
            }
            yearSegmentedControl.selectedSegmentIndex = 0
            segmentedControlValueChanged(yearSegmentedControl)
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if yearSegmentedControl.isEqual(sender) {
            if let battingStatsArray = player?.battingStats, battingStatsArray.count > 0 {
                let battingStats = battingStatsArray[yearSegmentedControl.selectedSegmentIndex]
                statsLabels[0].text = "\(battingStats.games)"
                statsLabels[1].text = "\(battingStats.atBats)"
                statsLabels[2].text = "\(battingStats.hits)"
                statsLabels[3].text = "\(battingStats.strikeouts)"
                statsLabels[4].text = "\(battingStats.walks)"
                statsLabels[5].text = "\(battingStats.homeRuns)"
                statsLabels[6].text = battingStats.averageString
                statsLabels[7].text = battingStats.obpString
                statsLabels[8].text = battingStats.sluggingString
                statsLabels[9].text = battingStats.opsString
            }
        }
    }
    
    func getStatsForPlayer() {
        let loadingController = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
        loadingController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            URLSession.shared.invalidateAndCancel()
        }))
        present(loadingController, animated: true, completion: nil)
        if let playerID = player?.playerID {
            playerRetrievalUtility.getStats(for: playerID, completionBlock: { (battingStats) in
                self.player?.battingStats = battingStats
                DispatchQueue.main.async {
                    loadingController.dismiss(animated: true, completion: nil)
                    self.displayStats()
                }
            }, failureBlock: { (error) in
                DispatchQueue.main.async {
                    loadingController.dismiss(animated: true, completion: nil)
                }
            })
        }
    }

}
