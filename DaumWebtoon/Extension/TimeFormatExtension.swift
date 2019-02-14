//
//  PremitiveExtension.swift
//  DaumWebtoon
//
//  Created by Tak on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

extension Int {
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let hours = (self / 3600)
        let minute : Int = Int(self / 60)
        let second : Int = Int(self.truncatingRemainder(dividingBy: 60))

        return String(format : "%02ld:%02ld:%02ld", hours, minute, second)
    }
}

