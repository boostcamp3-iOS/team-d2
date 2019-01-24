//
//  NetworkManager.swift
//  team-d2
//
//  Created by oingbong on 23/01/2019.
//  Copyright © 2019 boostcamp. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    // MARK: 사용방법
    /*
     let plistManager = PlistManager()
     guard let firebaseKey = plistManager.configure(FirebaseKey.self, resoureName: "firebase") else { return }
     let id = firebaseKey.accountId
     let url = firebaseKey.url
     let firebaseUrl = "\(url)?serviceAccountId=\(id)"
     let networkManager = NetworkManager()
     networkManager.request(with: firebaseUrl) { (data, error) in
        print(data)
     }
     */
    
    func request(with url: String, handler: @escaping (Data?, Error?) -> Void ) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else { return }
            handler(data, error)
        }
        task.resume()
    }
}
