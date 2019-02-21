//
//  DetailWeatherViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 06/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit
import AVFoundation

protocol EpisodeModalViewDelegate: class {
    func playPauseAudio(state: Bool)
    func showHeaderImageView()
}

class EpisodeModalViewController: UIViewController {

    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeProgress: UISlider!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var episodeTotalTime: UILabel!
    @IBOutlet weak var episodeUpdateTime: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var loading: UILabel!
    
    weak var delegate: EpisodeModalViewDelegate?
    
    var episode: Episode?
    
    private let dbService = DatabaseService()
    private let audioService = AudioService.shared
    
    private var audioUrl: String?
    private var audioTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFavoriteViewState()
        
        setupEpisode()
        setupViews()
        setupAudio()
        
        addRecentEpisode()
    }
    
    func togglePlayPause() {
        audioService.togglePlayPause()
    }
    
    private func setupViews() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupEpisode() {
        guard let episode = self.episode else { return }
        
        episodeTitle.text = episode.title
        FetchImageService.shared.execute(imageUrl: episode.image) { [weak self] (image) in
            guard let self = self else { return }
            self.episodeImage.image = image
        }
    }
    
    private func setupAudio() {
        audioService.dataSource = self
        setupAudioTimer()
    }
    
    private func setupAudioTimer() {
        audioTimer = Timer(timeInterval: 0.001, target: self, selector: #selector(EpisodeModalViewController.timeInterval), userInfo: nil, repeats: true)
        RunLoop.current.add(audioTimer!, forMode: RunLoop.Mode.common)
    }
    
    private func setupFavoriteViewState() {
        guard let episode = self.episode else { return }
        let isFavorite = dbService.isFavoriteEpisode(of: episode)
        favoriteButton.isSelected = isFavorite
    }

    private func dismissModal() {
        delegate?.showHeaderImageView()
        dismiss(animated: true, completion: nil)
    }
    
    private func addRecentEpisode() {
        guard let episode = self.episode else { return }
        dbService.addRecentEpisode(with: episode)
    }
    
    // MARK :- event handling
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        audioService.progressValueChanged(seconds: sender.value)
    }
    
    @objc func timeInterval(){
        audioService.timeInterval()
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view?.window)
        let translation = recognizer.translation(in: view)
        
        var initialTouchPoint = CGPoint.zero
        switch recognizer.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        case .ended, .cancelled:
            if view.frame.origin.y > view.frame.size.height / 2 {
                dismissModal()
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.view.frame.size.width,
                                        height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        }
    }
    
    @IBAction func playPauseTapped(_ sender: UIButton) {
        togglePlayPause()
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        guard let episode = episode else { return }
        dbService.manageFavoriteEpisode(with: episode, state: sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        let activityViewController = UIActivityViewController(activityItems: [episode?.audio ?? "", episode?.channelTitle ?? ""], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.airDrop]
        present(activityViewController, animated: true)
        sender.isSelected = !sender.isHighlighted
    }
    
    @IBAction func downTapped(_ sender: UIButton) {
        dismissModal()
    }
}

extension EpisodeModalViewController: AudioServiceDataSource {
    func initializeTimeProgress(minimumTime: Float, maximumTime: Float) {
        episodeProgress.minimumValue = minimumTime
        episodeProgress.maximumValue = maximumTime
    }
    
    func setTimeProgressInTimeInterval(time: Float, duration: String, currentTime: String) {
        episodeProgress.value = time
        episodeUpdateTime.text = currentTime
        episodeTotalTime.text = duration
    }
    
    func showLoading(alpha: CGFloat) {
        loading.alpha = alpha
    }
}
