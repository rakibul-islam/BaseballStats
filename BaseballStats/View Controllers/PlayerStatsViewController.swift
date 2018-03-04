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
    
    var player: PlayerMO?
    var pitcher = false
    
    let batterHeaderTexts = ["G","AB","H","K","BB","HR","AVG","OBP","SLG","OPS"]
    let pitcherHeaderTexts = ["G","GS","W","L","SV","IP","H","K","BB","ERA"]
    var viewModelArray = [PlayerStat]()
    
    lazy var playerRetrievalUtility = PlayerRetrievalUtility()
    lazy var coreDataController = CoreDataController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        if pitcher {
            if let statsArray = player?.pitchingStats?.array as? [PlayerStatMO] {
                for stat in statsArray {
                    viewModelArray.append(PitchingStats(with: stat))
                }
            }
        } else {
            if let statsArray = player?.battingStats?.array as? [PlayerStatMO] {
                for stat in statsArray {
                    viewModelArray.append(BattingStats(with: stat))
                }
            }
        }
        //Sort stats chronologically
        viewModelArray = viewModelArray.sorted(by: { (stat1, stat2) -> Bool in
            return stat1.managedObject.yearID > stat2.managedObject.yearID
        })
        displayStats()
    }
    
    func displayStats() {
        if viewModelArray.count > 0 {
            let numberOfSegments = min(viewModelArray.count, 3)
            yearSegmentedControl.removeAllSegments()
            for index in 0..<numberOfSegments {
                let stats = viewModelArray[index]
                yearSegmentedControl.insertSegment(withTitle: "\(stats.managedObject.yearID)", at: index, animated: false)
            }
            yearSegmentedControl.selectedSegmentIndex = 0
            segmentedControlValueChanged(yearSegmentedControl)
        } else {
            yearSegmentedControl.isHidden = true
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if yearSegmentedControl.isEqual(sender) {
            let stats = viewModelArray[yearSegmentedControl.selectedSegmentIndex]
            for index in 0..<min(stats.displayValues.count, statsLabels.count) {
                statsLabels[index].text = stats.displayValues[index]
            }
            if let currentTeamId = player?.teamID, let oldTeamName = stats.managedObject.team?.fullName {
                previousTeamLabel.isHidden = currentTeamId == stats.managedObject.teamID
                previousTeamLabel.text = "Member of: \(oldTeamName)"
            }
        }
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        if let playerToBookmark = player {
            coreDataController.bookmark(player: playerToBookmark)
        }
    }
}
