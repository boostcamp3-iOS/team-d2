//
//  Podcast.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct PodCast: Codable {
    
    let title: String
    let description: String
    let publisher: String
    let episodes: [Episode]

    enum CodingKeys: String, CodingKey {
        case title, description, publisher, episodes
    }
}
