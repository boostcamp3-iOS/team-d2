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
     let url = firebaseKey.url
     let uploadDate = firebaseKey.uploadDate
     let schedules = firebaseKey.schedules
     let firebaseUrl = "\(url)\(uploadDate)"
     let firebaseUrl = "\(url)\(schedules)"
     let networkManager = NetworkManager()
     networkManager.request(with: firebaseUrl) { (data, error) in
        print(data)
     }
     */
    
    func request(with url: String, handler: @escaping (Data?, Error?) -> Void ) {
        guard
            let encode = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let encodedUrl = URL(string: encode) else { return }
        let task = URLSession.shared.dataTask(with: encodedUrl) { (data, _, error) in
            guard error == nil else { return }
            handler(data, error)
        }
        task.resume()
    }
}
