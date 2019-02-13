//
//  FetchPodCasts.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation


struct FetchPodCastsAPI: RequestType {
    
    typealias ResponseType = PodCast
    var data: RequestData
}
