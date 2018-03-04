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
    @IBOutlet weak var previousTeamLabel: UILabel!
    
    var player: Player?
    var pitcher = false
    
    let batterHeaderTexts = ["G","AB","H","K","BB","HR","AVG","OBP","SLG","OPS"]
    let pitcherHeaderTexts = ["G","GS","W","L","SV","IP","H","K","BB","ERA"]
    
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
            pitcher = isPitcher
            let headerTexts = isPitcher ? pitcherHeaderTexts : batterHeaderTexts
            for index in 0..<headerLabels.count {
                headerLabels[index].text = headerTexts[index]
            }
        }
        displayStats()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayStats() {
        if let statsArray: [PlayerStat] = (pitcher ? player?.pitchingStats : player?.battingStats), statsArray.count > 0 {
            let numberOfSegments = min(statsArray.count, 3)
            yearSegmentedControl.removeAllSegments()
            for index in 0..<numberOfSegments {
                let stats = statsArray[index]
                yearSegmentedControl.insertSegment(withTitle: "\(stats.yearID)", at: index, animated: false)
            }
            yearSegmentedControl.selectedSegmentIndex = 0
            segmentedControlValueChanged(yearSegmentedControl)
        } else {
            yearSegmentedControl.isHidden = true
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if yearSegmentedControl.isEqual(sender) {
            if let statsArray:[PlayerStat] = pitcher ? player?.pitchingStats : player?.battingStats, statsArray.count > 0 {
                let stats = statsArray[yearSegmentedControl.selectedSegmentIndex]
                for index in 0..<min(stats.displayValues.count, statsLabels.count) {
                    statsLabels[index].text = stats.displayValues[index]
                }
                if let currentTeamId = player?.teamID, let statTeamId = stats.teamID, let oldTeamName = stats.team?.fullName {
                    previousTeamLabel.isHidden = currentTeamId == statTeamId
                    previousTeamLabel.text = "Member of: \(oldTeamName)"
                }
            }
        }
    }
}
