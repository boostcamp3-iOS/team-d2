//
//  Episode.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct Episode: Codable {
    
    let title: String
    let duration: Int
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case title, thumbnail
        case duration = "audio_length"
    }
}
