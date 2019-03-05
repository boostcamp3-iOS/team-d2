//
//  EpisodeModalPresenter.swift
//  DaumWebtoon
//
//  Created by Tak on 05/03/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation
import UIKit

protocol EpisodeModalView: class {
    func showEpisodeImage(image: UIImage)
    func showFavoriteState(isFavorite: Bool)
    func draggingTouchScreen(position: CGPoint, recognizer: UIPanGestureRecognizer)
    func dismiss()
    func aniamteToOriginalFrame()
}

class EpisodeModalPresenter {
    
    private weak var view: EpisodeModalView?
    
    private let audioService: AudioService
    private let dbService: DatabaseService
    
    init(audioService: AudioService, dbService: DatabaseService) {
        self.audioService = audioService
        self.dbService = dbService
    }
    
    func fetchEpisodeImage(imageUrl: String?) {
        FetchImageService.shared.execute(imageUrl: imageUrl ?? "") { [weak self] (image) in
            guard let self = self else { return }
            self.view?.showEpisodeImage(image: image)
        }
    }
    
    func togglePlayPause() {
        audioService.togglePlayPause()
    }
    
    func sliderValueChanged(value: Float) {
        audioService.progressValueChanged(seconds: value)
    }
    
    func timeInterval() {
        audioService.timeInterval()
    }
    
    func manageFavoriteEpisode(episode: Episode, state: Bool) {
        dbService.manageFavoriteEpisode(with: episode, state: state)
    }
    
    func isFavoriteEpisode(episode: Episode?) {
        guard let episode = episode else { return }
        let isFavorite = dbService.isFavoriteEpisode(of: episode)
        view?.showFavoriteState(isFavorite: isFavorite)
    }
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        guard let episodeModalViewController = self.view as? EpisodeModalViewController,
            let episodeView = episodeModalViewController.view else {
            return
        }
        
        let touchPoint = recognizer.location(in: episodeView.window)
        let translation = recognizer.translation(in: episodeView)
        
        var initialTouchPoint = CGPoint.zero
        switch recognizer.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                let draggingPosition = CGPoint(x: episodeView.center.x, y: episodeView.center.y + translation.y)
                view?.draggingTouchScreen(position: draggingPosition, recognizer: recognizer)
            }
        case .ended, .cancelled:
            if episodeView.frame.origin.y > episodeView.frame.size.height / 2 {
                view?.dismiss()
            } else {
                view?.aniamteToOriginalFrame()
            }
        case .failed, .possible:
            break
        }
    }
    
    func attachView(view: EpisodeModalView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
    
}
