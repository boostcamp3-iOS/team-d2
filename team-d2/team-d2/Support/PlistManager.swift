//
//  PlistManager.swift
//  team-d2
//
//  Created by oingbong on 23/01/2019.
//  Copyright © 2019 boostcamp. All rights reserved.
//

import Foundation

struct PlistManager {
    private let fileType = "plist"
    
    func configure<T:Decodable>(_ typeClass: T.Type, resoureName: String) -> T? {
        guard
            let url = Bundle.main.url(forResource: resoureName, withExtension: fileType),
            let data = data(with: url) else { return nil }        
        return decode(typeClass, from: data)
    }
    
    private func data(with url: URL) -> Data? {
        var data: Data? = nil
        do {
            data = try Data(contentsOf: url)
        } catch let error {
            print(error.localizedDescription)
        }
        return data
    }
    
    private func decode<T:Decodable>(_ typeClass: T.Type, from data: Data) -> T? {
        let decoder = PropertyListDecoder()
        var object: T? = nil
        do {
            object = try decoder.decode(T.self, from: data)
        } catch let error {
            print(error.localizedDescription)
        }
        return object
    }
}
