//
//  NetworkManager.swift
//  team-d2
//
//  Created by oingbong on 23/01/2019.
//  Copyright © 2019 boostcamp. All rights reserved.
//

import Foundation

struct NetworkManager {
    static func request(urlName: String, handler: @escaping (Data?) -> Void ) {
        guard let url = URL(string: urlName) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil { return }
            handler(data)
        }
        task.resume()
    }
}
