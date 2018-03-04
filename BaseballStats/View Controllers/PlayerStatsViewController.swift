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
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if yearSegmentedControl.isEqual(sender) {
            if pitcher {
                if let pitchingStatsArray = player?.pitchingStats, pitchingStatsArray.count > 0 {
                    let pitchingStats = pitchingStatsArray[yearSegmentedControl.selectedSegmentIndex]
                    statsLabels[0].text = "\(pitchingStats.games)"
                    statsLabels[1].text = "\(pitchingStats.gamesStarted)"
                    statsLabels[2].text = "\(pitchingStats.wins)"
                    statsLabels[3].text = "\(pitchingStats.losses)"
                    statsLabels[4].text = "\(pitchingStats.saves)"
                    statsLabels[5].text = "\(pitchingStats.inningsPitched)"
                    statsLabels[6].text = "\(pitchingStats.hits)"
                    statsLabels[7].text = "\(pitchingStats.strikeouts)"
                    statsLabels[8].text = "\(pitchingStats.walks)"
                    statsLabels[9].text = "\(pitchingStats.eraString)"
                    if let currentTeamId = player?.teamID, let statTeamId = pitchingStats.teamID {
                        previousTeamLabel.isHidden = currentTeamId == statTeamId
                        previousTeamLabel.text = "Member of: \(pitchingStats.team?.fullName ?? "")"
                    }
                }
            } else {
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
                    if let currentTeamId = player?.teamID, let statTeamId = battingStats.teamID {
                        previousTeamLabel.isHidden = currentTeamId == statTeamId
                        previousTeamLabel.text = "Member of: \(battingStats.team?.fullName ?? "")"
                    }
                }
            }
        }
    }
}
