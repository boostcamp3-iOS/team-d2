//
//  FetchImageAPI.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit
import Foundation

class FetchImageService {
    
    static let shared = FetchImageService()
    
    private init() { }
    
    func execute(imageUrl: String, onSuccess: @escaping (UIImage) -> Void) {
        guard let imageUrl = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            guard
                let _data = data,
                let image = UIImage(data: _data) else {
                print("image fetching error")
                return
            }
            
            DispatchQueue.main.async {
                onSuccess(image)
            }
        }.resume()
    }
}
