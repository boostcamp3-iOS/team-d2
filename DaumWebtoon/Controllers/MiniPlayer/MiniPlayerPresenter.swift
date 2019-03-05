//
//  MiniPlayerPresenter.swift
//  DaumWebtoon
//
//  Created by Tak on 05/03/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation
import UIKit

enum LoadingStatus: CGFloat {
    case success = 0.0
    case loading = 1.0
}

protocol MiniPlayerView: class {
    func showMiniPlayer(yPosition: CGFloat)
    func showEpisodeThumnail(thumbnailImage: UIImage)
    func showPlayButtonState(sender: UIButton)
}

class MiniPlayerPresenter {
    
    var isLoading: CGFloat = 1.0
    
    private weak var view: MiniPlayerView?
    
    private let audioService: AudioService
    private let dbService: DatabaseService
    
    init(audioService: AudioService, dbService: DatabaseService) {
        self.audioService = audioService
        self.dbService = dbService
    }
    
    func calcuateDeviceHasNorch() {
        var y: CGFloat = 0.0
        
        if UIDevice.current.hasNotch {
            y = UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.size.height + 32)
        } else {
            y = UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.size.height + 54)
        }
        
        view?.showMiniPlayer(yPosition: y)
    }
    
    func fetchEpisodeThumbnail(thumbnailUrl: String) {
        FetchImageService.shared.execute(imageUrl: thumbnailUrl) { [weak self] (image) in
            guard let self = self else { return }
            self.view?.showEpisodeThumnail(thumbnailImage: image)
        }
    }
    
    func setupAndPlayAudio(episode: Episode?) {
        guard let episode = episode else { return }
        audioService.setupAndPlayAudio(audioUrl: episode.audio)
    }
    
    func addRecentEpisode(episode: Episode?) {
        guard let episode = episode else { return }
        dbService.addRecentEpisode(with: episode)
    }
    
    func playPauseDidTapped(sender: UIButton) {
        audioService.togglePlayPause()

        if isLoading == LoadingStatus.success.rawValue {
            view?.showPlayButtonState(sender: sender)
        }
    }
    
    func stopAudio() {
        audioService.stopAudio()
    }
    
    func timeInterval() {
         audioService.timeInterval()
    }
    
    func attachView(view: MiniPlayerView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
    
}
