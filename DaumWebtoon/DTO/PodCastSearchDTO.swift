//
//  PodCastSearch.swift
//  DaumWebtoon
//
//  Created by Tak on 15/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct PodCastSearchDTO: Codable {
    let podcasts: [PodCastSearch]
    
    enum CodingKeys: String, CodingKey {
        case podcasts
    }
}
