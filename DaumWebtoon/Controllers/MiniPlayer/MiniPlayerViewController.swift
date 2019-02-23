//
//  MiniPlayerViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 19/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum LoadingStatus: CGFloat {
    case success = 0.0
    case loading = 1.0
}

protocol MiniPlayerDelegate: class {
    func removeMiniPlayer()
}

class MiniPlayerViewController: UIViewController {

    @IBOutlet weak var episodeThumbnail: UIImageView!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var loading: UILabel?
    @IBOutlet weak var playPauseButton: UIButton!
    
    weak var delegate: MiniPlayerDelegate?
    var episode: Episode? {
        didSet {
            setupViews()
            setupAndPlayAudio()
            setupAudioTimer()
            addRecentEpisode()
        }
    }
    
    private var isLoading: CGFloat = 1.0
    private var audioTimer : Timer?
    private let audioService = AudioService.shared
    private var episodeModalViewController: EpisodeModalViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPosition()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPosition()
    }
    
    private func setupPosition() {
        var y: CGFloat = 0.0
        if UIDevice.current.hasNotch {
            y = UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.size.height + 32)
        } else {
            y = UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.size.height + 54)
        }
        
        view.frame = CGRect(x: 0, y: y, width: view.superview?.frame.width ?? 0, height: 76)
    }
    
    private func setupViews() {
        guard let episode = self.episode else { return }
        
        loading?.alpha = 1
        episodeTitle.alpha = 0
        episodeTitle.text = episode.title
        FetchImageService.shared.execute(imageUrl: episode.thumbnail) { [weak self] (image) in
            guard let self = self else { return }
            self.episodeThumbnail.image = image
        }
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(miniPlayerDidTapped(_:))))
    }
    
    private func setupAndPlayAudio() {
        guard let episode = self.episode else { return }
        
        audioService.dataSource = self
        audioService.setupAndPlayAudio(audioUrl: episode.audio)
    }
    
    private func setupAudioTimer() {
        audioTimer = Timer(timeInterval: 0.001, target: self, selector: #selector(EpisodeModalViewController.timeInterval), userInfo: nil, repeats: true)
        RunLoop.current.add(audioTimer!, forMode: RunLoop.Mode.common)
    }
    
    private func addRecentEpisode() {
        let dbService = DatabaseService()
        guard let episode = self.episode else { return }
        dbService.addRecentEpisode(with: episode)
    }
    
    // MARK :- event handling
    @objc func miniPlayerDidTapped(_ gesture: UITapGestureRecognizer) {
        guard let episodeModalViewController = UIStoryboard(name: "PodCast", bundle: nil)
            .instantiateViewController(withIdentifier: "Episode") as? EpisodeModalViewController else { return }
        episodeModalViewController.episode = episode
        episodeModalViewController.playButtonSelected = playButtonSelected
        episodeModalViewController.delegate = self
        present(episodeModalViewController, animated: true, completion: nil)
        
        self.episodeModalViewController = episodeModalViewController
    }
    
    @objc func timeInterval(){
        audioService.timeInterval()
    }
    private var playButtonSelected = false
    @IBAction func playPauseDidTapped(_ sender: UIButton) {
        audioService.togglePlayPause()
        
        if isLoading == LoadingStatus.success.rawValue {
            sender.isSelected = !sender.isSelected
            playButtonSelected = sender.isSelected
        }
    }
    
    @IBAction func exitTapped(_ sender: UIButton) {
        audioService.stopAudio()
        
        view.removeFromSuperview()
        dismiss(animated: true, completion: nil)
        delegate?.removeMiniPlayer()
    }
}

extension MiniPlayerViewController: AudioServiceDataSource {
    func showLoading(alpha: CGFloat) {
        loading?.alpha = alpha
        isLoading = alpha
    }
    
    func showTitle(alpha: CGFloat) {
        episodeTitle.alpha = alpha
    }
}

extension MiniPlayerViewController: EpisodeModalViewDelegate {
    func showPlayPauseState(isSelected: Bool) {
        playPauseButton.isSelected = isSelected ? true : false
        playButtonSelected = isSelected
    }
}
