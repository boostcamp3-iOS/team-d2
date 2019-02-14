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

