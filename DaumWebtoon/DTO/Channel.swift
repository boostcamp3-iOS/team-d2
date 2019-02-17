//
//  Channel.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct Channel: Codable {
    let website: String?
    let earliestPubDateMS: Int
    let explicitContent: Bool
    let publisher: String
    let image: String
    let isClaimed: Bool
    let totalEpisodes: Int
    let lastestPubDateMS: Int
    let language: String
    let title: String
    let thumbnail: String
    let listennotesURL: String
    let extra: Extra
    let rss: String?
    let email: String?
    let lookingFor: LookingFor
    let country: String?
    let id: String
    let itunesID: Int?
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case website
        case earliestPubDateMS = "earliest_pub_date_ms"
        case explicitContent = "explicit_content"
        case publisher, image
        case isClaimed = "is_claimed"
        case totalEpisodes = "total_episodes"
        case lastestPubDateMS = "lastest_pub_date_ms"
        case language, title, thumbnail
        case listennotesURL = "listennotes_url"
        case extra, rss, email
        case lookingFor = "looking_for"
        case country, id
        case itunesID = "itunes_id"
        case description
    }
}
