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
    let nextEpisodePubDate: Int?

    enum CodingKeys: String, CodingKey {
        case title, description, publisher, episodes
        case nextEpisodePubDate = "next_episode_pub_date"
    }
}
