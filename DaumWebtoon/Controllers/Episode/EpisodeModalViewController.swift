//
//  DetailWeatherViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 06/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit
import AVFoundation

class EpisodeModalViewController: UIViewController {

    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeProgress: UISlider!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var episodeTotalTime: UILabel!
    @IBOutlet weak var episodeUpdateTime: UILabel!
    @IBOutlet weak var episodePlayContainer: UIView!
    @IBOutlet weak var episodeThumbnail: UIImageView!
    @IBOutlet weak var episodeTitleInContainer: UILabel!
    
    var episode: Episode?
    
    private var buttonSelected = false
    private var audioPlayer: AVAudioPlayer?
    private var audioTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeEpisode()
        initializeViews()
    }
    
    private func initializeViews() {
        episodePlayContainer.isHidden = true
        episodePlayContainer.layer.borderWidth = 0.4
        episodePlayContainer.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func initializeEpisode() {
        guard let episode = self.episode else { return }
        
        let (h,m,s) = episode.duration.secondsToHoursMinutesSeconds()
        
        episodeTitle.text = episode.title
        episodeTitleInContainer.text = episode.title
        episodeTotalTime.text = "\(h):\(m):\(s)"
        
        FetchAudioService.shared.execute(audioUrl: episode.audio) { [weak self] (data) in
            guard let self = self else { return }

            do {
                try
                    self.audioPlayer = AVAudioPlayer.init(data: data)
                    self.audioPlayer?.delegate = self
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
        
        FetchImageService.shared.execute(imageUrl: episode.thumbnail) { [weak self] (image) in
            guard let self = self else { return }
            
            self.episodeThumbnail.image = image
        }
    }
    
    // MARK :- private methods
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
        
        let minute : Int = Int(time / 60)
        let second : Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond : Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText : String = String(format : "%02ld:%02ld:%02ld", minute, second, milisecond)
        
        episodeUpdateTime.text = timeText
    }
    
    private func invalidateTimer() {
        self.audioTimer?.invalidate()
        self.audioTimer = nil
    }
    
    // MARK :- event handling
    @IBAction func playPauseTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1, 2:
            sender.isSelected = !sender.isSelected
            
            if sender.isSelected {
                audioPlayer?.play()
                makeAndFireTimer()
            } else {
                audioPlayer?.pause()
                invalidateTimer()
            }
            
            buttonSelected = !sender.isSelected
        default: return
        }
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isHighlighted
    }
    
}

extension EpisodeModalViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}
