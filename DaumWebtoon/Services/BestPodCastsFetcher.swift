//
//  BestPodCastFetcher.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

protocol BestPodCastsFetcher: class {
    var genre: String { get }
    func execute(completion: @escaping (BestPodCasts) -> ())
}

class BaseBestPodCastsFetcher: BestPodCastsFetcher {
    var genre = ""
    
    func execute(completion: @escaping (BestPodCasts) -> ()) {
        let requestData = RequestData(path: HTTPBaseUrl.baseUrl.rawValue + "/best_podcasts?genre_id=" + genre)
        
        BestPodCastsAPI(data: requestData).execute(onSuccess: { bestPodCasts in
            completion(bestPodCasts)
        }, onError: { error in
            print(error)
        })
    }
}

class WebDesignBestPodCastsFetcher: BaseBestPodCastsFetcher {
    override init() {
        super.init()
        self.genre = "140"
    }
}

class ProgrammingBestPodCastsFetcher: BaseBestPodCastsFetcher {
    override init() {
        super.init()
        self.genre = "143"
    }
}

class VRandARBestPodCastsFetcher: BaseBestPodCastsFetcher {
    override init() {
        super.init()
        self.genre = "139"
    }
}

class StartupBestPodCastsFetcher: BaseBestPodCastsFetcher {
    override init() {
        super.init()
        self.genre = "157"
    }
}
