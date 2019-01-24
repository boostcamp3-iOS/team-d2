//
//  Firebase.swift
//  team-d2
//
//  Created by oingbong on 24/01/2019.
//  Copyright © 2019 boostcamp. All rights reserved.
//

import Foundation

struct FirebaseKey: Decodable {
    private enum CodingKeys: String, CodingKey {
        case url = "Url", uploadDate = "UploadDate", schedules = "Schedules"
    }
    
    let url: String
    let uploadDate: String
    let schedules: String
}
