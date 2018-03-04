//
//  NumberFormatters.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class NumberFormatters {
    static let battingNumberFormatter = NumberFormatter()
    static let pitchingNumberFormatter = NumberFormatter()
    
    static func setupNumberFormatters() {
        battingNumberFormatter.numberStyle = .decimal
        battingNumberFormatter.maximumFractionDigits = 3
        battingNumberFormatter.minimumFractionDigits = 3
        battingNumberFormatter.minimumIntegerDigits = 0
        battingNumberFormatter.maximumIntegerDigits = 1
        
        pitchingNumberFormatter.numberStyle = .decimal
        pitchingNumberFormatter.maximumFractionDigits = 2
        pitchingNumberFormatter.minimumFractionDigits = 2
        pitchingNumberFormatter.minimumIntegerDigits = 1
        pitchingNumberFormatter.maximumIntegerDigits = 1
    }
}
