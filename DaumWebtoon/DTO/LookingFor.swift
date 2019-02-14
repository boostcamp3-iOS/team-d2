//
//  LookingFor.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct LookingFor: Codable {
    let cohosts: Bool
    let crossPromotion: Bool
    let guests: Bool
    let sponsors: Bool
    
    enum CodingKeys: String, CodingKey {
        case cohosts
        case crossPromotion = "cross_promotion"
        case guests, sponsors
    }
}
