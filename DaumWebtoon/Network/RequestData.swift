//
//  RequestData.swift
//  DaumWebtoon
//
//  Created by Tak on 06/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

struct RequestData {
    let path: String
    let method: HTTPMethod
    let params: [String: Any?]?
    let headers: [String: String]?
    
    init (
        path: String,
        method: HTTPMethod = .get,
        params: [String: Any?]? = nil,
        headers: [String: String]? = ["Content-Type": "application/x-www-form-urlencoded"]
        ) {
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
    }
}
