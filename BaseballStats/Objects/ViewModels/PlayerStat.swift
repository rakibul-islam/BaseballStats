//
//  PlayerStat.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/2/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class PlayerStat {
    var managedObject: PlayerStatMO
    
    init(with managedObject: PlayerStatMO) {
        self.managedObject = managedObject
    }
    
    //MARK: - ViewModel methods
    var displayValues: [String?] {
        get {
            return [String](repeating: "", count: 10)
        }
    }
}
