//
//  PodCastSearch.swift
//  DaumWebtoon
//
//  Created by Tak on 15/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct PodCastSearch: Codable {
    let id: String
    let title: String
    let thumbnail: String
    let publisher: String
    
    enum CodingKeys: String, CodingKey {
        case id, thumbnail
        case title = "title_original"
        case publisher = "publisher_highlighted"
    }
}
