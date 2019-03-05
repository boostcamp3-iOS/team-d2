//
//  PodCastsPresenter.swift
//  DaumWebtoon
//
//  Created by Tak on 04/03/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation
import UIKit

protocol PodCastsView: class {
    func showPodcasts(podcast: PodCast)
    func showHeaderImageInNorch()
    func showHeaderImageInNorchElse()
    func animateAlphaWithDelayOnTableViewCell(cell: UICollectionViewCell, row: Int)
    func animateAlphaOnTableViewCell(cell: UICollectionViewCell)
}

class PodCastsPresenter {
    
    var podcastId: String?
    
    private weak var view: PodCastsView?
    private var nextEpisodePubDate: String? = ""
    
    private let service: PodCastService
    
    init(service: PodCastService) {
        self.service = service
    }
 
    func fetchPodCasts() {
        service.fetchPodCasts(podcastId: podcastId, nextEpisodePubDate: nextEpisodePubDate) { [weak self] (podcast) in
            guard let self = self,
                let nextEpisodePubDate = podcast.nextEpisodePubDate else {
                    return
            }
            
            self.nextEpisodePubDate = String(nextEpisodePubDate)
            self.view?.showPodcasts(podcast: podcast)
        }
    }
    
    func calculateDeviceHasNorch() {
        if UIDevice.current.hasNotch {
            view?.showHeaderImageInNorch()
        } else {
            view?.showHeaderImageInNorchElse()
        }
    }
    
    func calcuateAnimationCellRow(cell: UICollectionViewCell, row: Int) {
        if row < 15 {
            view?.animateAlphaWithDelayOnTableViewCell(cell: cell, row: row)
        } else {
            view?.animateAlphaOnTableViewCell(cell: cell)
        }
    }
    
    func paginatePodcasts(item: Int, episodeCount: Int) {
        if item == episodeCount - 10 || episodeCount - 10 < 0 {
            fetchPodCasts()
        }
    }
    
    func attachView(view: PodCastsView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
    
}
