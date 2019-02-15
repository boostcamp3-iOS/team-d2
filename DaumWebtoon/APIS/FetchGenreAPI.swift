//
//  FetchGenreAPI.swift
//  DaumWebtoon
//
//  Created by Tak on 15/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct FetchGenreAPI: RequestType {
    
    typealias ResponseType = GenreDTO
    var data: RequestData
}
