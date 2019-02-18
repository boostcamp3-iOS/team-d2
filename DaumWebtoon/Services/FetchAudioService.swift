//
//  FetchAudioService.swift
//  DaumWebtoon
//
//  Created by Tak on 13/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

class FetchAudioService {
    
    static let shared = FetchAudioService()
    
    private init() { }
    
    func execute(audioUrl: String, onSuccess: @escaping (Data) -> Void) {
        guard let audioUrl = URL(string: audioUrl) else { return }
    
        URLSession.shared.dataTask(with: audioUrl) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                onSuccess(data!)
            }
        }.resume()
    }
}
