//
//  SearchPodCastsService.swift
//  DaumWebtoon
//
//  Created by Tak on 15/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

class SearchPodCastsService {
    
    static let shared = SearchPodCastsService()
    
    private init() { }
    
    func searchPodCasts(query: String, completion: @escaping ([PodCastSearch]) -> ()) {
        let query = query.replacingOccurrences(of: " ", with: "+")
        let requestData = RequestData(path: HTTPBaseUrl.baseUrl.rawValue + "/typeahead?show_podcasts=1&show_genres=1&safe_mode=1&q=\(query)")
        
        SearchPodCastsAPI(data: requestData).execute(onSuccess: { (podcastSearch) in
            completion(podcastSearch.podcasts)
        }) { (error) in
            print(error)
        }
    }
}
