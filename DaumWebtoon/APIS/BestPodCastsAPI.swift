//
//  BestPodCastsAPI.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct BestPodCastsAPI: RequestType {
    typealias ResponseType = BestPodCasts
    var data: RequestData
}
