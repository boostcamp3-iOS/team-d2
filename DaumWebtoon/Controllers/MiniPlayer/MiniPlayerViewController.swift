//
//  MiniPlayerViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 19/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class MiniPlayerViewController: UIViewController {

    @IBOutlet weak var episodeThumbnail: UIImageView!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var loading: UILabel!
    
    var episode: Episode? {
        didSet {
            setupViews()
            setupAndPlayAudio()
            setupAudioTimer()
            addRecentEpisode()
        }
    }
    
    private var audioTimer : Timer?
    private let audioService = AudioService.shared
    private var episodeModalViewController: EpisodeModalViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let y = UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.size.height + 100)
        view.frame = CGRect(x: 0, y: y, width: view.superview?.frame.width ?? 0, height: 100)
    }
    
    private func setupViews() {
        guard let episode = self.episode else { return }
        
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
        present(episodeModalViewController, animated: true, completion: nil)
        
        self.episodeModalViewController = episodeModalViewController
    }
    
    @IBAction func playPauseDidTapped(_ sender: UIButton) {
        audioService.togglePlayPause()
        sender.isSelected = !sender.isSelected
    }
    
    @objc func timeInterval(){
        audioService.timeInterval()
    }
}

extension MiniPlayerViewController: AudioServiceDataSource {
    func showLoading(alpha: CGFloat) {
        loading.alpha = alpha
    }
}
