//
//  Firebase.swift
//  team-d2
//
//  Created by oingbong on 24/01/2019.
//  Copyright © 2019 boostcamp. All rights reserved.
//

import Foundation

struct Firebase: Decodable {
    private enum CodingKeys: String, CodingKey {
        case url = "Url", accountId = "AccountId"
    }
    
    let url: String
    let accountId: String
}
