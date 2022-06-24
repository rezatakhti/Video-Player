//
//  DoubleExtensions.swift
//  Video Player
//
//  Created by Takhti, Gholamreza on 6/23/22.
//

import Foundation

extension Double {
    func timeFormatted() -> String? {
        let mins = self / 60
        let secs = self.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsString = timeformatter.string(from: NSNumber(value: mins)),
                let secondsString = timeformatter.string(from: NSNumber(value: secs)) else {
            return nil
        }
        
        return "\(minsString):\(secondsString)"
    }
}
