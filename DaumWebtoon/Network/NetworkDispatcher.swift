//
//  NetworkDispatcher.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

protocol NetworkDispatcher {
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void)
}

struct URLSessionNetworkDispatcher: NetworkDispatcher {
    
    static let shared = URLSessionNetworkDispatcher()
    
    private init() {}
    
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: request.path) else {
            onError(ConnectionError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=UTF-8;", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("4e126310femshc6a8864c872a007p18d560jsnf26adf945b66", forHTTPHeaderField: "X-RapidAPI-Key")
        urlRequest.httpMethod = request.method.rawValue

        do {
            if let params = request.params {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch let error {
            onError(error)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                onError(error)
                return
            }
            
            guard let _data = data else {
                onError(ConnectionError.noData)
                return
            }
            
            onSuccess(_data)
        }.resume()
    }
}
