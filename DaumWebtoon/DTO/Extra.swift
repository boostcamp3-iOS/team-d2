//
//  LookingFor.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct Extra: Codable {
    let url1: String
    let url2: String
    let url3: String
    let instagramHandle: String
    let facebookHandle: String
    let twitterHandle: String
    let googleURL: String
    let spotifyURL: String
    let youtubeURL: String
    let linkedinURL: String
    let wechatHandle: String
    
    enum CodingKeys: String, CodingKey {
        case url1, url2, url3
        case instagramHandle = "instagram_handle"
        case facebookHandle = "facebook_handle"
        case twitterHandle = "twitter_handle"
        case googleURL = "google_url"
        case spotifyURL = "spotify_url"
        case youtubeURL = "youtube_url"
        case linkedinURL = "linkedin_url"
        case wechatHandle = "wechat_handle"
    }
}
