//
//  PodCastService.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit
import Foundation

class PodCastService {
    
    static let shared = PodCastService()
    
    private init() { }
    
    func fetchPodCasts(podcastId: String?, nextEpisodePubDate: String?, completion: @escaping (PodCast) -> ()) {
        guard let podcastId = podcastId,
            let nextEpisodePubDate = nextEpisodePubDate else { return }
        
        let requestData = RequestData(path: HTTPBaseUrl.baseUrl.rawValue + "/podcasts/" + podcastId + "?next_episode_pub_date=" + nextEpisodePubDate)
        
        FetchPodCastsAPI(data: requestData).execute(onSuccess: { (podcast) in
            completion(podcast)
        }) { (error) in
            print(error)
        }
    }
    
    func fetchPodCastGenres(completion: @escaping ([Genre]) -> ()) {
        let requestData = RequestData(path: HTTPBaseUrl.baseUrl.rawValue + "/genres")
        
        FetchGenresAPI(data: requestData).execute(onSuccess: { (genreDTO) in
            var genres = [Genre]()
            
            var count = 0
            if genreDTO.genres.count > 25 {
                count = 25
            } else {
                count = genreDTO.genres.count
            }
            
            for index in 0..<count {
                genres.append(genreDTO.genres[index])
            }
            
            completion(genres)
        }) { (error) in
            print("onError")
        }
    }

}
