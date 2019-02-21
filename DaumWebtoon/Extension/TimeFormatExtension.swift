//
//  PremitiveExtension.swift
//  DaumWebtoon
//
//  Created by Tak on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation
import AVFoundation

extension Int {
    func stringFromTimeInt() -> String {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = self / 3600
        
        return String(format : "%02ld:%02ld:%02ld", hours, minutes, seconds)
    }
}

extension CMTime {
    func formatTimeFromSeconds() -> String {
        let totalSeconds = Int32(Float(Float64(CMTimeGetSeconds(self))))
        let seconds: Int32 = totalSeconds % 60
        let minutes: Int32 = (totalSeconds / 60) % 60
        let hours: Int32 = totalSeconds / 3600
        
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
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

