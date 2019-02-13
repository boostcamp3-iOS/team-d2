//
//  Episode.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let id: String
    let duration: Int
    let audio: String
    let image: String
    let thumbnail: String
    let description: String
    let channelTitle: String?
    let title: String
    let dateTime: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, audio, image, thumbnail, description, dateTime, channelTitle
        case duration = "audio_length"
        case title = "title"
    }
}
