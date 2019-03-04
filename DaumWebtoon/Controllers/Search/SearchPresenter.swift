//
//  SearchPresenter.swift
//  DaumWebtoon
//
//  Created by Tak on 01/03/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation
import UIKit

protocol SearchView {
    func showRecommandPodCastGenres(genres: [Genre]?)
    func showPodcastsTableView()
    func hidePodcastsTableView()
    func showPodcasts(podcasts: [PodCastSearch])
    func showRecommandHalfBottomView()
    func hideRecommanHalfdBottomView()
    func showKeywordInput(keyword: String)
    func animateTableViewCell(cell: UITableViewCell, row: Int)
    func disAnimateTableViewCell(cell: UITableViewCell)
    func animateUpRecommandHalfBottomView()
    func dismiss()
}

class SearchPresenter {
    
    private let searchService: SearchPodCastsService?
    private let podcastService: PodCastService?
    
    private var view: SearchView?
    private var isFirst = true
    
    init(searchService: SearchPodCastsService, podcastService: PodCastService) {
        self.searchService = searchService
        self.podcastService = podcastService
    }
    
    func fetchRecommandationPodcast() {
        podcastService?.fetchPodCastGenres(completion: { [weak self] (genres) in
            guard let self = self else { return }
            self.view?.showRecommandPodCastGenres(genres: genres)
        })
    }
    
    func searchPodCasts(query: String?) {
        guard var query = query, query != "" else { return }
        
        if query.starts(with: "#") {
            query = String(query.suffix(query.count-1))
        }
        
        searchPodCasts(query: query)
    }
    
    func viewDidAppear() {
        if isFirst {
            view?.animateUpRecommandHalfBottomView()
            isFirst = false
        }
    }
    
    func textFieldDidChange(query: String?) {
        guard let query = query else { return }

        if query.isEmpty {
            view?.hidePodcastsTableView()
            view?.showRecommandHalfBottomView()
            return
        }
        
        searchPodCasts(query: query)
    }
    
    func didSelectRecommandPodCast(selectedGenre: Genre?) {
        guard let genre = selectedGenre else { return }

        view?.showKeywordInput(keyword: "#\(genre.name)")
        searchPodCasts(query: genre.name)
    }
    
    func calcuateTableViewRowCount(cell: UITableViewCell, row: Int) {
        if row < 10 {
            view?.animateTableViewCell(cell: cell, row: row)
        } else {
            view?.disAnimateTableViewCell(cell: cell)
        }
    }
    
    func calculateEdgeGestureRecognizer(horizontalMovement: CGFloat, recognizerState: UIGestureRecognizer.State, interactor: Interactor?) {
        let percentThreshold: CGFloat = 0.3

        let rightMovement = fmaxf(Float(horizontalMovement), 0.0)
        let rightMovementPercent = fminf(rightMovement, 1.0)
        let progress = CGFloat(rightMovementPercent)

        guard let interactor = interactor else { return }

        switch recognizerState {
        case .began:
            interactor.hasStarted = true
            view?.dismiss()
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
    func attachView(view: SearchView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
    
    private func searchPodCasts(query: String) {
        searchService?.searchPodCasts(query: query, completion: { [weak self] (podcasts) in
            guard let self = self else { return }
            
            self.view?.hideRecommanHalfdBottomView()
            self.view?.showPodcastsTableView()
            self.view?.showPodcasts(podcasts: podcasts)
        })
    }
}
