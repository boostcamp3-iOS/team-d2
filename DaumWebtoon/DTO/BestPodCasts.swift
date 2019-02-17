//
//  Channel.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct BestPodCasts: Codable {
    let hasNext: Bool
    let hasPrevious: Bool
    let name: String
    let pageNumber: Int
    let listennotesURL: String
    let total: Int
    let id: Int
    let channels: [Channel]
    let nextPageNumber: Int
    let parentID: Int?
    let previousPageNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case hasNext = "has_next"
        case hasPrevious = "has_previous"
        case name
        case pageNumber = "page_number"
        case listennotesURL = "listennotes_url"
        case total, id, channels
        case nextPageNumber = "next_page_number"
        case parentID = "parent_id"
        case previousPageNumber = "previous_page_number"
    }
}
