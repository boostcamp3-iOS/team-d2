//
//  BestPodCastFetcher.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

class BestPodCastsFetcher {
    static let shared = BestPodCastsFetcher()
    
    private init() { }
    
    func loadPage(genre: Int?, currentPage: Int, completion: @escaping (BestPodCasts) -> ()) {
        guard let genre = genre else { return }
        let requestData = RequestData(path: HTTPBaseUrl.baseUrl.rawValue + "/best_podcasts?genre_id=\(genre)&page=\(currentPage)")
        BestPodCastsAPI(data: requestData).execute(onSuccess: { bestPodCasts in
            completion(bestPodCasts)
        }, onError: { error in
            print(error)
        })
    }
}
