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
    
    weak var delegate: EpisodeModalViewDelegate?
    
    var episode: Episode?
    
    private let audioSession = AVAudioSession.sharedInstance()
    private let dbService = DatabaseService()
    
    private var audioUrl: String?
    private var buttonSelected = false
    private var audioPlayer: AVAudioPlayer?
    private var audioTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudioSession()
        setupLikeViewState()
        
        initializeEpisode()
        initializeViews()
    }
    
    private func initializeViews() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func initializeEpisode() {
        guard let episode = self.episode else { return }
        
        let (h,m,s) = episode.duration.secondsToHoursMinutesSeconds()
        
        audioUrl = episode.audio
        episodeTitle.text = episode.title
        episodeTotalTime.text = "\(h):\(m):\(s)"
        
        FetchAudioService.shared.execute(audioUrl: episode.audio) { [weak self] (data) in
            guard let self = self else { return }

            do {
                try self.audioPlayer = AVAudioPlayer.init(data: data)
            } catch let error as NSError {
                print("플레이어 초기화 실패")
                print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
            }

            self.episodeProgress.maximumValue = Float(self.audioPlayer?.duration ?? 0)
            self.episodeProgress.minimumValue = 0
            self.episodeProgress.value = Float(self.audioPlayer?.currentTime ?? 0)
        }
        
        FetchImageService.shared.execute(imageUrl: episode.image) { [weak self] (image) in
            guard let self = self else { return }
            self.episodeImage.image = image
        }
    }
    
    // MARK :- private methods
    private func setupLikeViewState() {
        
    }
    
    private func setupAudioSession() {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback,
                                    mode: .default,
                                    policy: .longForm,
                                    options: [])
            try audioSession.setActive(true, options: [])
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
    }

    private func makeAndFireTimer() {
        self.audioTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] (timer : Timer) in
            guard
                let self = self,
                self.episodeProgress.isTracking == false else { return }

            self.updateEpisodeTime(time: self.audioPlayer?.currentTime)
            self.episodeProgress.value = Float(self.audioPlayer?.currentTime ?? 0)
        })
    }

    private func updateEpisodeTime(time: TimeInterval?) {
        guard let time = time else { return }
        episodeUpdateTime.text = time.stringFromTimeInterval()
    }

    private func invalidateTimer() {
        audioTimer?.invalidate()
        audioTimer = nil
    }

    private func playAudio() {
        audioPlayer?.play()
    }

    private func pauseAudio() {
        audioPlayer?.pause()
    }
    
    private func dismissModal() {
        delegate?.showHeaderImageView()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK :- event handling
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
        if sender.isSelected {
            playAudio()
            makeAndFireTimer()
        } else {
            pauseAudio()
            invalidateTimer()
        }
        
        sender.isSelected = !sender.isSelected
        buttonSelected = !sender.isSelected
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        guard let episode = episode else { return }
        
        if sender.isSelected {
            dbService.delete(from: .favorite, target: episode)
        } else {
            dbService.insertInEpisode(with: episode)
            dbService.insertInDependent(with: episode, from: .favorite)
        }
        
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

