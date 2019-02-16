//
//  SearchPodCastsAPI.swift
//  DaumWebtoon
//
//  Created by Tak on 15/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct SearchPodCastsAPI: RequestType {
    
    typealias ResponseType = PodCastSearchDTO
    var data: RequestData
}
