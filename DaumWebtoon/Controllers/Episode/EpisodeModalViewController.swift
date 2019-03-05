//
//  DetailWeatherViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 06/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol EpisodeModalViewDelegate: class {
    @objc optional func playPauseAudio(state: Bool)
    @objc optional func showHeaderImageView()
    @objc optional func showPlayPauseState(isSelected: Bool)
}

class EpisodeModalViewController: UIViewController {

    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeProgress: UISlider!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var episodeTotalTime: UILabel!
    @IBOutlet weak var episodeUpdateTime: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var loading: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    weak var delegate: EpisodeModalViewDelegate?
    
    var episode: Episode?
    var playButtonSelected = false
    
    private let dbService = DatabaseService()
    private let audioService = AudioService.shared
    
    private var presenter: EpisodeModalPresenter?
    private var audioUrl: String?
    private var audioTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = EpisodeModalPresenter(audioService: audioService, dbService: dbService)
        presenter?.attachView(view: self)
        presenter?.fetchEpisodeImage(imageUrl: episode?.image)
        
        setupFavoriteViewState()
        setupPlayPauseState()
        setupViews()
        setupAudio()
    }
    
    deinit {
        presenter?.detachView()
    }
    
    private func setupPlayPauseState() {
        playPauseButton.isSelected = playButtonSelected
    }
    
    private func setupViews() {
        guard let episode = self.episode else { return }
        
        episodeTitle.text = episode.title
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                         action: #selector(handlePanGesture(_:))))
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
        presenter?.isFavoriteEpisode(episode: episode)
    }
    
    // MARK :- event handling
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        presenter?.sliderValueChanged(value: sender.value)
    }
    
    @objc func timeInterval(){
        presenter?.timeInterval()
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        presenter?.handlePanGesture(recognizer: recognizer)
    }
    
    @IBAction func playPauseTapped(_ sender: UIButton) {
        presenter?.togglePlayPause()
        sender.isSelected = !sender.isSelected
        delegate?.showPlayPauseState?(isSelected: sender.isSelected)
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        guard let episode = episode else { return }
        presenter?.manageFavoriteEpisode(episode: episode, state: sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        let activityViewController = UIActivityViewController(activityItems: [episode?.audio ?? "", episode?.channelTitle ?? ""], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.airDrop]
        present(activityViewController, animated: true)
        sender.isSelected = !sender.isHighlighted
    }
    
    @IBAction func downTapped(_ sender: UIButton) {
        dismiss()
    }
}

extension EpisodeModalViewController: EpisodeModalView {
    func showEpisodeImage(image: UIImage) {
        self.episodeImage.image = image
        self.episodeImage.roundedCorner()
    }
    
    func showFavoriteState(isFavorite: Bool) {
        favoriteButton.isSelected = isFavorite
    }
    
    func draggingTouchScreen(position: CGPoint, recognizer: UIPanGestureRecognizer) {
        view.center = position
        recognizer.setTranslation(CGPoint.zero, in: view)
    }
    
    func dismiss() {
        delegate?.showHeaderImageView?()
        dismiss(animated: true, completion: nil)
    }
    
    func aniamteToOriginalFrame() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.view.frame.size.width,
                                     height: self.view.frame.size.height)
        })
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
