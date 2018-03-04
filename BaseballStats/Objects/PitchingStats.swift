//
//  PitchingStats.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/2/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class PitchingStats: PlayerStat {
    //MARK: - ViewModel methods
    
    var eraString: String? {
        get {
            guard let pitchingObject = managedObject as? PitchingStatMO else {
                return nil
            }
            return NumberFormatters.pitchingNumberFormatter.string(from: NSNumber(value: pitchingObject.getERA()))
        }
    }
    
    override var displayValues: [String?] {
        get {
            guard let pitchingObject = managedObject as? PitchingStatMO else {
                return super.displayValues
            }
            return ["\(pitchingObject.games)",
                "\(pitchingObject.gamesStarted)",
                "\(pitchingObject.wins)",
                "\(pitchingObject.losses)",
                "\(pitchingObject.saves)",
                "\(pitchingObject.getInningsPitched())",
                "\(pitchingObject.getHits())",
                "\(pitchingObject.strikeouts)",
                "\(pitchingObject.getWalks())",
                eraString]
        }
    }
}
